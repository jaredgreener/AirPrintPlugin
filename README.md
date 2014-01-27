AirPrintPlugin
==============

Air Print Plugin for Cordova 3+

This is a cordova-ready plugin for Apple AirPrint compatability. Instructions:

  1. Include the plugin via command line: cordova plugin add https://github.com/jaredgreener/AirPrintPlugin
  2. Include the JS file like so: <script type="text/javascript" charset="utf-8" src="AirPrint.js"></script>
  3. Call plugin like this:
      window.plugins.airPrint.print(
		     "<h1>Hello World</h1><p>More HTML here...</p>",
		     function() { // success callback
 		        
		     }, 
		     function() { // failure callback
		     
		     }
		 );
		 
		 
Enjoy!
