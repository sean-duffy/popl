#lang eopl
;; Semantic interpreter for CORE
(provide  (all-defined-out))
(require "syntax.scm")
(require "data-structures.scm")
;; 
;; (execute ...) takes an abstract syntax representation of a program,
;; and returns its Expressed Value
;;
(define (execute prog)
  (cases program prog
    (a-program (exp) (value-of (empty-env) exp))
  )
)
;;
;; (value-of ...) takes an abstract syntax representation of an expression
;; and returns its Expressed Value

(define e (empty-env))

(define (cond-proc e conditions statements)
  

;; ** Requires editing the ???s **
(define (value-of e expr)                     
  (cases expression expr    
    (let-exp (ident val exp) (value-of (extend-env ident (value-of e val) e) exp))
    (const-exp (num) (number-ExpVal num) )
    (ident-exp (ident) (apply-env e ident) )
    (zero?-exp (exp)
       (bool-ExpVal (zero? (<-ExpVal (value-of e exp))))
    )
    
    (cond-exp (conditions statements) (display statements))
    
    (binary-bool-exp (op exp1 exp2)
       (let ((v ((cadr (assoc op (list 
                                     (list (equal-prim) (lambda (a b) (equal? a b)))
                                     (list (greater-prim) (lambda (a b) (> a b)))
                                     (list (less-prim) (lambda (a b) (< a b)))
                                     (list (plus-prim) (lambda (a b) (+ a b)))
                                     (list (times-prim) (lambda (a b) (* a b)))
                                     (list (divide-prim) (lambda (a b) (/ a b)))
                                     (list (minus-prim) (lambda (a b) (- a b)))
                                     )
                           )) (<-ExpVal (value-of e exp1)) (<-ExpVal (value-of e exp2)))))
         (if (number? v) (number-ExpVal v) (bool-ExpVal v)))
    )
    ;;(equal?-exp (exp1 exp2)
    ;;   (bool-ExpVal (equal? (<-ExpVal (value-of exp1)) (<-ExpVal (value-of exp2))))
    ;;)
    ;;(greater?-exp (exp1 exp2)t
    ;;   (bool-ExpVal (> (<-ExpVal (value-of exp1)) (<-ExpVal (value-of exp2))))
    ;;)
    ;;(less?-exp (exp1 exp2)
    ;;   (bool-ExpVal (< (<-ExpVal (value-of exp1)) (<-ExpVal (value-of exp2)))))
    (if-exp (test true-exp false-exp)
         (if (ExpVal->bool (value-of e test))
                  (value-of e true-exp)         
                  (value-of e false-exp)     
         ) 
    )
  )
)