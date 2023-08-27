(local uv (require :luv))
(local {: path-join : stat : scandir} (require :fs))
(local {: view} (require :fennel))

(fn is-file [path]
  (match (uv.fs_stat path)
    (where md (not= nil md)) (= md.type :file)
    _ false))

(var pieces nil)

(fn retrieve [pieces]
  (fn add-piece [name]
    (when (and (not= name :init)
               (not= name :util))
      (let [piece (require (.. :pieces. name))]
        (if
          (= :function (type piece.cond)) (set piece.cond (piece.cond))
          (= :boolean (type piece.cond)) nil
          (= nil piece.cond) (set piece.cond true)
          (error (.. "inval condition " (view piece.cond) " for piece " name)))
        (tset pieces name piece))))

  (let [base (path-join *project* :lib :pieces)
        dir (scandir base)]
    (each [entry _ dir]
      (if (= (entry:sub -4) :.fnl)
          (when (is-file (path-join base entry))
            (add-piece (entry:sub 1 -5)))
          (let [init (path-join base entry :init.fnl)]
            (when (is-file init)
              (add-piece entry)))))))

(fn []
  (when (not pieces)
    (set pieces (let [p []]
                  (retrieve p)
                  p)))
  pieces)
