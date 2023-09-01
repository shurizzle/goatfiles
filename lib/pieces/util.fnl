(local {: realpath : symlink : lstat : unlink : path-join : path-relative}
       (require :fs))
(local {: cmd? : exec} (require :os-util))

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

(fn need-cmds [...]
  (each [_ cmd (pairs [...])]
    (when cmd
      (when (not (cmd? cmd))
        (io.stderr:write (.. "cannot find " cmd
                             " command, please install it to continue")))))
  nil)

(fn is-dir [path]
  (match (lstat path)
    (nil _ :ENOENT) nil
    (nil err _) (error err)
    md (if (= :directory md.type)
           true
           false)))

(fn trim [s]
  (string.gsub s "^%s*(.-)%s*$" "%1"))

(fn is-git-repo [path]
  (let [(code stdout) (exec :git {:args [:rev-parse :--git-dir]
                                  :cwd path
                                  :stdout :capture
                                  :stderr :ignore
                                  :hide true})]
    (if (= 0 code)
        (let [p (trim stdout)
              d (path-join (path-relative path p) :..)
              dir (assert (realpath d))]
          (or (= path dir) (= (assert (realpath path)) dir)))
        false)))

(fn git-remote [path name]
  (let [(code stdout) (exec :git {:args [:remote :get-url name]
                                  :cwd path
                                  :stdout :capture
                                  :stderr :ignore
                                  :hide true})]
    (when (= 0 code)
      (let [url (trim stdout)]
        (when (> (length url) 0)
          url)))))

(fn git-clone [remote path ?args]
  (var args [:clone])
  (when ?args
    (each [_ v (pairs ?args)]
      (table.insert args v)))
  (table.insert args remote)
  (table.insert args path)
  (let [code (exec :git {: args})]
    (when (not= 0 code)
      (error (.. "cannot clone " remote " repository")))))

(fn clone-git-repo [remote path ?args]
  (need-cmds :git)
  (match (is-dir path)
    nil (git-clone remote path ?args)
    true (if (is-git-repo path)
             (when (not= remote (git-remote path :origin))
               (error (.. path " is unmanaged, remove manually to continue")))
             (error (.. path " is unmanaged, remove manually to continue")))
    false (error (.. path " is unmanaged, remove manually to continue"))))

{: create-symlink
 : remove-symlink
 : need-cmds
 : clone-git-repo}
