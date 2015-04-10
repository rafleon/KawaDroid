
(define-simple-class myclass ()
  ((plusone (x::int))::int allocation: 'static
   (+ 1 x)
   ))
