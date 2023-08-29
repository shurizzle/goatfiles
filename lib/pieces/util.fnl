(local {: realpath : symlink : lstat : unlink} (require :fs))

(fn contains? [haystack needle]
  (when (not= nil haystack)
    (each [_ v (pairs haystack)]
      (when (= v needle)
        (lua "return true"))))
  false)

(fn validate [src dest ?valid-dests]
  (match (lstat dest)
    (nil _ :ENOENT) :not-found
    (nil err _) (error err)
    md (if (= md.type :link)
           (match (realpath dest)
             (nil _ :ENOENT) :not-found
             (nil err _) (error err)
             path (if (= path src)
                      :same
                      (if (contains? ?valid-dests path)
                          :owned
                          :unowned)))
           :unowned)))

(fn create-symlink [src dest ?valid-dests ?opts]
  (fn link* []
    (io.stdout:write (.. "ln -s " src " -> " dest "\n"))
    (assert (symlink src dest ?opts)))

  (match (validate src dest ?valid-dests)
    :not-found (link*)
    :owned (do
             (assert (unlink dest))
             (link*))
    :same nil
    :unowned (error (.. dest " is unmanaged, remove it manually to continue")))
  nil)

(fn remove-symlink [src dest ?valid-dests]
  (fn unlink* []
    (io.stdout:write (.. "rm " dest "\n"))
    (assert (unlink dest)))

  (match (validate src dest ?valid-dests)
    (where (or :same :owned)) (unlink*)
    :not-found nil
    :unowned (error (.. dest " is unmanaged, remove it manually to continue"))))

(fn need-cmds [& cmds]
  (each [_ cmd (ipairs cmds)]
    :todo
    )
  nil)

{: create-symlink
 : remove-symlink}
