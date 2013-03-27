// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBHttpRequestAdapter.h"

@implementation JBHttpRequestAdapter

#pragma mark instance lifecycle

-(id)initWithRequestUri:(NSString*)requestUri { 
    
    JBHttpRequestAdapter* answer = [super init];
    
    [answer setRequestUri:requestUri];
    answer->_requestHeaders = [[NSMutableDictionary alloc] init];
    
    return answer;
    
}

-(void)dealloc {
	
	[self setRequestUri:nil];
	[self setRequestHeaders:nil];
	[self setRequestEntity:nil];
	
	[super dealloc];
	
}


#pragma mark fields

// requestUri
//NSString* _requestUri;
//@property (nonatomic, retain) NSString* requestUri;
@synthesize requestUri = _requestUri;


// requestHeaders
//NSMutableDictionary* _requestHeaders;
//@property (nonatomic, retain) NSDictionary* requestHeaders;
@synthesize requestHeaders = _requestHeaders;


// requestEntity
//id<Entity> _requestEntity;
//@property (nonatomic, retain) id<Entity> requestEntity;
@synthesize requestEntity = _requestEntity;


@end
