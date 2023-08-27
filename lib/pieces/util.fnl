(local uv (require :luv))

(fn create-symlink [src dest]
  (io.stdout:write (.. "ln -s " src " " dest "\n"))
  (match (uv.fs_readlink dest)
    (where path (= :string (type path)))
      (if (= path src)
          nil
          (error (.. dest " is unmanaged, remove manually to continue")))
    (_ _ :ENOENT) (assert (uv.fs_symlink src dest {}))
    (_ _ :EINVAL)
      (error (.. dest " is unmanaged, remove manually to continue"))
    (_ err _) (error err)))

(fn remove-symlink [src dest]
  (io.stdout:write (.. "rm -f " src))
  (match (uv.fs_readlink dest)
    (where path (= :string (type path)))
      (if (or (= path src) (= (uv.fs_realpath path) src))
          (assert (uv.fs_unlink dest))
          (error (.. dest " is unmanaged, remove manually")))
    (_ err :ENOENT) nil
    (_ err :EINVAL)
      (error (.. dest " is unmanaged, remove manually"))
    (_ err _) (error err)))

{: create-symlink
 : remove-symlink}
