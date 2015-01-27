#lang eopl
;; Semantic interpreter for CORE
(provide  (all-defined-out))
(require "syntax.scm")
(require "data-structures.scm")
(require srfi/1)

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
  (if (ExpVal->bool (value-of e (car conditions)))
                    (value-of e (car statements))
                    (if (eq? (length conditions) 1) 
                      (eopl:error "Error: All cases were false")
                      (cond-proc e (cdr conditions) (cdr statements))
                    )
  )
)
  
(define (value-of e expr)                     
  (cases expression expr
    
    (let-seq-exp (idents values exp) 
      (value-of (fold-right 
                  (lambda (pair env) (extend-env (car pair) (value-of env (cadr pair)) env)) 
                  (empty-env) 
                  (reverse (map list idents values))
                ) exp)
    )
    
    (let-exp (idents values exp) 
      (value-of (fold-right 
                  (lambda (pair env) (extend-env (car pair) (value-of e (cadr pair)) env)) 
                  (empty-env) 
                  (map list idents values) 
                ) exp)
    )
    
    (const-exp (num) (number-ExpVal num))
    (ident-exp (ident) (apply-env e ident))
    
    (zero?-exp (exp)
       (bool-ExpVal (zero? (<-ExpVal (value-of e exp))))
    )
    
    (cond-exp (conditions statements) (cond-proc e conditions statements))
    
    (empty-list-exp () (list-ExpVal '()))
    (list-literal-exp (fst items) (list-ExpVal (cons (<-ExpVal(value-of e fst)) (fold-right (lambda (a b) (cons (<-ExpVal (value-of e a)) b)) (list) items))))
    (car-exp (exp) (->ExpVal (car (<-ExpVal (value-of e exp)))))
    (cdr-exp (exp) (->ExpVal (cdr (<-ExpVal (value-of e exp)))))
    (null?-exp (exp) (bool-ExpVal (null? (<-ExpVal (value-of e exp)))))
    
    (print-exp (exp) ((lambda (exp) (display (<-ExpVal exp)) (newline) exp) (value-of e exp)))
    
    (two-op-exp (op exp1 exp2)
       (let ((v ((cadr (assoc op (list 
                                     (list (equal-prim) (lambda (a b) (equal? a b)))
                                     (list (greater-prim) (lambda (a b) (> a b)))
                                     (list (less-prim) (lambda (a b) (< a b)))
                                     (list (plus-prim) (lambda (a b) (+ a b)))
                                     (list (times-prim) (lambda (a b) (* a b)))
                                     (list (divide-prim) (lambda (a b) (/ a b)))
                                     (list (minus-prim) (lambda (a b) (- a b)))
                                     (list (cons-prim) (lambda (a b) (cons a b)))
                                     )
                           )) (<-ExpVal (value-of e exp1)) (<-ExpVal (value-of e exp2)))))
         (->ExpVal v))
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
