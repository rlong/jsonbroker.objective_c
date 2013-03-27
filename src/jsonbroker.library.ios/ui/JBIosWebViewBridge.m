//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//




#import "JBBrokerJob.h"
#import "JBGuiService.h"
#import "JBJavascriptCallbackAdapterHelper.h"
#import "JBObjectTracker.h"

#import "JBLog.h"
#import "JBIosWebViewBridge.h"
#import "JBWorkManager.h"




////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBIosWebViewBridge () 

//WebView _webView;
//UIWebView* _webView;
@property (nonatomic, assign) UIWebView* webView; // we do *NOT* retain '_webView', doing can result in the UIWebView being dealloc'ed in a non-UI thread, which causes a EXC_BAD_ACCESS error
//@synthesize webView = _webView;



// transientServices
//ServicesRegistery* _transientServices;
@property (nonatomic, retain) JBServicesRegistery* servicesRegistery;
//@synthesize transientServices = _transientServices;

// pendingRequest
//JBBrokerMessage* _pendingRequest;
@property (nonatomic, retain) JBBrokerMessage* pendingRequest;
//@synthesize pendingRequest = _pendingRequest;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBIosWebViewBridge

#pragma mark <UIWebViewDelegate> implementation


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
    Log_warnError( error );
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	
	NSURL* url = [request URL];
	NSString* absoluteString = [url absoluteString];


	if( [absoluteString hasPrefix:[JBBrokerJob JSON_BROKER_SCHEME]]  ) {

        
        JBBrokerJob* job = [[JBBrokerJob alloc] initWithJsonRequestString:absoluteString service:_servicesRegistery callbackAdapter:self];
        {
            [JBWorkManager enqueue:job];
        }
        [job release];		
		return FALSE;
	}
	
	return TRUE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
    _webViewDidFinishLoad = true;
    
    [webView setHidden:false];
    
    if( _onResumeCalled ) {
        [self onResume];
    }
    
    [self dispatchPendingRequest];

}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	
}


-(void)dispatchPendingRequest {

    if( nil != _pendingRequest ) {
        
        NSString* javascript = [JBJavascriptCallbackAdapterHelper buildJavascriptForwardRequest:_pendingRequest];
        [_webView stringByEvaluatingJavaScriptFromString:javascript];
        [self setPendingRequest:nil];
        
    }

}



-(void)onResume { 
	
	Log_enteredMethod();
    
    _onResumeCalled = true;
    
    if( !_webViewDidFinishLoad ) {
        return;
    }
	
	if( _running ) {
		
		return;
	}
	
	_running = true;
	
    [_webView stringByEvaluatingJavaScriptFromString:@"jsonbroker.onResume();"];
    
	
	
}

-(void)onPause { 
    
	Log_enteredMethod();
	
	
	if( !_running ) {
		
		return;
	}
	
	_running = false;
	
	[_webView stringByEvaluatingJavaScriptFromString:@"jsonbroker.onPause();"];
    
}


-(void)addTransientService:(id<JBDescribedService>)service {

    [_servicesRegistery addService:service];

}


-(void)forwardRequest:(JBBrokerMessage*)request {
    
    if( !_webViewDidFinishLoad ) {
        if( nil != _pendingRequest ) {
            
            Log_warnFormat(@"nil != _pendingRequest; [_pendingRequest serviceName] = '%@'; [_pendingRequest methodName] = '%@'; will overwrite the pending request", [_pendingRequest serviceName], [_pendingRequest methodName]);
            
        }
        [self setPendingRequest:request];
        return;
    }
    
    NSString* javascript = [JBJavascriptCallbackAdapterHelper buildJavascriptForwardRequest:request];
	[self performSelectorOnMainThread:@selector(postJavascript:) withObject:javascript waitUntilDone:NO];
    
    
}


#pragma mark -
#pragma mark <JBJavascriptCallbackAdapter> implementation


-(void)postJavascript:(NSString*)javascript {
	    
	[_webView stringByEvaluatingJavaScriptFromString:javascript];
	
}




-(void)onFault:(BaseException*)fault request:(JBBrokerMessage*)request {
	
	if( !_running ) {
		
		Log_warn(@"!_active");
		return;
	}
	
	
	NSString* javascript = [JBJavascriptCallbackAdapterHelper buildJavascriptFault:request fault:fault];
	
    Log_warnString(javascript);
	[self performSelectorOnMainThread:@selector(postJavascript:) withObject:javascript waitUntilDone:NO];
	
	
}



-(void)onNotification:(JBBrokerMessage*)notification {
    
	if( !_running ) {
		
		Log_warn(@"!_active");
		return;
	}
	
	NSString* javascript = [JBJavascriptCallbackAdapterHelper buildJavascriptNotification:notification];
	
	[self performSelectorOnMainThread:@selector(postJavascript:) withObject:javascript waitUntilDone:NO];
}


-(void)onResponse:(JBBrokerMessage*)response {
    
	if( !_running ) {
		
		Log_warn(@"!_active");
		return;
	}
	
	NSString* javascript = [JBJavascriptCallbackAdapterHelper buildJavascriptResponse:response];
	
	[self performSelectorOnMainThread:@selector(postJavascript:) withObject:javascript waitUntilDone:NO];
	
	
}



#pragma mark -
#pragma mark instance lifecycle


-(JBIosWebViewBridge*)initWithWebView:(UIWebView*)webView path:(NSString*)path servicesRegistery:(JBServicesRegistery*)servicesRegistery {

    
	JBIosWebViewBridge* answer = [super init];
    
    [JBObjectTracker allocated:answer];
    
    answer->_onResumeCalled = FALSE;
    
	answer->_running = FALSE;
    answer->_webViewDidFinishLoad = FALSE;
    
	[answer setWebView:webView];
	[webView setDelegate:answer];
    [answer setServicesRegistery:servicesRegistery];

    
    NSURLRequest* urlRequest;
    {
        NSRange rangeOfLastDot = [path rangeOfString:@"." options:NSBackwardsSearch];
        if( NSNotFound == rangeOfLastDot.location ) {
            BaseException* e = [[BaseException alloc] initWithOriginator:answer line:__LINE__ faultStringFormat:@"NSNotFound == rangeOfLastDot.location; path = '%@'", path];
            [e autorelease];
            @throw e;
        }
        
        NSString* resourcePath = [path substringToIndex:rangeOfLastDot.location];
        NSString* extension = [path substringFromIndex:rangeOfLastDot.location+1];
        
        NSString *absoluteFilePath = [[NSBundle mainBundle] pathForResource:resourcePath ofType:extension];
        NSURL* baseURL = [NSURL fileURLWithPath:absoluteFilePath];
        
        urlRequest = [NSURLRequest requestWithURL:baseURL];
    }
    [webView loadRequest:urlRequest];
    
    return answer;
    
}


-(JBIosWebViewBridge*)initWithWebView:(UIWebView*)webView path:(NSString*)path service:(id<JBDescribedService>)service {
    
    Log_enteredMethod();

    
    JBServicesRegistery* servicesRegistery = [[JBServicesRegistery alloc] initWithService:service next:nil];
    @try {
        return [self initWithWebView:webView path:path servicesRegistery:servicesRegistery];
    }
    @finally {
        [servicesRegistery release];
    }
    
    
}


-(JBIosWebViewBridge*)initWithWebView:(UIWebView*)webView path:(NSString*)path {

    
    JBServicesRegistery* servicesRegistery = [[JBServicesRegistery alloc] init];
    @try {
        return [self initWithWebView:webView path:path servicesRegistery:servicesRegistery];
    }
    @finally {
        [servicesRegistery release];
    }
    

}


-(void)dealloc { 
	

	[JBObjectTracker deallocated:self];
	
    
	// [self onPause]; // no harm in a little redundancy ... unless it's in the wrong thread
	[self setWebView:nil];
    [self setServicesRegistery:nil];
    [self setPendingRequest:nil];

	[super dealloc];
}


#pragma mark fields

//WebView _webView;
//UIWebView* _webView;
//@property (nonatomic, assign) UIWebView* webView; // we do *NOT* retain '_webView', doing can result in the UIWebView being dealloc'ed in a non-UI thread, which causes a EXC_BAD_ACCESS error
@synthesize webView = _webView;


// transientServices
//ServicesRegistery* _transientServices;
//@property (nonatomic, retain) ServicesRegistery* transientServices;
@synthesize servicesRegistery = _servicesRegistery;

// pendingRequest
//JBBrokerMessage* _pendingRequest;
//@property (nonatomic, retain) JBBrokerMessage* pendingRequest;
@synthesize pendingRequest = _pendingRequest;


@end
