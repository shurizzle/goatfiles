(local uv (require :luv))

(fn create-symlink [src dest ?opts]
  (fn link []
    (io.stdout:write (.. "ln -s " src " " dest "\n"))
    (assert (uv.fs_symlink src dest ?opts)))

  (match (uv.fs_lstat dest)
    (where md (= :table (type md)))
      (if (= md.type :link)
          (match (uv.fs_realpath dest)
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
    (assert (uv.fs_unlink dest)))

  (match (uv.fs_lstat dest)
    (where md (= :table (type md)))
      (if (= md.type :link)
          (match (uv.fs_realpath dest)
            (where path (= :string (type path)))
              (if (= path src)
                  (unlink)
                  (error (.. dest " is unmanaged, remove it manually to continue")))
            (_ _ :ENOENT) nil
            (_ err _) (error err))
          (.. dest " is unmanaged, remove it manually"))
    (_ _ :ENOENT) nil
    (_ err _) (error err)))

{: create-symlink
 : remove-symlink}
