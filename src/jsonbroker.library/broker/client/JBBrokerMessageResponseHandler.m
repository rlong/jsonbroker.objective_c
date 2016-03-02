// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBrokerMessage.h"
#import "JBBrokerMessageResponseHandler.h"
#import "JBBrokerMessageType.h"
#import "JBDataHelper.h"
#import "JBFaultSerializer.h"
#import "JBSerializer.h"

#import "JBLog.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBBrokerMessageResponseHandler () 

// responseData
//NSData* _responseData;
@property (nonatomic, retain) NSData* responseData;
//@synthesize responseData = _responseData;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBBrokerMessageResponseHandler 


-(void)handleResponseHeaders:(NSDictionary*)headers responseEntity:(id<JBEntity>)responseEntity {
    
    
    [self setResponseData:[JBDataHelper fromEntity:responseEntity]];
    
}


-(JBBrokerMessage*)getResponse {
    JBBrokerMessage* answer = [JBSerializer deserialize:_responseData];
    
    if( [JBBrokerMessageType fault] == [answer messageType] ) {
        JBJsonObject* associativeParamaters = [answer associativeParamaters];
        BaseException* e = [JBFaultSerializer toBaseException:associativeParamaters];
        @throw e;
    }
    
    return answer;
    
}


#pragma mark instance lifecycle 

-(void)dealloc {
	
	[self setResponseData:nil];
	
	
}


#pragma mark fields


// responseData
//NSData* _responseData;
//@property (nonatomic, retain) NSData* responseData;
@synthesize responseData = _responseData;


@end
