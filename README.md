
#KawaDroid Examples
###"This is the Droid you are looking for."
*****
####A collection of [Kawa Scheme](http://www.gnu.org/software/kawa/) demos (including OpenGLES 2.0) for Android.

The current set of examples is:

1. Hello World.
2. A telnet read-eval-print loop (REPL).
3. A Linear Layout with a Button and a TextView.  Shows how to bind events.
4. Load text files from Assets and display them in a ScrollView.
5. A binary HTTP client which downloads and displays a live webcam image.
6. jsoup for XML parsing to extract and display links as clickable text.
7. Compiling, dexing and loading of java bytecode from scheme text files.
8. GPS location with Fused API. Provides a synchronous interface with timeouts.
9. **OpenGLES 1.0** demo of a spinning triangle with touch events.
10. **OpenGLES 1.0** spinning cubes and pyramids copied from SchemeAndroidOGL.
11. Accelerometer/Compass to generate x,y,z unit vectors for "up" and "north".
12. **OpenGLES 2.0** another spinning triangle, this time with shaders.

Each example is source code for the scheme interpreter and on-the-fly compiler.

Choose an example and copy the .scm files to the device at "/sdcard/KawaDroid".

The exact path could be different on your device. 
It contains the path to external storage and the app title.

In ./app/src/main/AndroidManifest.xml, the title is currently set to "KawaDroid".

The core app reads "on-create.scm" and interprets it.

For those willing to risk installing an unsigned debug apk, it can be found at:

./app/build/outputs/apk/app-debug.apk

This is a gradle project, ready for import into Android Studio for 
customization and building.

Transferring the files with "adb push" works best.
MTP doesn't sync properly but will be fixed soon.

**The license for this code is Apache 2.0.** 
This project includes other software with different licenses.
Complete license information is in the assets directory
./app/src/main/assets

**Internally, this project uses these technologies:**

+ [Kawa Compiler](http://www.gnu.org/software/kawa/Compiling.html)
+ [Android Dexer](https://android.googlesource.com/platform/dalvik/+/master/dx/src/com/android/dx/command/dexer/Main.java)
+ [Dalvik DexClassLoader](http://developer.android.com/reference/dalvik/system/DexClassLoader.html)
+ [Gradle](http://tools.android.com/tech-docs/new-build-system)
+ [OpenGLES](http://developer.android.com/guide/topics/graphics/opengl.html)
+ [jsoup](http://jsoup.org/)

**Other projects with similar goals and/or features:**

+ [AppDoh](https://github.com/benjisimon/app-doh)
+ [SchemeAndroidOGL](https://github.com/ecraven/SchemeAndroidOGL)
+ [android-kawa](https://github.com/abarbu/android-kawa)
+ [LambdaNative](http://www.lambdanative.org/)
+ [cocoscheme](https://play.google.com/store/apps/details?id=com.adellica.cocoscheme)
+ [Gambit for Android](http://apps.keithflower.org/?page_id=152)
+ [PhoneGap](http://phonegap.com/)
+ [Appcelerator Titanium](http://www.appcelerator.com/titanium/download-titanium/)
+ [React Native](http://facebook.github.io/react-native/)
+ [MIT App Inventor](http://appinventor.mit.edu/)
+ [SL4A](https://code.google.com/p/android-scripting/)
+ [AIDE](https://play.google.com/store/apps/details?id=com.aide.ui)
+ [C4droid](https://play.google.com/store/apps/details?id=com.n0n3m4.droidc)