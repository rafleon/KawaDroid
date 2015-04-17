
(let* ((act::android.app.Activity *activity*)
       (t::android.widget.TextView 
        (android.widget.TextView act))
       ;; this gets the wifi interface.
       (networkiface (java.net.NetworkInterface:getByName "wlan0"))
       (listifaceaddr (networkiface:getInterfaceAddresses))
       ;;ip4 address is the last one. most of the time.
       (ip4addr (listifaceaddr (- (listifaceaddr:size) 1)))
       )
  (t:set-text (string-append
               "\n"
               "Telnet to\n\n"
               "IP4 address: "
               ((ip4addr:getAddress):getHostAddress)
               "\n\n"
               "port number: "
               (number->string replport)))
  (act:runOnUiThread
   (runnable
    (lambda ()
      (act:setContentView t)))))
