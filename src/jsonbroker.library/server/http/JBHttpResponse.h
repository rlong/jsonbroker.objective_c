//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//




#import "JBAuthenticationInfo.h"
#import "JBWwwAuthenticate.h"
#import "JBHttpStatus.h"
#import "JBRange.h"

#import "JBEntity.h"


@interface JBHttpResponse : NSObject {
	
    // status
	int _status;
	//@property (nonatomic) int status;
	//@synthesize status = _status;

    NSMutableDictionary* _headers;
	//@property (nonatomic, retain) NSMutableDictionary* headers;
	//@synthesize headers = _headers;

	// range
	JBRange* _range;
	//@property (nonatomic, retain) Range* range;
	//@synthesize range = _range;

    
    ////////////////////////////////////////////////////////////////////////////
	// entity
	id<JBEntity> _entity;
	//@property (nonatomic, retain) id<Entity> entity;
	//@synthesize entity = _entity;
	
	
	
}

-(void)setContentType:(NSString*)contentType; 

-(void)putHeader:(NSString*)header value:(NSString*)value;
-(NSString*)getHeader:(NSString*)header;


#pragma mark instance setup/teardown 


-(id)initWithStatus:(int)status;

-(id)initWithStatus:(int)status entity:(id<JBEntity>)entity;


#pragma mark fields


// status
//int _status;
@property (nonatomic) int status;
//@synthesize status = _status;

//NSMutableDictionary* _headers;
@property (nonatomic, retain) NSMutableDictionary* headers;
//@synthesize headers = _headers;


// range
//Range* _range;
@property (nonatomic, retain) JBRange* range;
//@synthesize range = _range;

////////////////////////////////////////////////////////////////////////////
// entity
//id<Entity> _entity;
@property (nonatomic, retain) id<JBEntity> entity;
//@synthesize entity = _entity;


@end
