;;;; Complex Number Packages
(load-from-path "arithmetic-pkg/complex-pkgs.scm")

(define (complex? x)
  (eq? (type-tag x) 'complex))

(define (install-complex-package)

  ;; imported procedures from rectangular and polar packages

  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))

  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))

  ;; internal procedures

  (define (add z w)
    (make-from-real-imag (+ (real-part z) (real-part w))
                         (+ (imag-part z) (imag-part w))))

  (define (sub z w)
    (make-from-real-imag (- (real-part z) (real-part w))
                         (- (imag-part z) (imag-part w))))

  (define (mul z w)
    (make-from-mag-ang (* (magnitude z) (magnitude w))
                       (+ (angle z) (angle w))))

  (define (div z w)
    (make-from-mag-ang (/ (magnitude z) (magnitude w))
                       (- (angle z) (angle w))))

  (define (equal-complex? z w)
    (and (equal-float? (real-part z) (real-part w))
         (equal-float? (imag-part z) (imag-part w))))

  (define (zero-complex? z)
    (apply-generic '=zero? z))

  (define (real-part z)
    (apply-generic 'real-part z))

  (define (imag-part z)
    (apply-generic 'imag-part z))

  (define (magnitude z)
    (apply-generic 'magnitude z))

  (define (angle z)
    (apply-generic 'angle z))

  ;; interface to rest of system
  (define (tag z) (attach-tag 'complex z))
  (put 'real-part '(complex) real-part)
  (put 'imag-part '(complex) imag-part)
  (put 'magnitude '(complex) magnitude)
  (put 'angle '(complex) angle)
  (put 'num-eq? '(complex complex) equal-complex?)
  (put '=zero? '(complex) zero-complex?)
  (put 'add '(complex complex)
       (lambda (z w) (tag (add z w))))
  (put 'sub '(complex complex)
       (lambda (z w) (tag (sub z w))))
  (put 'mul '(complex complex)
       (lambda (z w) (tag (mul z w))))
  (put 'div '(complex complex)
       (lambda (z w) (tag (div z w))))
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

