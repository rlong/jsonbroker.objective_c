//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBRange.h"

#import "JBEntity.h"
#import "JBHttpMethod.h"

@interface JBHttpRequest : NSObject {
	
	// created
	NSDate* _created;
	//@property (nonatomic, retain) NSDate* created;
	//@synthesize created = _created;
    
    // method
    JBHttpMethod* _method;
    //@property (nonatomic, retain) JBHttpMethod* method;
    //@synthesize method = _method;
	
	NSString* _requestUri;
	//@property (nonatomic, retain) NSString* requestUri;
	//@synthesize requestUri = _requestUri;

	NSMutableDictionary* _headers;
	//@property (nonatomic, retain) NSMutableDictionary* headers;
	//@synthesize headers = _headers;

    // range
	JBRange* _range;
	//@property (nonatomic, retain, getter=range) Range* range;
	//@synthesize range = _range;

    // entity
	id<JBEntity> _entity;
	//@property (nonatomic, retain) id<Entity> entity;
	//@synthesize entity = _entity;

    
    // closeConnectionIndicated
    NSNumber* _closeConnectionIndicated;
    //@property (nonatomic, retain) NSNumber* closeConnectionIndicated;
    //@synthesize closeConnectionIndicated = _closeConnectionIndicated;

	
}



-(void)setHttpHeader:(NSString*)headerName headerValue:(NSString*)headerValue;

-(NSString*)getHttpHeader:(NSString*)headerName;

// vvv http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.10
-(BOOL)isCloseConnectionIndicated;
// ^^^ http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.10

#pragma mark instance setup/teardown 


#pragma mark fields


// created
//NSDate* _created;
@property (nonatomic, retain) NSDate* created;
//@synthesize created = _created;

// method
//JBHttpMethod* _method;
@property (nonatomic, retain) JBHttpMethod* method;
//@synthesize method = _method;

//NSString* _requestUri;
@property (nonatomic, retain) NSString* requestUri;
//@synthesize requestUri = _requestUri;

//NSMutableDictionary* _headers;
@property (nonatomic, retain) NSMutableDictionary* headers;
//@synthesize headers = _headers;



// range
//Range* _range;
@property (nonatomic, retain, getter=range) JBRange* range;
//@synthesize range = _range;


// entity
//id<Entity> _entity;
@property (nonatomic, retain) id<JBEntity> entity;
//@synthesize entity = _entity;


@end





