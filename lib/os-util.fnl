(local {: is} (require :platform))
(local {: split : filter} (require :iter))

(local path-sep (if is.windows ";" ":"))

(fn path []
  (filter #(> (length $1) 0) (split (os.getenv :PATH) (.. path-sep :+))))

(local path-ext
       (if is.windows
           (fn [] (filter #(> (length $1) 0) (split (os.getenv :PATHEXT) ";+")))
           (fn [] #nil)))

{: path-sep
 : path
 : path-ext}
