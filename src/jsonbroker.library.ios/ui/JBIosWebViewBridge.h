//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <UIKit/UIKit.h> // for UIWebViewDelegate, UIWebView

@class JBBrokerMessage;
@protocol JBDescribedService;
@class JBIosWebViewShower;
#import "JBJavascriptCallbackAdapter.h"
@class JBServicesRegistery;



@interface JBIosWebViewBridge : NSObject <UIWebViewDelegate,JBJavascriptCallbackAdapter> {
	
	//WebView _webView;
	UIWebView* _webView;
	//@property (nonatomic, assign) UIWebView* webView; // we do *NOT* retain '_webView', doing can result in the UIWebView being dealloc'ed in a non-UI thread, which causes a EXC_BAD_ACCESS error
	//@synthesize webView = _webView;
	
	//private boolean _active;
	bool _running;

    
    // transientServices
	JBServicesRegistery* _servicesRegistery;
	//@property (nonatomic, retain) ServicesRegistery* transientServices;
	//@synthesize transientServices = _transientServices;


	// pendingRequest
    JBBrokerMessage* _pendingRequest;
    //@property (nonatomic, retain) JBBrokerMessage* pendingRequest;
    //@synthesize pendingRequest = _pendingRequest;

    bool _webViewDidFinishLoad;
    bool _onResumeCalled;
    
    
    // webViewShower
    JBIosWebViewShower* _webViewShower;
    //@property (nonatomic, retain) JBIosWebViewShower* webViewShower;
    //@synthesize webViewShower = _webViewShower;
    


}


-(void)onResume;


-(void)onPause;


-(void)addTransientService:(id<JBDescribedService>)service; 

-(void)forwardRequest:(JBBrokerMessage*)request;

#pragma mark instance lifecycle 

-(JBIosWebViewBridge*)initWithWebView:(UIWebView*)webView path:(NSString*)path servicesRegistery:(JBServicesRegistery*)servicesRegistery;
-(JBIosWebViewBridge*)initWithWebView:(UIWebView*)webView path:(NSString*)path service:(id<JBDescribedService>)service;
-(JBIosWebViewBridge*)initWithWebView:(UIWebView*)webView path:(NSString*)path;



@end
