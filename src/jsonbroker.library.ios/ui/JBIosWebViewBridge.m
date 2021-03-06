//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//




#import "JBBrokerJob.h"
#import "JBBrokerMessage.h"
#import "JBIosWebViewShower.h"
#import "JBMainThreadService.h"
#import "JBJavascriptCallbackAdapterHelper.h"
#import "JBObjectTracker.h"
#import "JBServicesRegistery.h"

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


// webViewShower
//JBIosWebViewShower* _webViewShower;
@property (nonatomic, retain) JBIosWebViewShower* webViewShower;
//@synthesize webViewShower = _webViewShower;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBIosWebViewBridge

#pragma mark -
#pragma mark <UIWebViewDelegate> implementation


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {


    [_webViewShower webView:webView didFailLoadWithError:error];

    Log_warnError( error );
    
    
    
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    [_webViewShower webView:webView shouldStartLoadWithRequest:request navigationType:navigationType]; // response is ignored
	
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
	
    
    [_webViewShower webViewDidFinishLoad:webView];
    
    _webViewDidFinishLoad = true;
    
    if( _onResumeCalled ) {
        [self onResume];
    }
    
    [self dispatchPendingRequest];

}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	
    [_webViewShower webViewDidStartLoad:webView];
    
}


#pragma mark -


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
    
    [answer setWebViewShower:[JBIosWebViewShower setup:webView]];
    
    
    answer->_onResumeCalled = FALSE;
    
	answer->_running = FALSE;
    answer->_webViewDidFinishLoad = FALSE;
    
	[answer setWebView:webView];
	[webView setDelegate:answer];
    [answer setServicesRegistery:servicesRegistery];

    
    NSURLRequest* urlRequest;
    {
        
        
        NSString* resourcePath = path;
        NSString* params = nil;
        
        // has parameters ?
        NSRange rangeOfFirstQuestionMark = [path rangeOfString:@"?"];
        if( NSNotFound != rangeOfFirstQuestionMark.location ) {
            resourcePath = [path substringToIndex:rangeOfFirstQuestionMark.location];
            params = [path substringFromIndex:rangeOfFirstQuestionMark.location];
            
        }
        
        Log_debugString(resourcePath);
        Log_debugString(params);

        // vvv http://stackoverflow.com/questions/11882501/nsurl-add-parameters-to-fileurlwithpath-method
        
        NSString *absoluteFilePath = [[NSBundle mainBundle] pathForResource:resourcePath ofType:nil];
        NSURL* url = [NSURL fileURLWithPath:absoluteFilePath];
        
        if( nil != params ) {
            NSString *urlString = [url absoluteString];
            NSString *urlWithQueryString = [urlString stringByAppendingString:params];
            Log_debugString( urlWithQueryString );
            
            url = [NSURL URLWithString:urlWithQueryString];
        }
        
        // ^^^ http://stackoverflow.com/questions/11882501/nsurl-add-parameters-to-fileurlwithpath-method

        
        urlRequest = [NSURLRequest requestWithURL:url];
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
	[self setWebViewShower:nil];

	[super dealloc];
}


#pragma mark -
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

// webViewShower
//JBIosWebViewShower* _webViewShower;
//@property (nonatomic, retain) JBIosWebViewShower* webViewShower;
@synthesize webViewShower = _webViewShower;


@end
