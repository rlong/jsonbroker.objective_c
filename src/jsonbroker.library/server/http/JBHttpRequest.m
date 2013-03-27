//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBHttpRequest.h"
#import "JBObjectTracker.h"

#import "JBLog.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBHttpRequest ()

// closeConnectionIndicated
//NSNumber* _closeConnectionIndicated;
@property (nonatomic, retain) NSNumber* closeConnectionIndicated;
//@synthesize closeConnectionIndicated = _closeConnectionIndicated;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation JBHttpRequest


-(JBRange*)range {
    
    
    if( nil != _range ) {
        
        return _range;
        
    }
    NSString* rangeValue = [_headers objectForKey:@"range"];
    
    if( nil == rangeValue ) {
        return nil;
    }
    
    JBRange* range = [JBRange buildFromString:rangeValue];
    [self setRange:range];
    
    return _range;
}

-(void)setHttpHeader:(NSString*)headerName headerValue:(NSString*)headerValue { 
    [_headers setObject:headerValue forKey:headerName];
}

-(NSString*)getHttpHeader:(NSString*)headerName { 
    return [_headers objectForKey:headerName];
}


// vvv http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.10

-(BOOL)isCloseConnectionIndicated {

    if( nil != _closeConnectionIndicated ) {
        return [_closeConnectionIndicated boolValue];
    }
    
    
    NSString* connectionValue = [self getHttpHeader:@"connection"];

    NSNumber* closeConnectionIndicated = [NSNumber numberWithBool:FALSE];
    
    if( nil != connectionValue ) {
        if( [@"close" isEqualToString:connectionValue] ) {
            closeConnectionIndicated = [NSNumber numberWithBool:TRUE];
        }
    }
    
    [self setCloseConnectionIndicated:closeConnectionIndicated];
    
    return [_closeConnectionIndicated boolValue];
    
}

// ^^^ http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.10


#pragma mark -
#pragma mark instance lifecycle

-(id)init {
	
	JBHttpRequest* answer = [super init];
	
	
	[JBObjectTracker allocated:answer];
    
    [answer setCreated:[NSDate date]];
    [answer setMethod:[JBHttpMethod GET]];
	answer->_headers = [[NSMutableDictionary alloc] init];
    answer->_range = nil;
    answer->_closeConnectionIndicated = nil;

	return answer;

	
}

-(void)dealloc {
	
	[JBObjectTracker deallocated:self];
	
    [self setCreated:nil];
	[self setMethod:nil];
	[self setRequestUri:nil];
	[self setHeaders:nil];
    [self setRange:nil];
    [self setEntity:nil];
	[self setCloseConnectionIndicated:nil];
	
	[super dealloc];
}


#pragma mark -
#pragma mark fields

// created
//NSDate* _created;
//@property (nonatomic, retain) NSDate* created;
@synthesize created = _created;

// method
//JBHttpMethod* _method;
//@property (nonatomic, retain) JBHttpMethod* method;
@synthesize method = _method;

//NSString* _requestUri;
//@property (nonatomic, retain) NSString* requestUri;
@synthesize requestUri = _requestUri;


//NSMutableDictionary* _headers;
//@property (nonatomic, retain) NSMutableDictionary* headers;
@synthesize headers = _headers;

// range
//Range* _range;
//@property (nonatomic, retain, getter=range) Range* range;
@synthesize range = _range;


// entity
//id<Entity> _entity;
//@property (nonatomic, retain) id<Entity> entity;
@synthesize entity = _entity;


// closeConnectionIndicated
//NSNumber* _closeConnectionIndicated;
//@property (nonatomic, retain) NSNumber* closeConnectionIndicated;
@synthesize closeConnectionIndicated = _closeConnectionIndicated;


@end

