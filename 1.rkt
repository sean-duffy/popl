(define x 2)

(define (square x) (* x x))

(define (sum-of-squares x y) 
  (+ (square x) (square y)))

(define (abs x)
  (cond ((> x 0) x)
        ((= x 0) 0)
        ((< x 0) (- x))))

(define (not x)
  (cond ((= x 1) 0)
        ((= x 0) 1)))

(define (factorial n)
  (cond ((= n 1) 1)
        (else (* n (factorial (- n 1))))))

(define (sum-to n)
  (cond ((= n 1) 1)
        (else (+ n (sum-to (- n 1))))))
