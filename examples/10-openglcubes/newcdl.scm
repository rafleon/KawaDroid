(require 'srfi-1)
(require 'srfi-95)

;; java array to list
(define atol
  (lambda (a::object[])
    (map a (iota a:length))))

;; generate a giant classpath to all the dex files in a directory, 
;; sorted in chronological order, most recent first.
;; we do this each time something is compiled and loaded, 
;; so that compiled classes can depend on other compiled classes.
(define alldexsorted
  (lambda (dexdir::java.io.File)
    (let* ((alldex::String[] 
                          (dexdir:list 
                           (lambda (dir::java.io.File name::String) 
                             (name:matches ".*\.dex$"))))
           (nametofile (lambda (fn::String)
                         (java.io.File dexdir fn)))
           (filetoname (lambda (f::java.io.File)
                         (f:getAbsolutePath)))
           (olderfile (lambda (a::java.io.File b::java.io.File)
                        (> (a:lastModified) (b:lastModified))))
           (sortednames
            (map filetoname 
                 (sort (map nametofile (atol alldex)) olderfile)))
           (addcolon (lambda (s)
                       (string-append ":" s)))
           )
      (apply string-append (cons 
                            (car sortednames) 
                            (map addcolon (cdr sortednames))
                            ))
      )))

(define compiledexload
  ;; classname and filename 
  (lambda (cls::String fn::String)
    (let* ((act::android.app.Activity *activity*)
           (bn (fn:replaceAll ".*/([^/]+).scm$" "$1"))
           (dexdir (act:getFilesDir))
           (fdir (dexdir:toString))
           (cdir ((act:getCacheDir):toString))
           (jarfn (string-append fdir "/" bn ".jar"))
           (dexfn (string-append fdir "/" bn ".dex"))
           (cfn (string-append cdir "/" bn ".dex"))
           ;; the args to dexer as a string array
           (dexsa (String[] (string-append "--output=" dexfn) jarfn))
           ;; the args to dexer as a parsed object
           (dexargs (com.android.dx.command.dexer.Main$Arguments))
           (cloader (act:getClassLoader))
           )
      ;; compile it.
      (compile-file fn jarfn)
      ;; dex it.
      (dexargs:parse dexsa)
      (com.android.dx.command.dexer.Main:run dexargs)
      ;;load it and return the loaded class.
      (if ((<java.io.File> cfn):exists)
          ((<java.io.File> cfn):delete))
      ((<dalvik.system.DexClassLoader> 
        (alldexsorted dexdir) cdir #!null cloader):loadClass cls)
      )))
