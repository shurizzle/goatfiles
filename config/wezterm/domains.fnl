(local wezterm (require :wezterm))

(fn ssh-domains []
  (let [ds (wezterm.default_ssh_domains)]
    (each [_ dom (ipairs ds)]
      (set dom.assume_shell :Posix))
    (each [_ name (ipairs [:vercingetorige
                           :wercingetorige
                           :DomPerignon
                           :filottete])]
      (when (not= name (wezterm.hostname))
        (table.insert ds {: name
                          :remote_address (.. name :.local)
                          :multiplexing (if (= name :filottete) :None
                                            :WezTerm)
                          :assume_shell (if (= name :wercingetorige) :Unknown
                                            :Posix)})))
    ds))

{:ssh_domains (ssh-domains)}

