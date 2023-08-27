(local fennel (require :fennel))
(local *all* (collect [name p (pairs (require :pieces))]
               (if (and p.cond p.up) (values name p.up))))

; TODO: handle args
(print (fennel.view *all* {}))
