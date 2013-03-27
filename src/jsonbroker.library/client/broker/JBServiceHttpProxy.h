// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBBrokerMessageResponseHandler.h"
#import "JBHttpDispatcher.h"
#import "JBService.h"

@interface JBServiceHttpProxy : NSObject <JBService> {
    
    // httpDispatcher
	JBHttpDispatcher* _httpDispatcher;
	//@property (nonatomic, retain) HttpDispatcher* httpDispatcher;
	//@synthesize httpDispatcher = _httpDispatcher;
    
    // authenticator
	JBAuthenticator* _authenticator;
	//@property (nonatomic, retain) Authenticator* authenticator;
	//@synthesize authenticator = _authenticator;

    // responseHandler
	JBBrokerMessageResponseHandler* _responseHandler;
	//@property (nonatomic, retain) BrokerMessageResponseHandler* responseHandler;
	//@synthesize responseHandler = _responseHandler;


}

// can return nil
-(NSString*)realm;


#pragma mark instance lifecycle

-(id)initWithHttpDispatcher:(JBHttpDispatcher*)httpDispatcher;

-(id)initWithHttpDispatcher:(JBHttpDispatcher*)httpDispatcher authenticator:(JBAuthenticator*)authenticator;

#pragma mark fields


// authenticator
//Authenticator* _authenticator;
@property (nonatomic, retain) JBAuthenticator* authenticator;
//@synthesize authenticator = _authenticator;


@end
