(local uv (require :luv))
(local {: path-join} (require :fs))
(local {: view} (require :fennel))

(fn open-dir [path]
  (match (uv.fs_scandir path)
    nil #nil
    (where fs (not= nil fs))
      (fn []
        (match (uv.fs_scandir_next fs)
          nil nil
          (where entry (not= nil entry)) entry
          (_ err _) (error err)))
    (_ _ :ENOENT) #nil
    (_ err _) (error err)))

(fn is-file [path]
  (match (uv.fs_stat path)
    (where md (not= nil md)) (= md.type :file)
    _ false))

(local pieces [])

(fn add-piece [name]
  (when (and (not= name :alacritty)
             (not= name :init)
             (not= name :util))
    (let [piece (require (.. :pieces. name))]
      (if
        (= :function (type piece.cond)) (set piece.cond (piece.cond))
        (= :boolean (type piece.cond)) nil
        (= nil piece.cond) (set piece.cond true)
        (error (.. "inval condition " (view piece.cond) " for piece " name)))
      (tset pieces name piece))))

(let [base (path-join *project* :lib :pieces)]
  (each [entry _ (open-dir base)]
    (if (= (entry:sub -4) :.fnl)
        (when (is-file (path-join base entry))
          (add-piece (entry:sub 1 -5)))
        (let [init (path-join base entry :init.fnl)]
          (when (is-file init)
            (add-piece entry))))))

pieces
