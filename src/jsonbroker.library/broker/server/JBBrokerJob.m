//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBrokerJob.h"
#import "JBBrokerMessageType.h"
#import "JBDataHelper.h"
#import "JBLog.h"
#import "JBObjectTracker.h"
#import "JBSerializer.h"
#import "JBServicesRegistery.h"
#import "JBStringHelper.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBBrokerJob () 

//private Data _jsonRequestData;
//NSData* _jsonRequestData;
@property (nonatomic, retain) NSData* jsonRequestData;
//@synthesize jsonRequestData = _jsonRequestData;

//private String _jsonRequestString;
//NSString* _jsonRequestString;
@property (nonatomic, retain) NSString* jsonRequestString;
//@synthesize jsonRequestString = _jsonRequestString;


// servicesRegistery
//id<Service> _servicesRegistery;
@property (nonatomic, retain) id<JBService> service;
//@synthesize servicesRegistery = _servicesRegistery;



@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -



@implementation JBBrokerJob

static NSString* _JSON_BROKER_SCHEME = @"jsonbroker:"; 



+(NSString*)JSON_BROKER_SCHEME {
    return _JSON_BROKER_SCHEME;
}


-(NSData*)getJsonRequest {
	
	if( nil != _jsonRequestData ) { 
        
		return _jsonRequestData;
	}
	
	NSString* jsonString = _jsonRequestString;

	// come in from an embedded document ?
	if( [jsonString hasPrefix:_JSON_BROKER_SCHEME] ) { 
        
        jsonString = [jsonString substringFromIndex:[_JSON_BROKER_SCHEME length]];
        jsonString = [JBStringHelper decodeURIComponent:jsonString];
        
	}
    
    NSData* jsonRequestData = [JBDataHelper getUtf8Data:jsonString];
    
	[self setJsonRequestData:jsonRequestData]; // implicit retain
	
	return _jsonRequestData;
	
}


-(void)execute {
    
    JBBrokerMessage* request = nil;
    
    @try {
        request = [JBSerializer deserialize:[self getJsonRequest]];
    }
    @catch (NSException *e) {
        Log_warnException(e);
        return;
    }
    
    @try {
        
        JBBrokerMessage* response = [_service process:request];
        
        if( [JBBrokerMessageType oneway] == [request messageType] ) {
            // no reply 
        } else {
            [_callbackAdapter onResponse:response];
        }
    }
    @catch (NSException *exception) {
        [_callbackAdapter onFault:exception request:request];
    }

}


#pragma mark instance lifecycle

// 'transientServices' can be nil
-(id)initWithJsonRequestString:(NSString*)jsonRequest  service:(id<JBService>)service callbackAdapter:(id<JBJavascriptCallbackAdapter>)callbackAdapter {
	
	JBBrokerJob* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	[answer setJsonRequestString:jsonRequest];
    [answer setService:service];
	[answer setCallbackAdapter:callbackAdapter];
	
	return answer;
    
}

// 'transientServices' can be nil
-(id)initWithJsonRequestData:(NSData*)jsonRequest service:(id<JBService>)service callbackAdapter:(id<JBJavascriptCallbackAdapter>)callbackAdapter {
	
	JBBrokerJob* answer = [super init];
    
	[JBObjectTracker allocated:answer];
    
	[answer setJsonRequestData:jsonRequest];
    [answer setService:service];
	[answer setCallbackAdapter:callbackAdapter];
	
	return answer;
	
}


-(void)dealloc { 
	
	[JBObjectTracker deallocated:self];
	
	[self setJsonRequestData:nil];
	[self setJsonRequestString:nil];
    [self setService:nil];
	[self setCallbackAdapter:nil];
    
	
}

#pragma mark fields

//private Data _jsonRequestData;
//NSData* _jsonRequestData;
//@property (nonatomic, retain) NSData* jsonRequestData;
@synthesize jsonRequestData = _jsonRequestData;

//private String _jsonRequestString;
//NSString* _jsonRequestString;
//@property (nonatomic, retain) NSString* jsonRequestString;
@synthesize jsonRequestString = _jsonRequestString;

// servicesRegistery
//id<Service> _servicesRegistery;
//@property (nonatomic, retain) id<Service> servicesRegistery;
@synthesize service = _service;

//private CallbackAdapter _callbackAdapter;
//id<CallbackAdapter> _callbackAdapter;
//@property (nonatomic, retain) id<CallbackAdapter> callbackAdapter;
@synthesize callbackAdapter = _callbackAdapter;





@end
