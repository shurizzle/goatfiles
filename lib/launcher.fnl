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
  (tset _G (fennel.mangle :*project*) dir)
  (set fennel.path (.. fennel.path ";" dir sep :?.fnl))
  (set fennel.path (.. fennel.path ";" dir sep :? sep :init.fnl))
  (set fennel.macro-path (.. fennel.macro-path ";" dir sep :?.fnl))
  (set fennel.macro-path (.. fennel.macro-path ";" dir sep :? sep :init.fnl)))

(match (. arg 1)
  :install (require :install)
  _ (error (.. "invalid action " (. arg 1))))
