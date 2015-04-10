(define compiledexload
  ;; classname and filename 
  (lambda (cls::String fn::String)
    (let* (
           (act::android.app.Activity *activity*)
           (bn (fn:replaceAll ".*/([^/]+).scm$" "$1"))
           (fdir ((act:getFilesDir):toString))
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
      ((<dalvik.system.DexClassLoader> dexfn cdir #!null cloader):loadClass cls)
      )))
