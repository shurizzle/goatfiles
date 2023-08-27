(local uv (require :luv))

(local *dir-sep* (package.config:sub 1 1))
(local realpath uv.fs_realpath)
(fn select-ex [n ...]
  (local x (select n ...))
  x)

(fn -path-split [path]
  (let [sep (pattern-quote *dir-sep*)
        pat (.. "^(.*" sep ")([^" sep "]+)$")]
    (match (path:match pat)
      nil (values nil path)
      (dir file) (values (if (= 0 (length dir))
                             "/"
                             dir)
                         (if (= 0 (length file))
                             nil
                             file)))))
(fn -normalize-dirname [dir]
  (let [sep (pattern-quote *dir-sep*)]
    (fn remove-trailing-sep [path]
      (if (= path *dir-sep*)
          *dir-sep*
          (path:gsub (.. sep :+$) "")))

    (-?> dir
         (: :gsub (.. sep :+) (fn [] *dir-sep*))
         (remove-trailing-sep)
         ((partial select-ex 1)))))

(fn dirname [path]
  (-> (-path-split path)
      (-normalize-dirname)))

(fn filename [path] (select-ex 2 (-path-split path)))

(fn path-split [path]
  (let [(dir file) (-path-split)]
    (values (-?> dir -normalize-dirname)
            file)))

(fn path-join [...]
  (fn raw-join [...]
    (accumulate [res nil
                 _ n (pairs [...])]
      (if (and (not= nil n) (> (length n) 0))
          (if res
              (.. res *dir-sep* n)
              n)
          res)))

  (-normalize-dirname (raw-join ...)))

(local path-sep (let [{: is} (require :platform)]
                  (if is.windows ";" ":")))

{:dir-sep *dir-sep*
 : realpath
 : dirname
 : filename
 : path-split
 : path-join
 : path-sep}
