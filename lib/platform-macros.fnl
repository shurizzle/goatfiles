(fn condition [platform cond]
  (if
    (= :string (type cond)) `(or (= (. ,platform :os) ,cond) (. ,platform :is ,cond))
    (sym? cond) (condition platform (tostring cond))
    (list? cond)
      (do
        (assert-compile (> (length cond) 1) "invalid condition" cond)
        (assert-compile (and (sym? (. cond 1))
                             (or (= :and (tostring (. cond 1)))
                                 (= :or  (tostring (. cond 1)))))
                        "invalid condition" cond)
        (for [i 2 (length cond)]
          (tset cond i (condition platform (. cond i))))
        cond)
    (assert-compile false "invalid conditon" cond)))

(fn match-platform [& forms]
  (let [platform (gensym)
        exprs `(if)]
    (for [i 2 (length forms) 2]
      (let [cond (. forms (- i 1))
            body (. forms i)]
        (table.insert exprs (condition platform cond))
        (table.insert exprs body)))
    (if (not= 0 (% (length forms) 2))
        (table.insert exprs (. forms (length forms)))
        (table.insert exprs `(error "platforms unsupported")))
    `(let [,platform (require :platform)]
       ,exprs)))

{: match-platform}
