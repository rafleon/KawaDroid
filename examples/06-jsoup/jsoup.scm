
;; This URL is an XML RSS/Atom feed of the latest entries on the 
;;   Android Developers Blog.
(define urls "http://feeds.feedburner.com/blogspot/hsDu")

(define act::android.app.Activity *activity*)
(define fdir ((act:getFilesDir):getAbsolutePath))
(define fn::String (string-append fdir "/adblinks.html"))

;; java array to scheme list
(require 'srfi-1)
(define atol
  (lambda (a::object[])
    (map a (iota a:length))))

;; extract the title and link of a single blog entry.
;; Output a single line of formatted html as a string.
;; this is pure java code and can run outside of android.
(define doentry
  (lambda (e::org.jsoup.nodes.Element)
    (let* ((link (e:getElementsByAttributeValue "rel" "alternate"))
           (href (link:attr "href"))
           (title (link:attr "title"))
           )
      (string-append "<a href=\"" href "\">" title "</a><br><br>\n")
      )))

;; fetch, parse, process all links, output formatted html.
;; this is more pure java code. 
(define (updatefile)
  (let* ((outport (open-output-file fn))
         (url (java.net.URL urls))
         ;; fetch and parse, timeout of 4 seconds.
         (mydoc (org.jsoup.Jsoup:parse url 4000))
         (entries (atol ((mydoc:getElementsByTag "entry"):toArray)))
         )
    (display (apply string-append (map doentry entries)) outport)
    (close-output-port outport)
    ))

;; take a full path to an html file as a string.
;; show it in a scrolling, clickable textview with a large font.
(define showhtml
  (lambda (fn)
    (let* ((act::android.app.Activity *activity*)
           (sv::ScrollView (ScrollView act))
           (tv::TextView (TextView act))
           )
      (sv:addView tv)
      (tv:setTextSize 20)
      (tv:setMovementMethod (android.text.method.LinkMovementMethod))
      (tv:setText (android.text.Html:fromHtml 
                   (path-data fn)))
      (rout (act:setContentView sv))
      )))

;; This is the status textview with Id 1 used by the (msg ..) function.
(define showstatus
  (lambda ()
    (let* ((act::android.app.Activity *activity*)
           (tv::TextView (TextView act)))
      (tv:setId 1)
      (tv:setTextSize 20)
      (tv:setText "Updating links ... ")
      (rout (act:setContentView tv))
      )))

;; actually do things.
;; This is the whole app.
(let* ((fo (java.io.File fn))
       (now (java.util.Date))
       ;;if file exists and is less than 1440 mins (1 day) old.
       (fileokay (and (fo:exists)
                      (< (/ (- (now:getTime)
                               (fo:lastModified)) 60000)
                         1440)))
       )
  ;; do everything in a separate thread.
  (future
   (begin
     (if (not fileokay)
         (begin
           (showstatus)
           (updatefile)
           (msg "done.\n")
           (sleep 2)
           ))
     ;; set view to html. 
     (showhtml fn)
     )))
