// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBaseException.h"
#import "JBDataHelper.h"
#import "JBJsonArrayHandler.h"
#import "JBSerializer.h"
#import "JBJsonArrayHandler.h"
#import "JBJsonDataInput.h"
#import "JBJsonStringOutput.h"


@implementation JBSerializer


static JBJsonArrayHandler* _jsonArrayHandler = nil; 

+(void)initialize {
	
    _jsonArrayHandler = [JBJsonArrayHandler getInstance];
	
}


	
+(JBBrokerMessage*)deserialize:(NSData*)data {
	
	JBJsonDataInput* reader = [[JBJsonDataInput alloc] initWithData:data];
	
	[reader scanToNextToken];

    JBJsonArray* messageComponents;
    @try {
        messageComponents = [[JBJsonArrayHandler getInstance] readJSONArray:reader];
    }
    @catch (BaseException *exception) {
        
        [exception addIntContext:[reader cursor] withName:@"Serializer.dataOffset"];
        @throw exception;
        
    }
	
	JBBrokerMessage* answer = [[JBBrokerMessage alloc] initWithValues:messageComponents];
	[answer autorelease];
	
	[reader release];
	
	return answer;
	
}

+(NSData*)serialize:(JBBrokerMessage*)message { 
    
    NSData* answer;
    
    JBJsonStringOutput* writer = [[JBJsonStringOutput alloc] init];
    {
        JBJsonArray* messageComponents = [message toJsonArray];
        [_jsonArrayHandler writeValue:messageComponents writer:writer];
        
        NSString* json = [writer toString];
        
        answer = [JBDataHelper getUtf8Data:json];
        
    }
    [writer release];
    
    return answer;
    
}


@end
