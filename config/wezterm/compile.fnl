(local fennel (require :fennel))
(macro filename [x] x.filename)
(local *dir-sep* (package.config:sub 1 1))
(local pattern-quote (let [pat (.. "([" (: "%^$().[]*+-?" :gsub "(.)" "%%%1") "])")]
                       (lambda [str]
                         (str:gsub pat "%%%1"))))
(local *cur-dir* (let [q-sep (pattern-quote *dir-sep*)
                       pat (.. "^(.*)" q-sep "[^" q-sep "]+$")
                       (?dir ok) (: (filename fennel) :gsub pat "%1")]
                   (if (not= 0 ok) ?dir ".")))
(fn path-join [...] (table.concat [...] *dir-sep*))

(fn slurp [path]
  (let [f (assert (io.open path :rb))
        content (f:read :*all)]
    (f:close)
    content))

(fn spit [content path]
  (let [(f err) (io.open path :wb)]
    (if f
        (do
          (f:write content)
          (f:close))
        (error err)))
  nil)

(local *in*  (path-join *cur-dir* :wezterm.fnl))
(local *out* (path-join *cur-dir* :wezterm.lua))

(-> (slurp *in*)
    (fennel.compile-string {:filename *in*
                            :requireAsInclude true
                            :skipInclude [:wezterm]})
    (spit *out*))
