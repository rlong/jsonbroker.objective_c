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

#import "JBLog.h"


@implementation JBSerializer


static JBJsonArrayHandler* _jsonArrayHandler = nil; 

+(void)initialize {
	
    _jsonArrayHandler = [JBJsonArrayHandler getInstance];
	
}

	
+(JBBrokerMessage*)deserialize:(NSData*)data {
	
	JBJsonDataInput* reader = [[JBJsonDataInput alloc] initWithData:data];
	
    
    //Log_debugData( data );
    
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


@end
