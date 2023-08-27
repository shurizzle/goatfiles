(fn []
  (local *all* (collect [name p (pairs ((require :pieces)))]
                 (if (and p.cond p.up) (values name p.up))))
 
  (fn keys [xs] (icollect [k _ (pairs xs)] k))

  (local needed (if (= 0 (length arg))
                    (keys *all*)
                    (icollect [_ name (ipairs arg)]
                      (if (. *all* name)
                          name
                          (error (.. "installer " name " doesn't exist"))))))

  (each [_ piece (ipairs needed)]
    (io.stdout:write (.. "Installing " piece "\n"))
    ((. *all* piece))))
