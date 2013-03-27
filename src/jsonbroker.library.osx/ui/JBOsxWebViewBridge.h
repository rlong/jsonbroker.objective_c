//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

#import "JBJavascriptCallbackAdapter.h"
#import "JBWebUIDelegate.h"
#import "JBServicesRegistery.h"

@interface JBOsxWebViewBridge : NSObject <JBJavascriptCallbackAdapter> {
    
    //WebView _webView;
	WebView* _webView;
	//@property (nonatomic, assign) WebView* webView; // we do *NOT* retain '_webView', doing can result in the WebView being realeased and dealloc'ed in a non-UI thread
	//@synthesize webView = _webView;
    
    
    // webUIDelegate
	JBWebUIDelegate* _webUIDelegate;
	//@property (nonatomic, retain) JsonBrokerWebUIDelegate* webUIDelegate;
	//@synthesize webUIDelegate = _webUIDelegate;

    
    // primaryService
	id<JBService> _primaryService;
	//@property (nonatomic, retain) id<Service> primaryService;
	//@synthesize primaryService = _primaryService;

    
    
}


#pragma instance lifecycle 

-(id)initWithWebView:(WebView*)webView primaryService:(id<JBService>)primaryService;

@end
