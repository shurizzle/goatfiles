(local fennel (require :fennel))
(local window (require :window))
(local webview (require :webview))
(local modes (require :modes))
(local soup (require :soup))
(local noscript (require :noscript))

(fn pp [...]
  (each [_ v (ipairs [...])]
    (print (fennel.view v))))

(set noscript.enable_scripts false)

(window.add_signal :init #(set $1.win.decorated false))

(fn redirect [view status]
  ;; TODO: strip out utm_source, etc
  ;; TODO: redirect AMP->HTML
  (fn domain-match? [domain search]
    (or (= domain search)
        (and (>= (length domain) (length search))
             (let [sub (domain:sub (- (+ (length search) 1)))
                   dot (sub:sub 1 1)
                   sub (sub:sub 2)]
               (and (= dot :.) (= sub search))))))

  (when (= status :committed)
    (var uri (soup.parse_uri view.uri))
    (var updated false)
    (when (or (= uri.scheme :http) (= uri.scheme :https))
      (each [origin target (pairs {:twitter.com :nitter.net
                                   :youtube.com :yt.oelrichsgarcia.de})]
        (when (domain-match? uri.host origin)
          (set updated true)
          (set uri.scheme :https)
          (set uri.port 443)
          (set uri.host target))))
    (when updated
      (set view.uri (soup.uri_tostring uri)))))

(webview.add_signal :init (fn [view] (view:add_signal :load-status redirect)))

(modes.add_cmds [[::fennel "Run Fennel code"
                  (fn [_ o]
                    (match o
                      {: arg} (let [value (fennel.eval arg)]
                                (print (fennel.view value)))))]])

(modes.add_binds :normal [["<C-n>" "Go to next tab" #($1:next_tab)]
                          ["<C-p>" "Go to previous tab" #($1:prev_tab)]])
(modes.remove_binds :normal [:gt :gT])
