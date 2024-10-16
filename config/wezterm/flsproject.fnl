{:fennel-path "./?.fnl;./?/init.fnl"
 :lua-version :lua54
 :extra-globals "nil? number? boolean? string? table? function? keys vals empty? inc dec count even? odd? identity some list? cons triml trimr trim copy concat concat! merge! deep-merge deep-merge! starts-with? strip-prefix ends-with? strip-suffix slurp once unpack"
 :lints {:unused-definition true
         :unknown-module-field true
         :unnecessary-method true
         :bad-unpack true
         :var-never-set true
         :op-with-no-arguments true
         :multival-in-middle-of-call true}}

