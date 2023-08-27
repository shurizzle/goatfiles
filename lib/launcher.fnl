(local fennel (require :fennel))
(fennel.install)
(tset _G :unpack (or table.unpack _G.unpack))
(tset _G
      (fennel.mangle :pattern-quote)
      (let [pat (.. "(["
                    (: "%^$().[]*+-?" :gsub "(.)" "%%%1")
                    "])")]
        (lambda [str]
          (str:gsub pat "%%%1"))))
(local uv (require :luv))
(fn select-ex [n ...]
  (local x (select n ...))
  x)
(tset _G
      (fennel.mangle :*file*)
      (-> (debug.getinfo 1)
          (. :source)
          (: :gsub "^@?(.*)$" "%1")
          ((partial select-ex 1))
          (uv.fs_realpath)
          (assert "invalid directory")))
(let [sep (package.config:sub 1 1)
      esep (pattern-quote sep)
      pat (.. "^(.*)" esep "[^" esep "]+$")
      (dir _) (*file*:match pat)]
  (set fennel.path (.. fennel.path ";" dir sep :?.fnl))
  (set fennel.path (.. fennel.path ";" dir sep :? sep :init.fnl))
  (set fennel.macro-path (.. fennel.macro-path ";" dir sep :?.fnl))
  (set fennel.macro-path (.. fennel.macro-path ";" dir sep :? sep :init.fnl))

  ; XXX: do NOT use async versions in "fs" module
  (local realpath uv.fs_realpath)
  (local {: path-join} (require :fs))
  (tset _G (fennel.mangle :*project*) (realpath (path-join dir :..))))

(if (uv.loop_alive)
    (uv.stop))

(local routines [])

(match (table.remove arg 1)
  :install (table.insert routines (coroutine.create (require :install)))
  _ (error (.. "invalid action " (. arg 1))))

(fn run-routines []
  (var i 1)
  (while (<= i (length routines))
    (let [co (. routines i)]
      (assert (coroutine.resume co))
      (match (coroutine.status co)
        :dead (table.remove routines i)
        :suspended (set i (+ i 1))
        status (error (.. "unknown coroutine status " status))))))

(fn step [?mode]
  (if (> (length routines) 0)
      (let [continue? (uv.run (or ?mode :once))]
        (run-routines)
        (and continue? (> (length routines) 0)))
      false))

(fn loop []
  (while (step)))

(when (step :nowait)
  (loop))
