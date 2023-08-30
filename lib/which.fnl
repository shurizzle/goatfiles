(local {: is} (require :platform))

(if
  is.unix
    (do
      (local {: path} (require :os-util))
      (local {: access : path-join : lstat} (require :fs))
      (local {: filter-map} (require :iter))

      (fn file-or-link? [path]
        (match (lstat path)
          (nil _ :ENOENT) false
          (nil err _) (error err)
          md (or (= md.type :link) (= md.type :file))))

      (fn executable? [path]
        (match (access path :X)
          (nil _ :ENOENT) false
          (nil err _) (error err)
          res res))

      (fn valid-bin-in-path [bin path]
        (let [apath (path-join path bin)]
          (when (and (file-or-link? apath) (executable? apath))
            apath)))

      (fn which-all [bin]
        (filter-map (partial valid-bin-in-path bin) (path)))

      (fn which [bin]
        ((which-all bin)))

      {: which-all
       : which})
    (error "unsupported platform"))
