(local *dir-sep* (package.config:sub 1 1))
(local *project* (assert (vim.loop.fs_realpath :.) "invalid directory"))
(fn path-join [...] (table.concat [...] *dir-sep*))
(local unpack (or table.unpack _G.unpack))

(local *lua-exrc* (path-join *project* :.nvim.lua))
(local *fnl-exrc* (path-join *project* :.nvim.fnl))

(local *in*  (path-join *project* :wezterm.fnl))
(local *out* (path-join *project* :wezterm.lua))

(fn load-fennel []
  (pcall require :hotpot.fennel) ; hotpot support
  (let [(ok fennel) (pcall require :fennel)]
    (if ok
        fennel
        (do
          (set package.preload.fennel
               (fn [& args]
                 (let [path (assert
                              (vim.loop.fs_realpath
                                (path-join *project* :.. :.. :fennel.lua))
                              "cannot find fennel compiler")
                       code (assert (loadfile path))]
                   (set package.preload.fennel code)
                   (let [fennel (code (unpack args))]
                     (set package.preload.fennel (fn [] fennel))
                     fennel))))
          (require :fennel)))))

(local fennel (load-fennel))
(local uv vim.loop)

(fn debounce [f time]
  (var timer nil)
  (fn [& args]
    (when timer
      (uv.timer_stop timer)
      (set timer nil))
    (fn run []
      (set timer nil)
      (f (unpack args)))
    (set timer (vim.defer_fn run time))))

(macro dfn [time & args]
  (if (sym? (. args 1))
      (let [name (table.remove args 1)]
        `(local ,name (debounce (fn ,(unpack args)) ,time)))
      `(debounce (fn ,(unpack args)) ,time)))

(fn slurp [path]
  (with-open [f (assert (io.open path :rb))]
    (f:read :*all)))

(fn spit [content path]
  (with-open [f (assert (io.open path :wb))]
    (f:write content)))

(dfn 250 compile-exrc []
     (-> (slurp *fnl-exrc*)
         (fennel.compile-string {:filename *fnl-exrc*
                                 :globals [:vim]
                                 :use-bit-lib true})
         (spit *lua-exrc*)))

(dfn 250 compile-wezterm []
     (-> (slurp *in*)
         (fennel.compile-string {:filename *in*
                                 :requireAsInclude true
                                 :skipInclude [:wezterm]})
         (spit *out*)))

(fn file-changed [err filename]
  (if
    err (vim.api.nvim_echo [[(if (= :string (type err)) err (tostring err)) 
                             :ErrorMsg]]
                           true [])
    (= filename :.nvim.fnl) (compile-exrc)
    (and (not= filename :.nvim.lua)
         (not= filename :compile.lua)
         (= (filename:sub -4) :.fnl))
      (compile-wezterm)))

(let [handle (uv.new_fs_event)]
  (uv.fs_event_start handle *project*
                     {:recursive true
                      :watch_entry true
                      :stat true}
                     file-changed)
  (vim.api.nvim_create_autocmd :VimLeavePre {:callback #(uv.close handle)}))

nil
