(local wezterm (require :wezterm))
(local {: getenv} os)

(local (arch os) (let [i1 (string.find wezterm.target_triple :-)
                       arch (string.sub wezterm.target_triple 1 (- i1 1))
                       i2 (string.find wezterm.target_triple :- (+ i1 1))
                       i3 (string.find wezterm.target_triple :- (+ i2 1))
                       os (if i3
                              (string.sub wezterm.target_triple
                                          (+ i2 1) (- i3 1))
                              (string.sub wezterm.target_triple (+ i2 1)))]
                  (values (string.lower arch) (string.lower os))))
(local os (if (= :darwin os) :macos os))

(var _is {:win      (= os :windows)
          :lin      (= os :linux)
          :mac      (= os :macos)
          :fbsd     (= os :freebsd)
          :dfbsd    (= os :dragonflybsd)
          :nbsd     (= os :netbsd)
          :obsd     (= os :openbsd)
          :termux   (not (nil? (getenv :TERMUX_APP_PID)))
          :unknown  (= os :unknown)})

(each [k v (pairs {:windows      :win
                   :linux        :lin
                   :macos        :mac
                   :freebsd      :fbsd
                   :dragonflybsd :dfbsd
                   :netbsd       :nbsd
                   :openbsd      :obsd})]
  (tset _is k (. _is v)))

(tset _is :bsd (or _is.mac _is.fbsd _is.dfbsd _is.nbsd _is.obsd))

(fn ro [t] (setmetatable {} {:__index #(. t $2) :__newindex #nil}))

(ro {: os :is (ro _is) : arch})
