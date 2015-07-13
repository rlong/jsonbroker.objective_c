// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBBrokerMessage.h"
#import "JBBrokerMessageType.h"
#import "JBFaultSerializer.h"
#import "JBJsonArray.h"
#import "JBJsonArrayHandler.h"
#import "JBJsonObject.h"
#import "JBObjectTracker.h"
#import "JBJsonStringOutput.h"

@implementation JBBrokerMessage


+(JBBrokerMessage*)buildRequestWithServiceName:(NSString*)serviceName methodName:(NSString*)methodName {

    JBBrokerMessage* answer = [[JBBrokerMessage alloc] init];
	[answer autorelease];
    
    [answer setMessageType:[JBBrokerMessageType request]];
    
    // metaInformation is setup in the init
    [answer setServiceName:serviceName];
    [answer setMethodName:methodName];
    
    return answer;

}

+(JBBrokerMessage*)buildMetaRequestWithServiceName:(NSString*)serviceName methodName:(NSString*)methodName {
    
    JBBrokerMessage* answer = [[JBBrokerMessage alloc] init];
	[answer autorelease];
    
    [answer setMessageType:[JBBrokerMessageType metaRequest]];
    
    // metaInformation is setup in the init
    [answer setServiceName:serviceName];
    [answer setMethodName:methodName];
    
    return answer;
    
}

+(JBBrokerMessage*)buildFault:(JBBrokerMessage*)request exception:(NSException*)exception {

    JBBrokerMessage* answer = [[JBBrokerMessage alloc] init];
	[answer autorelease];

    [answer setMessageType:[JBBrokerMessageType fault]];
    [answer setMetaData:[request metaData]];

    // metaInformation is setup in the init
    [answer setServiceName:[request serviceName]];
    [answer setMethodName:[request methodName]];
    [answer setAssociativeParamaters:[JBFaultSerializer toJSONObject:exception]];
    // parameters are set in the init 
    
    
    return answer;

}

+(JBBrokerMessage*)buildMetaResponse:(JBBrokerMessage*)request {
	
	JBBrokerMessage* answer = [[JBBrokerMessage alloc] init];
	[answer autorelease];
	
	[answer setMessageType:[JBBrokerMessageType metaResponse]];
    [answer setMetaData:[request metaData]];
	[answer setServiceName:[request serviceName]];
	[answer setMethodName:[request methodName]];
	
    
	return answer;
	
}

+(JBBrokerMessage*)buildResponse:(JBBrokerMessage*)request {
	
	JBBrokerMessage* answer = [[JBBrokerMessage alloc] init];
	[answer autorelease];
	
	[answer setMessageType:[JBBrokerMessageType response]];
    [answer setMetaData:[request metaData]];
	[answer setServiceName:[request serviceName]];
	[answer setMethodName:[request methodName]];
	
	 
	return answer;
	
}

-(bool)hasOrderedParamaters {
    if( nil != _orderedParamaters ) {
        return false;
    }
    return true;

}

-(JBJsonArray*)orderedParamaters {
    if( nil != _orderedParamaters ) {
        return _orderedParamaters;
    }
    
    _orderedParamaters = [[JBJsonArray alloc] init];
    return _orderedParamaters;
    
}



-(NSString*)toString {
    
    NSString* answer;
    
    JBJsonStringOutput* writer = [[JBJsonStringOutput alloc] init];
    {
        JBJsonArray* messageComponents = [self toJsonArray];
        
        
        JBJsonArrayHandler* jsonArrayHandler = [JBJsonArrayHandler getInstance];
        [jsonArrayHandler writeValue:messageComponents writer:writer];
        
        answer = [writer toString];
        
    }
    [writer release];
    
    return answer;

    
}


-(JBJsonArray*)toJsonArray {
    
    JBJsonArray* answer = [[JBJsonArray alloc] initWithCapacity:8];
    [answer autorelease];
    
    [answer add:[_messageType identifier]];
    [answer add:_metaData];
    [answer add:_serviceName];
    [answer addInteger:1]; // majorVersion
    [answer addInteger:0]; // minorVersion
    [answer add:_methodName];
    [answer add:_associativeParamaters];
    if( nil != _orderedParamaters ) {
        
        [answer add:_orderedParamaters];
    }
    
    return answer;
}


#pragma mark -
#pragma mark instance lifecycle

-(id)init {
	
	
	JBBrokerMessage* answer = [super init];
	[JBObjectTracker allocated:answer];

	
	answer->_metaData = [[JBJsonObject alloc] init];
	answer->_associativeParamaters = [[JBJsonObject alloc] init];
	answer->_orderedParamaters = nil;
	
	
	return answer;
	 
}



-(id)initWithValues:(JBJsonArray*)values {
	
	JBBrokerMessage* answer = [self init];	
	
	NSString* messageTypeIdentifer = [values getString:0];
	
	[answer setMessageType:[JBBrokerMessageType lookup:messageTypeIdentifer]];
	[answer setMetaData:[values jsonObjectAtIndex:1]];
	[answer setServiceName:[values getString:2]];
    
	[answer setMethodName:[values getString:5]];
	[answer setAssociativeParamaters:[values jsonObjectAtIndex:6]];
	
	if( 7 < [values count] ) { 
		
        [answer setOrderedParamaters:[values jsonArrayAtIndex:7]];
		
	} else {
        
        // no-op
        
	}
    
		
	
	
	return answer;
}



-(void)dealloc {
	
	[JBObjectTracker deallocated:self];
	
	[self setMessageType:nil];
	[self setMetaData:nil];
	[self setServiceName:nil];
	[self setMethodName:nil];
	[self setAssociativeParamaters:nil];
	[self setOrderedParamaters:nil];
	
	[super dealloc];
	
}

#pragma mark -
#pragma mark fields


//BrokerMessageType* _messageType;
//@property (nonatomic, retain) BrokerMessageType* messageType;
@synthesize messageType = _messageType;

//JsonObject* _metaData;
//@property (nonatomic, retain) JsonObject* metaData;
@synthesize metaData = _metaData;


//NSString* _serviceName;
//@property (nonatomic, retain) NSString* serviceName;
@synthesize serviceName = _serviceName;

//NSString* _methodName;
//@property (nonatomic, retain) NSString* methodName;
@synthesize methodName = _methodName;


//JSONObject* _associativeParamaters;
//@property (nonatomic, retain) JSONObject* associativeParamaters;
@synthesize associativeParamaters = _associativeParamaters;


// orderedParamaters
//JBJsonArray* _orderedParamaters;
//@property (nonatomic, retain, getter=orderedParamaters) JBJsonArray* orderedParamaters;
@synthesize orderedParamaters = _orderedParamaters;



@end
