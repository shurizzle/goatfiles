(tset _G :unpack (or table.unpack _G.unpack))
(local uv (require :luv))

(local *dir-sep* (package.config:sub 1 1))
(local realpath uv.fs_realpath)
(local pattern-quote (let [pat (.. "([" (: "%^$().[]*+-?" :gsub "(.)" "%%%1") "])")]
                       (lambda [str]
                         (str:gsub pat "%%%1"))))
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

(local *file* (-> (debug.getinfo 1)
                  (. :source)
                  (: :gsub "^@?(.*)$" "%1")
                  ((partial select-ex 1))
                  (realpath)
                  (assert "invalid directory")))
(local *project* (assert (dirname *file*) "invalid directory"))

(fn file-exists [file]
  (not (not (uv.fs_stat file))))

(fn create-symlink [src dest]
  (match (uv.fs_readlink dest)
    (where path (= :string (type path)))
      (if (= path src)
          nil
          (error (.. dest " is unmanaged, remove manually to continue")))
    (_ _ :ENOENT) (assert (uv.fs_symlink src dest {}))
    (_ _ :EINVAL)
      (error (.. dest " is unmanaged, remove manually to continue"))
    (_ err _) (error err)))

(fn remove-symlink [src dest]
  (match (uv.fs_readlink dest)
    (where path (= :string (type path)))
      (if (= path src)
          (assert (uv.fs_unlink dest))
          (error (.. dest " is unmanaged, remove manually")))
    (_ err :ENOENT) nil
    (_ err :EINVAL)
      (error (.. dest " is unmanaged, remove manually"))
    (_ err _) (error err)))
