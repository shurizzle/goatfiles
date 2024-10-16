(local DEFAULTS {:policy :current :session :yazi})
(local get-state
       (ya.sync (fn [state name] (or (. state name) (. DEFAULTS name)))))

(fn ne [msg]
  "Notify error"
  (ya.notify {:title :tmux :content msg :timeout 5 :level :error})
  nil)

(fn get-output [cmd]
  "Run the command and get the right-trimmed output. Spawn errors are reported 
  and 666 is returned. Returns nil if the command exited with an error."
  (local (out err) (cmd:output))
  (if err
      (do
        (ne (.. "Error: " (tostring err)))
        666)
      (and (not= nil out) out.status.success out.stdout)
      (let [stdout (out.stdout:match "(.-)%s*$")]
        (when (not= 0 (string.len stdout)) stdout))))

(fn get-session [bin]
  "Get the current tmux session, or nil"
  (when (os.getenv :TMUX)
    (-> (Command bin)
        (: :arg :display-message)
        (: :arg :-p)
        (: :arg "#S")
        (get-output))))

(local get-cwd (ya.sync (fn [] (tostring cx.active.current.cwd))))

(fn run-tmux [cmd]
  "Add common flags to tmux' command, spawn the command and report errors"
  (local (out err) (-> cmd
                       (: :arg :-e)
                       (: :arg (.. :YAZI_ID= (tostring (os.getenv :YAZI_ID))))
                       (: :arg :-e)
                       (: :arg
                          (.. :YAZI_LEVEL= (tostring (os.getenv :YAZI_LEVEL))))
                       (: :arg :-c)
                       (: :arg (get-cwd))
                       (: :arg (or (get-state :shell) (os.getenv :SHELL)))
                       (: :stdin Command.INHERIT)
                       (: :stdout Command.INHERIT)
                       (: :stderr Command.PIPED)
                       (: :output)))
  (if err (ne (.. "Error: " (tostring err)))
      (not out.status.success) (ne (.. "(" out.status.code ") " out.stderr))))

(fn spawn-session [bin session]
  "Spawn a window in the yazi session, create new if it doesn't exist"
  (local (out err) (-> (Command bin)
                       (: :arg :has-session)
                       (: :arg :-t)
                       (: :arg session)
                       (: :output)))
  (if err
      (ne (.. "Error: " (tostring err)))
      (let [cmd (let [cmd (: (Command bin) :env :TMUX "")]
                  (if out.status.success
                      (-> cmd
                          (: :arg :attach)
                          (: :arg :-t)
                          (: :arg session)
                          (: :arg ";")
                          (: :arg :neww))
                      (-> cmd
                          (: :arg :new)
                          (: :arg :-s)
                          (: :arg session))))
            permit (ya.hide)]
        (run-tmux cmd)
        (permit:drop)
        nil)))

(fn spawn-in-session [bin]
  "Spawn a new window in the current tmux session"
  (-> (Command bin) (: :arg :neww) (run-tmux)))

(fn entry []
  (when (= :windows (ya.target_family))
    (ne "Unsupported OS")
    (lua :return))
  (local bin (-> (Command :which) (: :arg :tmux) (get-output)))
  (when (= 666 bin)
    (lua :return))
  (when (not bin)
    (ne "Please install tmux first")
    (lua :return))
  (local session (get-session bin))
  (when (= 666 session) (lua :return))
  (local ns (get-state :session))
  (if session
      (let [policy (get-state :policy)]
        (if (= session ns) (spawn-in-session bin)
            (= policy :error) (ne (.. "Already in session " session))
            (= policy :nest) (spawn-session bin ns)
            (spawn-in-session bin)))
      (spawn-session bin ns)))

(fn setup [state opts]
  (set state.policy (if (or (not opts.policy) (= "" opts.policy))
                        :current
                        (and opts.policy (not= (type opts.policy) :string))
                        (do
                          (ne (.. "Invalid policy type " (type opts.policy)
                                  ", using 'current'"))
                          :current)
                        (or (= :nest opts.policy) (= :current opts.policy)
                            (= :error opts.policy))
                        opts.policy
                        (do
                          (ne (.. "Invalid policy '" opts.policy
                                  "', using 'current'"))
                          :current)))
  (set state.session (if (or (not opts.session) (= "" opts.session))
                         :yazi
                         (not= (type opts.session) :string)
                         (do
                           (ne (.. "Invalid session type " (type opts.session)
                                   ", using 'yazi'"))
                           :yazi)
                         opts.session))
  (set state.shell (if (or (not opts.shell) (= "" opts.shell)) nil
                       (not= (type opts.shell) :string)
                       (do
                         (ne (.. "Invalid shell type " (type opts.shell)
                                 ", using the system one"))
                         nil) opts.shell)))

{: entry : setup}

