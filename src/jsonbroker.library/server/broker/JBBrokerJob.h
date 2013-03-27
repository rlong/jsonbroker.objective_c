//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBJavascriptCallbackAdapter.h"
#import "JBJob.h"
#import "JBService.h"

@interface JBBrokerJob : NSObject <JBJob> {

    //private Data _jsonRequestData;
    NSData* _jsonRequestData;
    //@property (nonatomic, retain) NSData* jsonRequestData;
    //@synthesize jsonRequestData = _jsonRequestData;
    
    //private String _jsonRequestString;
    NSString* _jsonRequestString;
    //@property (nonatomic, retain) NSString* jsonRequestString;
    //@synthesize jsonRequestString = _jsonRequestString;

    
    // servicesRegistery
	id<JBService> _service;
	//@property (nonatomic, retain) id<Service> servicesRegistery;
	//@synthesize servicesRegistery = _servicesRegistery;

    //private CallbackAdapter _callbackAdapter;
    id<JBJavascriptCallbackAdapter> _callbackAdapter;
    //@property (nonatomic, retain) id<CallbackAdapter> callbackAdapter;
    //@synthesize callbackAdapter = _callbackAdapter;
    

}


+(NSString*)JSON_BROKER_SCHEME;


#pragma mark instance lifecycle

// 'transientServices' can be nil
-(id)initWithJsonRequestString:(NSString*)jsonRequest service:(id<JBService>)service callbackAdapter:(id<JBJavascriptCallbackAdapter>)callbackAdapter;

// 'transientServices' can be nil
-(id)initWithJsonRequestData:(NSData*)jsonRequest service:(id<JBService>)service callbackAdapter:(id<JBJavascriptCallbackAdapter>)callbackAdapter;


#pragma mark fields

//private CallbackAdapter _callbackAdapter;
//id<CallbackAdapter> _callbackAdapter;
@property (nonatomic, retain) id<JBJavascriptCallbackAdapter> callbackAdapter;
//@synthesize callbackAdapter = _callbackAdapter;




@end
