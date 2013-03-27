jsonbroker.objective_c
======================


A non-ARC Objective-C library  which incorporates:

* __Common Components:__
	* logging
	* base exception
	* JSON objects 
	* JSON parser
	* configuration manager
	* work manager for executing jobs off of the main thread
	
* __Client Components__:
	* support for HTTP authentication [RFC 2617](http://www.ietf.org/rfc/rfc2617.txt)
	
	
* __Server Components__:
	* HTTP Server (partial implementation of [RFC 2616](http://www.w3.org/Protocols/rfc2616/rfc2616.html))
	* HTTP Authentication (partial implementation of [RFC 2617](http://www.ietf.org/rfc/rfc2617.txt))
	* Service Container for implementation of Objective-C services.
	
	
* __User Interface Components__:
	* bridge to javascript embedded within a `UIWebView` on iOS  
	* bridge to javascript embedded within a `WebView` on OSX