#CCLite
A Computercraft Emulator

This is a for of CCLite from Gamax92. You can find it here: https://github.com/gamax92/cclite

#HTTPS Support
LuaSocket doesn't support HTTPS on its own and needs a helper library like LuaSec

CCLite by default comes with support disabled and https requests get automatically dropped to http, which the server may or may not like.

Hopefully this page will help you get proper HTTPS working

**Linux:**

```
apt-get install lua-sec
```

This should get everything you need.

Then go into conf.lua and set useLuaSec to true

**Windows:**

For HTTPS support, you'll need to grab:

From LuaSec: [Binaries](http://50.116.63.25/public/LuaSec-Binaries/), [Lua Code](http://www.inf.puc-rio.br/~brunoos/luasec/download/luasec-0.4.1.tar.gz):

  * ssl.dll -> ssl.dll
  
  * luasec-luasec-0.4.1/src/ssl.lua -> ssl.lua
  
  * luasec-luasec-0.4.1/src/https.lua -> ssl/https.lua
  
You also need to install OpenSSL: [Windows](http://slproweb.com/products/Win32OpenSSL.html)

Place these files where the love executable can get to them, where love is installed or the lua path.

Then go into conf.lua and set useLuaSec to true

**Mac:**

There is an ssl.so file on the Binaries page.

I don't know if it works since I don't have a mac.

Someone try it and tell me if you can get https working.

#Configuration
CCLite allows you to configure various properties just like ComputerCraft does.

The configuration is stored in (Save Folder)/CCLite.cfg

If you are using the Multi Computer (frames) version of CCLite, the configuration can be edited from inside CCLite.

- `enableAPI_http`  
  This setting allows the user to configure whether the http api and associated libraries will be loaded on startup
- `enableAPI_cclite`  
  This setting allows the user to configure whether the cclite api will be avaliable to ComputerCraft
- `terminal_width`  
  This setting changes the width of the Terminal given to ComputerCraft
- `terminal_height`  
  This setting changes the height of the Terminal given to ComputerCraft
- `terminal_guiScale`  
  This setting changes the pixel scale of the Terminal given to ComputerCraft
- `cclite_showFPS`  
  This setting toggles the FPS Display for CCLite
- `lockfps`  
  This setting changes the Framerate CCLite will lock itself to
- `compat_faultyClip`  
  ComputerCraft doesn't handle trimming to the first newline (if present) properly in the Clipboard, this setting emulates this behavior
- `useCRLF`  
  This setting configures whether fs.writeLine will write \r\n or just \n for a newline
- `compat_loadstringMask`  
  This is an obsolete setting and using it will give you a warning. Older versions of CCLite attempted to emulate LuaJ's loadstring via files, and a better alternative was found
