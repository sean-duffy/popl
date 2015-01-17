#lang eopl
(require "syntax.scm")
(provide (all-defined-out))
;;

;;
;; Expressed Values for CORE
;;    an expressed value is a number or a truth-value 
;;
(define-datatype  ExpVal ExpVal?
    (number-ExpVal  (a-number number?))
    (bool-ExpVal    (a-boolean boolean?))
)
;; Injection function for taking a scheme value into the set of Expressed Values
(define (->ExpVal x)
  (cond
    ((number? x)  (number-ExpVal x))
    ((boolean? x) (bool-ExpVal x) )
    (else (eopl:error '->ExpVal "~s cannot be an Expressed Value" x))
  )
)
;;; Specific extractors:
; EOPL p70
; ExpVal->num : ExpVal -> number
(define (ExpVal->number v)
  (cases ExpVal v
    (number-ExpVal (s) s)
    (else (ExpVal-extractor-error 'Number v))
  )
)
; ExpVal->num : ExpVal -> truth-value
(define (ExpVal->bool v)
  (cases ExpVal v
    (bool-ExpVal (s) s)
    (else (ExpVal-extractor-error 'Boolean v))
  )
)
;; Convenience function for translating an Expressed value into a scheme value
(define (<-ExpVal x)
  (cases ExpVal x    
    (number-ExpVal (s) s)
    (bool-ExpVal   (s) s)
  )
)
;;
(define (ExpVal-extractor-error variant value)
    (eopl:error 'ExpVal-extractors "Looking for a ~s, found ~s"
                variant value)
)

(define empty-env
  (lambda () (list 'empty-env)))

(define extend-env
  (lambda (var val env)
    (list 'extend-env var val env)))

(define apply-env
(lambda (env search-var)
(cond
((eqv? (car env) 'empty-env)
(report-no-binding-found search-var))
((eqv? (car env) 'extend-env)
(let ((saved-var (cadr env))
(saved-val (caddr env))
(saved-env (cadddr env)))
(if (eqv? search-var saved-var)
saved-val
(apply-env saved-env search-var))))
(else
(report-invalid-env env)))))
(define report-no-binding-found
(lambda (search-var)
(eopl:error 'apply-env "No binding for ~s" search-var)))
(define report-invalid-env
(lambda (env)
(eopl:error 'apply-env "Bad environment: ~s" env)))


