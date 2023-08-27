(fn uv-callback [err res]
  (if err
      (if (= :string (type err))
          (let [errno (err:match "^([^:]+):")]
            (if errno
                (values nil err errno)
                (values nil err)))
          (values nil err))
      res))

(fn uv-wrapper [fn-name]
  (let [{: make-promise : resolve : await} (require :async)
        p (make-promise)]
    (values (fn [...]
              ((. (require :luv) fn-name) ...)
              (await p))
            (fn cb [...]
              (resolve p (uv-callback ...))))))

{: uv-callback
 : uv-wrapper}
