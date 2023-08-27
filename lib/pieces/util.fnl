(local uv (require :luv))
(local {: realpath : symlink : lstat : unlink} (require :fs))

(fn create-symlink [src dest ?opts]
  (fn link []
    (io.stdout:write (.. "ln -s " src " " dest "\n"))
    (assert (symlink src dest ?opts)))

  (match (lstat dest)
    (where md (= :table (type md)))
      (if (= md.type :link)
          (match (realpath dest)
            (where path (= :string (type path)))
              (if (= path src)
                  nil
                  (error (.. dest " is unmanaged, remove it manually to continue")))
            (_ _ :ENOENT) (link)
            (_ err _) (error err))
          (error (.. dest " is unmanaged, remove it manually to continue")))
    (_ _ :ENOENT) (link)
    (_ err _) (error err)))

(fn remove-symlink [src dest]
  (fn unlink []
    (io.stdout:write (.. "rm -f " src))
    (assert (unlink dest)))

  (match (lstat dest)
    (where md (= :table (type md)))
      (if (= md.type :link)
          (match (realpath dest)
            (where path (= :string (type path)))
              (if (= path src)
                  (unlink)
                  (error (.. dest " is unmanaged, remove it manually to continue")))
            (_ _ :ENOENT) nil
            (_ err _) (error err))
          (.. dest " is unmanaged, remove it manually"))
    (_ _ :ENOENT) nil
    (_ err _) (error err)))

(fn need-cmds [& cmds]
  (each [_ cmd (ipairs cmds)]
    :todo
    )
  nil)

{: create-symlink
 : remove-symlink}
