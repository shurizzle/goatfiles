(local wezterm (require :wezterm))
(local {: getenv} os)

(local (arch os)
       (let [i1 (string.find wezterm.target_triple "-")
             arch (string.sub wezterm.target_triple 1 (- i1 1))
             i2 (string.find wezterm.target_triple "-" (+ i1 1))
             i3 (string.find wezterm.target_triple "-" (+ i2 1))
             os (if i3
                    (string.sub wezterm.target_triple (+ i2 1) (- i3 1))
                    (string.sub wezterm.target_triple (+ i2 1)))]
         (values (string.lower arch) (string.lower os))))

(local os (if (= :darwin os) :macos os))

(local _is {:win (= os :windows)
            :lin (= os :linux)
            :mac (= os :macos)
            :fbsd (= os :freebsd)
            :dfbsd (= os :dragonflybsd)
            :nbsd (= os :netbsd)
            :obsd (= os :openbsd)
            :termux (not (nil? (getenv :TERMUX_APP_PID)))
            :unknown (= os :unknown)})

(each [k v (pairs {:windows :win
                   :linux :lin
                   :macos :mac
                   :freebsd :fbsd
                   :dragonflybsd :dfbsd
                   :netbsd :nbsd
                   :openbsd :obsd})]
  (tset _is k (. _is v)))

(set _is.bsd (or _is.mac _is.fbsd _is.dfbsd _is.nbsd _is.obsd))

(fn home []
  (if _is.win
      (.. (getenv :HOMEDRIVE) (getenv :HOMEPATH))
      (getenv :HOME)))

(local path (let [p (or (getenv :PATH) "")
                  h (home)
                  user-dirs [(.. h :/.local/bin) (.. h :/.cargo/bin)]
                  ;; GUI apps on macOS get launchd's minimal PATH, which ignores Homebrew
                  dirs (if _is.win [] _is.mac
                           (doto user-dirs
                             (table.insert :/opt/homebrew/bin)
                             (table.insert :/opt/homebrew/sbin))
                           user-dirs)
                  missing (icollect [_ d (ipairs dirs)]
                            (when (not (string.find (.. ":" p ":")
                                                    (.. ":" d ":") 1 true))
                              d))]
              (if (= 0 (length missing)) p
                  ;; avoid a trailing ":" (= cwd in PATH) when PATH was empty
                  (= "" p) (table.concat missing ":")
                  (.. (table.concat missing ":") ":" p))))

(fn ro [t]
  (setmetatable {} {:__index #(. t $2) :__newindex #nil}))

(ro {: os :is (ro _is) : arch : home : path})
