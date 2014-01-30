// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBEntity.h"

@interface JBHttpRequestAdapter : NSObject {

    // requestUri
	NSString* _requestUri;
	//@property (nonatomic, retain) NSString* requestUri;
	//@synthesize requestUri = _requestUri;
    
    // requestHeaders
	NSMutableDictionary* _requestHeaders;
	//@property (nonatomic, retain) NSDictionary* requestHeaders;
	//@synthesize requestHeaders = _requestHeaders;


    // requestEntity
	id<JBEntity> _requestEntity;
	//@property (nonatomic, retain) id<Entity> requestEntity;
	//@synthesize requestEntity = _requestEntity;

}

// as per NSMutableURLRequest
- (void)addValue:(NSString *)value forHTTPHeaderField:(NSString *)field;


#pragma mark instance lifecycle

-(id)initWithRequestUri:(NSString*)requestUri; 

#pragma mark fields

// requestUri
//NSString* _requestUri;
@property (nonatomic, retain) NSString* requestUri;
//@synthesize requestUri = _requestUri;


// requestHeaders
//NSMutableDictionary* _requestHeaders;
@property (nonatomic, retain) NSDictionary* requestHeaders;
//@synthesize requestHeaders = _requestHeaders;


// requestEntity
//id<Entity> _requestEntity;
@property (nonatomic, retain) id<JBEntity> requestEntity;
//@synthesize requestEntity = _requestEntity;

@end
