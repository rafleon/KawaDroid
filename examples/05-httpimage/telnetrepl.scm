
(define replport 4444)

(define close
  (lambda ()
    (close-input-port (current-input-port))
    ))

(define (start-telnet-repl (socket java.net.Socket))
  (let ((lang (gnu.expr.Language:getDefaultLanguage)))
    (kawa.TelnetRepl:serve lang socket)))

(define (start-repl port)
  (let ((server (java.net.ServerSocket port)))
    (try-finally
     (let loop ()
       (let ((socket (server:accept)))
         (start-telnet-repl socket)
         (loop)))
     (invoke server 'close))))

(future (start-repl replport))
