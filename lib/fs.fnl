(local *dir-sep* (package.config:sub 1 1))

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
  (let [(dir file) (-path-split path)]
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

(local {: uv-wrapper} (require :uv-util))

(fn realpath [path]
  (let [(f cb) (uv-wrapper :fs_realpath)]
    (f path cb)))
(fn symlink [path new-path ?flags]
  (let [(f cb) (uv-wrapper :fs_symlink)]
    (f path new-path ?flags cb)))
(fn stat [path]
  (let [(f cb) (uv-wrapper :fs_stat)]
    (f path cb)))
(fn lstat [path]
  (let [(f cb) (uv-wrapper :fs_lstat)]
    (f path cb)))
(fn unlink [path]
  (let [(f cb) (uv-wrapper :fs_unlink)]
    (f path cb)))
(fn scandir* [path]
  (let [(f cb) (uv-wrapper :fs_scandir)]
    (f path cb)))
(fn access [path mode]
  (let [(f cb) (uv-wrapper :fs_access)]
    (f path mode cb)))

(fn scandir [path]
  (let [fs (scandir* path)
        uv (require :luv)]
    (fn []
      (match (uv.fs_scandir_next fs)
        (nil err _) (if err (error err) nil)
        (where entry (not= nil entry)) entry))))

{:dir-sep *dir-sep*
 : dirname
 : filename
 : path-split
 : path-join
 : path-sep
 : realpath
 : symlink
 : lstat
 : stat
 : unlink
 : scandir
 : access}
