(fn make-promise [?f]
  (local o {})

  (fn resolved? []
    (or o.res o.err))

  (fn resolve [_ & res]
    (when (resolved?)
      (error "promise already resolved"))
    (set o.res res))

  (fn reject [_ err]
    (when (resolved?)
      (error "promise already resolved"))
    (set o.err err))

  (fn await []
    (while (not o.res)
      (if o.err
          (error o.err)
          (coroutine.yield)))
    (unpack o.res))

  (if ?f
      (do
        (?f (partial resolve nil) (partial reject nil))
        (await))
      (setmetatable {} {:__index {: resolved? : resolve : reject : await}})))

(fn resolved? [promise]
  (promise:resolved?))

(fn resolve [promise ...]
  (promise:resolve ...))

(fn reject [promise err]
  (promise:reject err))

(fn await [promise]
  (promise:await))

{: make-promise : resolved? : resolve : reject : await}

