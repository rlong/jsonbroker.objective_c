//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBrokerMessage.h"
#import "JBSerializer.h"
#import "JBTestService.h"
#import "JBTestProxy.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBTestProxy () 


// service
//id<Service> _service;
@property (nonatomic, retain) id<JBService> service;
//@synthesize service = _service;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation JBTestProxy


-(void)ping { 
    
    JBBrokerMessage* request = [JBBrokerMessage buildRequestWithServiceName:[JBTestService SERVICE_NAME] methodName:@"ping"];
    
    [_service process:request];
    
}


-(void)raiseError { 
    
    
    JBBrokerMessage* request = [JBBrokerMessage buildRequestWithServiceName:[JBTestService SERVICE_NAME] methodName:@"raiseError"];
    
    [_service process:request];
    
                              
}

#pragma instance -
#pragma instance lifecycle  

-(id)initWithService:(id<JBService>)service {
    
    
    JBTestProxy* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setService:service];
    
    }
    
    
    return answer;
}

-(void)dealloc {

	[self setService:nil];
	
	[super dealloc];
	
}

#pragma instance -
#pragma mark fields


// service
//id<Service> _service;
//@property (nonatomic, retain) id<Service> service;
@synthesize service = _service;



@end
