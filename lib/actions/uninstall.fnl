(local *all* (collect [name p (pairs ((require :pieces)))]
               (if (and p.cond p.down) (values name p.down))))

(fn keys [xs]
  (icollect [k _ (pairs xs)] k))

(local needed
       (if (= 0 (length arg))
           (keys *all*)
           (icollect [_ name (ipairs arg)]
             (if (. *all* name)
                 name
                 (= :list name)
                 (do
                   (each [k _ (pairs *all*)]
                     (io.stdout:write k)
                     (io.stdout:write "\n"))
                   (os.exit 0))
                 (error (.. "installer " name " doesn't exist"))))))

(each [_ piece (ipairs needed)]
  (io.stdout:write (.. "Uninstalling " piece "\n"))
  ((. *all* piece)))

