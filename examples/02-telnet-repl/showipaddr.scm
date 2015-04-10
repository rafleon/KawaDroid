
(let* ((act::android.app.Activity *activity*)
       (t::android.widget.TextView 
        (android.widget.TextView act))
       ;; this gets the wifi interface.
       (networkiface (java.net.NetworkInterface:getByName "wlan0"))
       (listifaceaddr (networkiface:getInterfaceAddresses))
       (ip6addr (listifaceaddr 0))
       (ip4addr (listifaceaddr 1))
       )
  (t:set-text (string-append
               "\n"
               "Telnet to\n\n"
               "IP address: "
               ((ip4addr:getAddress):getHostAddress)
               "\n\n"
               "port number: "
               (number->string replport)))
  (act:runOnUiThread
   (runnable
    (lambda ()
      (act:setContentView t)))))
