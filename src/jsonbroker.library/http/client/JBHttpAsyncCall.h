// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBHttpAsyncResponseHandler.h"

@interface JBHttpAsyncCall : NSObject {
    

    
    // delegate
    __unsafe_unretained id<JBHttpAsyncResponseHandler> _delegate;
    //@property (nonatomic, assign) id<JBHttpAsyncResponseHandler> delegate;
    //@synthesize delegate = _delegate;
    

    // urlConnection
	NSURLConnection* _urlConnection;
	//@property (nonatomic, retain) NSURLConnection* urlConnection;
	//@synthesize urlConnection = _urlConnection;
    
    // conditionLock
    NSConditionLock* _conditionLock;
	//@property (nonatomic, retain) NSConditionLock* conditionLock;
	//@synthesize conditionLock = _conditionLock;
    
    
    // error
	NSError* _error;
	//@property (nonatomic, retain) NSError* error;
	//@synthesize error = _error;

    
    bool _onResponseEntityStartedCalled;
    
    
}


-(void)start:(NSRunLoop*)runLoop;


-(void)cancel;

-(void)waitUntilCompleted;

#pragma mark -
#pragma mark instance lifecycle 

-(id)initWithRequest:(NSURLRequest*)request delegate:(id<JBHttpAsyncResponseHandler>)delegate;


#pragma mark fields
    



@end
