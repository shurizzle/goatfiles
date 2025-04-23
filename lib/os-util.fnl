(local {: is} (require :platform))
(local {: split : filter : filter-map} (require :iter))

(local path-sep (if is.windows ";" ":"))

(fn path []
  (filter #(> (length $1) 0) (split (os.getenv :PATH) (.. path-sep "+"))))

(local path-ext (if is.windows
                    (fn []
                      (filter-map #(when (> (length $1) 0) (string.upper $1))
                                  (split (os.getenv :PATHEXT) ";+")))
                    (fn [] #nil)))

(fn cmd? [name]
  (not= nil ((. (require :which) :which) name)))

(local uv (require :luv))

(fn exec [cmd ?opts]
  (local {: make-promise : resolve : await} (require :async))
  (local opts (or ?opts []))
  (var out nil)
  (var err nil)
  (set opts.stdio nil)
  (var code nil)
  (var stdout nil)
  (var stderr nil)
  (var stdout-cb nil)
  (var stderr-cb nil)
  (case opts.stdout
    :ignore (do
              (set stdout (uv.new_pipe))
              (set stdout-cb (fn [err _] (assert (not err) err))))
    :capture (do
               (set stdout (uv.new_pipe))
               (set out "")
               (set stdout-cb
                    (fn [err data]
                      (assert (not err) err)
                      (when data
                        (set out (.. out data)))))))
  (set opts.stdout nil)
  (case opts.stderr
    :ignore (do
              (set stderr (uv.new_pipe))
              (set stderr-cb (fn [err _] (assert (not err) err))))
    :capture (do
               (set stderr (uv.new_pipe))
               (set err "")
               (set stderr-cb
                    (fn [e data]
                      (assert (not e) e)
                      (when data
                        (set err (.. err data)))))))
  (set opts.stderr nil)
  (set opts.stdio nil)
  (when stdout
    (set opts.stdio [nil stdout]))
  (when stderr
    (when (not stdout)
      (set opts.stdio []))
    (tset opts.stdio 3 stderr))
  (local p (make-promise))

  (fn on-exit [c _]
    (set code c)
    (resolve p))

  (local (_handle _pid) (uv.spawn cmd opts on-exit))
  (when stdout
    (uv.read_start stdout stdout-cb))
  (when stderr
    (uv.read_start stderr stderr-cb))
  (await p)
  (when stdout
    (uv.shutdown stdout))
  (when stderr
    (uv.shutdown stderr))
  (values code out err))

{: path-sep : path : path-ext : cmd? : exec}

