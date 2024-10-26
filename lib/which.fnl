(local {: is} (require :platform))

(if is.unix
    (do
      (local {: path} (require :os-util))
      (local {: access : path-join : lstat} (require :fs))
      (local {: filter-map} (require :iter))

      (fn file-or-link? [path]
        (case (lstat path)
          (nil _ :ENOENT) false
          (nil err _) (error err)
          md (or (= md.type :link) (= md.type :file))))

      (fn executable? [path]
        (case (access path :X)
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

      {: which-all : which})
    (do
      (local {: path-join : stat : scandir} (require :fs))
      (local {: filter-map} (require :iter))
      (local {:path env-path} (require :os-util))

      (fn exts []
        (icollect [e ((. (require :os-util) :path-ext))]
          e))

      (fn file? [path]
        (case (stat path)
          (nil _ :ENOENT) false
          (nil err _) (error err)
          md (= md.type :file)))

      (var some nil)
      (lua "some = function(f, haystack)
           for _, v in pairs(haystack) do
             local t = f(v)
             if t then return t end
           end
         end")

      (fn strip-suffix [str suff]
        (when (and (> (length str) (length suff))
                   (= (str:sub (- (length suff))) suff))
          (str:sub 1 (- (+ 1 (length suff))))))

      (fn file-matcher [bin* exts]
        (local bin (string.upper bin*))
        (let [name (some (partial strip-suffix bin) exts)]
          (if name
              (fn [file*]
                (let [file (string.upper file*)]
                  (if (and (file? file) (= bin file))
                      file*
                      (when (-?> (some (partial strip-suffix file) exts)
                                 ((fn [file] (and (file? file) (= name file)))))
                        file*))))
              (fn [file*]
                (let [file (string.upper file*)]
                  (when (-?> (some (partial strip-suffix file) exts)
                             (= bin))
                    file*))))))

      (fn search-in [dir matcher]
        (filter-map (fn [file]
                      (-?>> (matcher file) (path-join dir)))
                    (scandir dir)))

      (fn which-all [bin]
        (let [exts (exts)
              matcher (file-matcher bin exts)
              paths (env-path)]
          (var searcher nil)
          (fn []
            (var res nil)

            (fn step []
              (if searcher
                  (let [r (searcher)]
                    (if r
                        (do
                          (set res r) true)
                        (do
                          (set searcher nil) false)))
                  (let [dir (paths)]
                    (if dir
                        (do
                          (set searcher (search-in dir matcher))
                          false)
                        true))))

            (while (not (step)))
            res)))

      (fn which [bin]
        ((which-all bin)))

      {: which-all : which}))

