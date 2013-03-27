//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBHttpResponse.h"
#import "JBHttpStatus.h"
#import "JBObjectTracker.h"

#import "JBLog.h"



@implementation JBHttpResponse



-(void)setContentType:(NSString*)contentType {
	[_headers setObject:contentType forKey:@"Content-Type"];
}

-(void)putHeader:(NSString*)header value:(NSString*)value { 
    [_headers setObject:value forKey:header];
}

// can return nil
-(NSString*)getHeader:(NSString*)header { 
    
    return [_headers objectForKey:header];
}

#pragma mark instance setup/teardown 


-(id)initWithStatus:(int)status {
	JBHttpResponse* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
    [answer setStatus:status];
	answer->_headers = [[NSMutableDictionary alloc] init];
	
	return answer;
}

-(id)initWithStatus:(int)status entity:(id<JBEntity>)entity {

    JBHttpResponse* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
    [answer setStatus:status];
    
	answer->_headers = [[NSMutableDictionary alloc] init];

    [answer setEntity:entity];

	return answer;

}


-(void)dealloc {
	
	[JBObjectTracker deallocated:self];
	
	[self setHeaders:nil];
    [self setRange:nil];
    [self setEntity:nil];
	
	[super dealloc];
}



#pragma mark fields


// status
//int _status;
//@property (nonatomic) int status;
@synthesize status = _status;


//NSMutableDictionary* _headers;
//@property (nonatomic, retain) NSMutableDictionary* headers;
@synthesize headers = _headers;

// range
//Range* _range;
//@property (nonatomic, retain) Range* range;
@synthesize range = _range;


// entity
//id<Entity> _entity;
//@property (nonatomic, retain) id<Entity> entity;
@synthesize entity = _entity;




@end
