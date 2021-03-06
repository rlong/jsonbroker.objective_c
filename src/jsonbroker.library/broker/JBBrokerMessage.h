// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


@class JBBrokerMessageType;
@class JBJsonArray;
@class JBJsonObject;

@interface JBBrokerMessage : NSObject {
	
	JBBrokerMessageType* _messageType;
	//@property (nonatomic, retain) BrokerMessageType* messageType;
	//@synthesize messageType = _messageType;
	
	JBJsonObject* _metaData;
	//@property (nonatomic, retain) JsonObject* metaData;
	//@synthesize metaData = _metaData;
	
	NSString* _serviceName;
	//@property (nonatomic, retain) NSString* serviceName;
	//@synthesize serviceName = _serviceName;
	
	NSString* _methodName;
	//@property (nonatomic, retain) NSString* methodName;
	//@synthesize methodName = _methodName;
	
	JBJsonObject* _associativeParamaters;
	//@property (nonatomic, retain) JSONObject* associativeParamaters;
	//@synthesize associativeParamaters = _associativeParamaters;
	
    // orderedParamaters
    JBJsonArray* _orderedParamaters;
    //@property (nonatomic, retain, getter=orderedParamaters) JBJsonArray* orderedParamaters;
    //@synthesize orderedParamaters = _orderedParamaters;
    
	
	

}


+(JBBrokerMessage*)buildRequestWithServiceName:(NSString*)serviceName methodName:(NSString*)methodName;
+(JBBrokerMessage*)buildMetaRequestWithServiceName:(NSString*)serviceName methodName:(NSString*)methodName;

+(JBBrokerMessage*)buildFault:(JBBrokerMessage*)request exception:(NSException*)exception;

+(JBBrokerMessage*)buildMetaResponse:(JBBrokerMessage*)request;
+(JBBrokerMessage*)buildResponse:(JBBrokerMessage*)request;

-(bool)hasOrderedParamaters;

//-(void)addJSONObjectParameter:(JBJsonObject*)parameter;

-(JBJsonArray*)toJsonArray;

-(NSString*)toString;

#pragma mark -
#pragma mark instance lifecycle 


-(id)initWithValues:(JBJsonArray*)values;
	
#pragma mark -
#pragma mark fields

//BrokerMessageType* _messageType;
@property (nonatomic, retain) JBBrokerMessageType* messageType;
//@synthesize messageType = _messageType;

//JsonObject* _metaData;
@property (nonatomic, retain) JBJsonObject* metaData;
//@synthesize metaData = _metaData;


//NSString* _serviceName;
@property (nonatomic, retain) NSString* serviceName;
//@synthesize serviceName = _serviceName;

//NSString* _methodName;
@property (nonatomic, retain) NSString* methodName;
//@synthesize methodName = _methodName;


//JSONObject* _associativeParamaters;
@property (nonatomic, retain) JBJsonObject* associativeParamaters;
//@synthesize associativeParamaters = _associativeParamaters;

// orderedParamaters
//JBJsonArray* _orderedParamaters;
@property (nonatomic, retain, getter=orderedParamaters) JBJsonArray* orderedParamaters;
//@synthesize orderedParamaters = _orderedParamaters;

@end
