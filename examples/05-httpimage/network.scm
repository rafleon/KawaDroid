
(define sa string-append)

;; copies bytes from one stream to another
;; This is pure java code. no android is involved.
(define copystream
  (lambda (in::java.io.InputStream 
           out::java.io.OutputStream)
    (letrec* ((buf (byte[] length: 1024))
              (loop 
               (lambda (bytesread)
                 (if (= -1 bytesread)
                     (in:close)
                     (begin 
                       (out:write buf 0 bytesread)
                       (loop (in:read buf)))
                     ))))
             (loop (in:read buf)))))

;; Before fetching, it is good to check if a file exists, separately.
;; then fetch only if needed. 

;; It is okay for this to block for a few seconds, with timeout.
;; Run it in an appropriate thread.

;; This is also pure java and runs outside of android.
(define getfile
  ;;url, local filename
  (lambda (urlstr::String lfn::String)
    (let* ((f (java.io.File lfn))
           (outstr (java.io.FileOutputStream f))
           ;; open connection
           (urlobj (java.net.URL urlstr))
           (urlconn (urlobj:openConnection))
           ;; set connection timeouts and cast to http
           (huc::java.net.HttpURLConnection 
            (begin
              (urlconn:setConnectTimeout 2000)
              (urlconn:setReadTimeout 4000)
              urlconn))
           ;; if the file isn't found, this is where it throws.
           (instr
            (try-catch
             (java.io.BufferedInputStream 
              (urlconn:getInputStream))
             (e 'java.lang.Exception #f))))
      ;; transfer the data
      ;; add more (try-catch ... ) here.
      (if instr (begin
                  (copystream instr outstr)
                  (msg (sa lfn " downloaded.\n")))
          (msg (sa lfn " had a download error.\n")))
      (outstr:close)
      (if (not instr)
          (f:delete))
      (huc:disconnect)
      )))
