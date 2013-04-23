//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBrokerJob.h"
#import "JBJavascriptCallbackAdapterHelper.h"
#import "JBOsxWebViewBridge.h"

#import "JBWorkManager.h"
#import "JBLog.h"
#import "JBObjectTracker.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBOsxWebViewBridge () 

//WebView _webView;
//WebView* _webView;
@property (nonatomic, assign) WebView* webView; // we do *NOT* retain '_webView', doing can result in the WebView being realeased and dealloc'ed in a non-UI thread
//@synthesize webView = _webView;

// webUIDelegate
//JsonBrokerWebUIDelegate* _webUIDelegate;
@property (nonatomic, retain) JBWebUIDelegate* webUIDelegate;
//@synthesize webUIDelegate = _webUIDelegate;

// primaryService
//id<Service> _primaryService;
@property (nonatomic, retain) id<JBService> primaryService;
//@synthesize primaryService = _primaryService;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBOsxWebViewBridge


+ (BOOL)isSelectorExcludedFromWebScript:(SEL)selector {
    
    Log_enteredMethod();
    
    
    Log_debugString(NSStringFromSelector(selector) );
    
    if (selector == @selector(dispatch:)) {
        return NO;
    }
    return YES;
    
    
}


+ (NSString *) webScriptNameForSelector:(SEL)sel {
    
    Log_enteredMethod();
    Log_debugString(NSStringFromSelector(sel) );
    
    if (sel == @selector(dispatch:)) {
        return @"dispatch";
    }
    
    return nil;
    
}

#pragma javascript method

-(void)dispatch:(NSString*)jsonString { 
    
    Log_debugString(jsonString );
    
    JBBrokerJob* job = [[JBBrokerJob alloc] initWithJsonRequestString:jsonString service:_primaryService callbackAdapter:self];
    {
        [JBWorkManager enqueue:job];
    }
    [job release];
    
    
}


#pragma <WebResourceLoadDelegate>


/* this message is sent to the WebView's frame load delegate 
 when the page is ready for JavaScript.  It will be called just after 
 the page has loaded, but just before any JavaScripts start running on the
 page.  This is the perfect time to install any of your own JavaScript
 objects on the page.
 */
- (void)webView:(WebView *)webView windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject {
    
    
    Log_enteredMethod();
    
    //    /* here we'll add our object to the window object as an object named
    //     'console'.  We can use this object in JavaScript by referencing the 'console'
    //     property of the 'window' object.   */
    //    [windowScriptObject setValue:self forKey:@"console"];
    
    [windowScriptObject setValue:self forKey:@"external"];
    
}


#pragma mark -
#pragma mark <JBJavascriptCallbackAdapter> implementation


-(void)postJavascript:(NSString*)javascript {
	
	
	Log_debugString(javascript );
    
    // vvv http://www.codeproject.com/tips/60924/Using-WebBrowser-Document-InvokeScript-to-mess-aro.aspx
    
    NSArray* arguments = [NSArray arrayWithObject:javascript];
    [[_webView windowScriptObject] callWebScriptMethod:@"eval" withArguments:arguments];
    
    // ^^^ http://www.codeproject.com/tips/60924/Using-WebBrowser-Document-InvokeScript-to-mess-aro.aspx
    
	
}


-(void)onFault:(NSException*)fault request:(JBBrokerMessage*)request {
	
    Log_enteredMethod();
    
    
    NSString* javascript = [JBJavascriptCallbackAdapterHelper buildJavascriptFault:request fault:fault];
    
    Log_warnString( javascript);
    
    [self performSelectorOnMainThread:@selector(postJavascript:) withObject:javascript waitUntilDone:NO];
    
    
}



//-(void)onNotification:(JBBrokerMessage*)notification {
//    
//    Log_enteredMethod();
//    
//    NSString* javascript = [JBJavascriptCallbackAdapterHelper buildJavascriptNotification:notification];
//    Log_debugString(javascript );
//    
//    [self performSelectorOnMainThread:@selector(postJavascript:) withObject:javascript waitUntilDone:NO];
//    
//    
//}


-(void)onResponse:(JBBrokerMessage*)response {
    
    Log_enteredMethod();
    
    NSString* javascript = [JBJavascriptCallbackAdapterHelper buildJavascriptResponse:response];
    
    
    Log_debugString(javascript );
    
    
    [self performSelectorOnMainThread:@selector(postJavascript:) withObject:javascript waitUntilDone:NO];
    
    
    
}

#pragma instance lifecycle 

-(id)initWithWebView:(WebView*)webView primaryService:(id<JBService>)primaryService{
    
    JBOsxWebViewBridge* answer = [super init];
    
    if( nil != answer ) {

        [JBObjectTracker allocated:answer];
        
        [answer setWebView:webView];
        answer->_webUIDelegate = [[JBWebUIDelegate alloc] init];
        [webView setUIDelegate:answer->_webUIDelegate];
        
        [answer setPrimaryService:primaryService];

    }

    return answer;
    
}


-(void)dealloc{

    [JBObjectTracker deallocated:self];
    
    [_webView setUIDelegate:nil];
    [self setWebView:nil];
    
    [self setWebUIDelegate:nil];
    
    [self setPrimaryService:nil];


    [super dealloc];

}

#pragma fields


//WebView _webView;
//WebView* _webView;
//@property (nonatomic, assign) WebView* webView; // we do *NOT* retain '_webView', doing can result in the WebView being realeased and dealloc'ed in a non-UI thread
@synthesize webView = _webView;

// webUIDelegate
//JsonBrokerWebUIDelegate* _webUIDelegate;
//@property (nonatomic, retain) JsonBrokerWebUIDelegate* webUIDelegate;
@synthesize webUIDelegate = _webUIDelegate;

//
//// transientServices
////ServicesRegistery* _transientServices;
////@property (nonatomic, retain) ServicesRegistery* transientServices;
//@synthesize transientServices = _transientServices;
//

// primaryService
//id<Service> _primaryService;
//@property (nonatomic, retain) id<Service> primaryService;
@synthesize primaryService = _primaryService;


@end
