// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


#import "JBHttpResponseHandler.h"

@class JBBrokerMessage;

@interface JBBrokerMessageResponseHandler : NSObject <JBHttpResponseHandler> {
    
    // responseData
	NSData* _responseData;
	//@property (nonatomic, retain) NSData* responseData;
	//@synthesize responseData = _responseData;

}


-(JBBrokerMessage*)getResponse;

@end
