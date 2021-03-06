//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseProxy.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBBaseProxy () 


// service
//id<Service> _service;
@property (nonatomic, retain) id<JBService> service;
//@synthesize service = _service;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBBaseProxy


#pragma instance lifecycle  

-(id)initWithService:(id<JBService>)service {
    
    JBBaseProxy* answer = [super init];
    
    [answer setService:service];
    
    return answer;
}

-(void)dealloc {
    
	[self setService:nil];
	
	[super dealloc];
	
}


#pragma mark fields


// service
//id<Service> _service;
//@property (nonatomic, retain) id<Service> service;
@synthesize service = _service;


@end
