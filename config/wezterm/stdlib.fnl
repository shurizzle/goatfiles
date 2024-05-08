(set _G.unpack (or unpack table.unpack))

(macro gfn [name & body]
  (local lua-keywords {:and true
                       :break true
                       :do true
                       :else true
                       :elseif true
                       :end true
                       :false true
                       :for true
                       :function true
                       :if true
                       :in true
                       :local true
                       :nil true
                       :not true
                       :or true
                       :repeat true
                       :return true
                       :then true
                       :true true
                       :until true
                       :while true
                       :goto true})

  (fn valid-lua-identifier? [str]
    (and (str:match "^[%a_][%w_]*$") (not (. lua-keywords str))))

  (fn global-mangling [str]
    (if (valid-lua-identifier? str)
        str
        (.. :__fnl_global__
            (str:gsub "[^%w]" #(string.format "_%02x" ($:byte))))))

  (let [sname (tostring name)
        gname (global-mangling sname)
        glob (sym (.. :_G. gname))
        base `(set ,glob ,(list (sym :fn) (unpack body)))]
    (if (= sname gname)
        base
        [base `(tset _G ,sname ,glob)])))

(gfn nil? [x] "True if the value is equal to `nil`." (= nil x))

(gfn number? [x] "True if the value is of type 'number'." (= :number (type x)))

(gfn boolean? [x] "True if the value is of type 'boolean'."
     (= :boolean (type x)))

(gfn string? [x] "True if the value is of type 'string'." (= :string (type x)))

(gfn table? [x] "True if the value is of type 'table'." (= :table (type x)))

(gfn function? [x] "True if the value is of type 'function'."
     (= :function (type x)))

(gfn keys [t] "Get all keys of a table."
     (assert (table? t) (.. "Expected table, got " (type t)))
     (icollect [k _ (pairs t)] k))

(gfn vals [t] "Get all values of a table."
     (assert (table? t) (.. "Expected table, got " (type t)))
     (icollect [_ v (pairs t)] v))

(gfn empty? [xs] "Returns true if the arguments is empty."
     (if (table? xs) (nil? (next xs))
         (not xs) true
         (= 0 (length xs))))

(gfn inc [n] "Increment n by 1." (+ n 1))

(gfn dec [n] "Decrement n by 1." (- n 1))

(gfn count [xs] "Returns the number of elments in object."
     (if (table? xs) (accumulate [c 0 _ _ (pairs xs)] (inc c))
         (not xs) 0
         (length xs)))

(gfn even? [n] "True if the value is even." (= (% n 2) 0))

(gfn odd? [n] "True if the value is odd." (not= (% n 2) 0))

(gfn identity [x] "Returns what you pass it." x)

(gfn some [f xs] "Returns the first truthy result from (f x) or nil."
     (each [k x (pairs xs)]
       (let [result (f x k xs)]
         (lua "return result"))))

(gfn list? [x]
     "True if the values is a list, a table with only numeric indexes."
     (and (table? x) (not (some #(not (number? $2)) x))))

(gfn const [v] (fn [] v))

(gfn triml [s] "Removes whitespaces from the left side of string."
     (string.gsub s "^%s*(.-)" "%1"))

(gfn trimr [s] "Removes whitespaces from the right side of string."
     (string.gsub s "(.-)%s*$" "%1"))

(gfn trim [s] "Removes whitespaces from both ends of string."
     (string.gsub s "^%s*(.-)%s*$" "%1"))

(fn copy* [x cache]
  (match (type x)
    :table (if (. cache x)
               (. cache x)
               (let [copy []
                     mt (getmetatable x)]
                 (tset cache x copy)
                 (each [k v (pairs x)]
                   (tset copy (copy* k cache) (copy* v cache)))
                 (setmetatable copy mt)))
    (where (or :number :string :nil :boolean :function)) x
    other (error (.. "Cannot deepcopy object of type " other))))

(gfn copy [x] "Returns a deep copy of the given object." (copy* x []))

(gfn concat! [& args] (var res nil)
     (each [_ v (pairs args)]
       (when (not (nil? v))
         (assert (table? v) (.. "Expected table, got " (type v)))
         (if res
             (each [_ e (pairs v)]
               (table.insert res e))
             (set res v)))) res)

(gfn concat [& args] (var res nil)
     (each [_ v (pairs args)]
       (when (not (nil? v))
         (set res (concat! (or res []) v)))) res)

(gfn merge! [res & args]
     (when (if (empty? args) (not (nil? res)) true)
       (assert (table? res) (.. "Expected table, got " (type res))))
     (each [_ tbl (pairs args)]
       (when (not (nil? tbl))
         (assert (table? tbl) (.. "Expected table, got " (type tbl)))
         (each [k v (pairs tbl)]
           (tset res k v)))) res)

(fn can-merge [v]
  (and (table? v) (or (empty? v) (not (list? v)))))

(gfn deep-merge [& args] (var res nil)
     (each [_ tbl (pairs args)]
       (when (not (nil? tbl))
         (assert (table? tbl) (.. "Expected table, got " (type tbl)))
         (when (not res)
           (set res []))
         (each [k v (pairs tbl)]
           (if (and (can-merge v) (can-merge (. res k)))
               (tset res k (deep-merge (. res k) v))
               (tset res k v))))) res)

(gfn deep-merge! [& args]
     (when (if (empty? args) (not (nil? res)) true)
       (assert (table? res) (.. "Expected table, got " (type res))))
     (each [_ tbl (pairs args)]
       (when (not (nil? tbl))
         (assert (table? tbl) (.. "Expected table, got " (type tbl)))
         (if res
             (each [k v (pairs tbl)]
               (if (and (can-merge v) (can-merge (. res k)))
                   (tset res k (deep-merge! (. res k) v))
                   (tset res k (copy v))))
             (set res tbl)))) res)

(gfn starts-with? [s prefix] "True if string `s` starts with string `prefix`."
     (assert (string? s) (.. "Expected string, got " (type s)))
     (assert (string? prefix) (.. "Expected string, got " (type prefix)))
     (= (s:sub 1 (length prefix)) prefix))

(gfn strip-prefix [s prefix] "Returns string `s` without string `prefix` if `s` starts with `prefix`, else
  returns nil."
     (when (starts-with? s prefix)
       (string.sub s (inc (length prefix)))))

(gfn ends-with? [s suffix] "True if string `s` ends with string `suffix`."
     (assert (string? s) (.. "Expected string, got " (type s)))
     (assert (string? suffix) (.. "Expected string, got " (type suffix)))
     (or (= 0 (length suffix)) (= (s:sub (- (length suffix))) suffix)))

(gfn strip-suffix [s suffix] "Returns string `s` without string `suffix` if `s` ends with `suffix`, else
  returns nil."
     (when (ends-with? s suffix)
       (string.sub s 1 (- (length s) (length suffix)))))

(gfn slurp [path] "Read the file into a string."
     (match (io.open path :r)
       (nil _msg) nil
       f (let [content (f:read :*all)]
           (f:close)
           content)))

(gfn once [f] (assert (function? f) (.. "Expected function, got " (type f)))
     (var called false) (fn [...]
                         (when (not called)
                           (set called true)
                           (f ...))))

