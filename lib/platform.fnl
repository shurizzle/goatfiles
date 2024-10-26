(macro match-os [& args]
  (let [exprs `(if)
        os (gensym)]
    (each [_ def (ipairs args)]
      (assert-compile (list? def) "Invalid match-os syntax" def)
      (assert-compile (= 2 (length def)) "Invalid match-os syntax" def)
      (let [match-str (. def 1)
            os-name (. def 2)]
        (assert-compile (sym? match-str) "Invalid matching string os" match-str)
        (assert-compile (sym? os-name) "Invalid os name" os-name)
        (table.insert exprs `(: ,os :match ,(tostring match-str)))
        (table.insert exprs (tostring os-name))))
    (table.insert exprs :unknown)
    `(let [uv# (require :luv)
           ,os (. (uv#.os_uname) :sysname)]
       ,exprs)))

(local os (match-os (Windows windows) (Linux linux) (Darwin macos)
                    (FreeBSD freebsd) (DragonFly dragonflybsd) (NetBSD netbsd)
                    (OpenBSD openbsd)))

(var _is {:win (= os :windows)
          :lin (= os :linux)
          :mac (= os :macos)
          :fbsd (= os :freebsd)
          :dfbsd (= os :dragonflybsd)
          :nbsd (= os :netbsd)
          :obsd (= os :openbsd)
          :termux (not= nil (_G.os.getenv :TERMUX_APP_PID))
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
(set _is.unix (or _is.mac _is.fbsd _is.dfbsd _is.nbsd _is.obsd _is.lin
                  _is.termux))

(lambda readonly [t]
  (setmetatable {} {:__index #(. t $2) :__newindex (fn [] nil)}))

(readonly {: os :is (readonly _is)})

