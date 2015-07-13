//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBChainedService.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBChainedService () 

// serviceName
//NSString* _serviceName;
@property (nonatomic, retain) NSString* serviceName;
//@synthesize serviceName = _serviceName;

// next
//id<Service> _serviceDelegate;
@property (nonatomic, retain) id<JBService> serviceDelegate;
//@synthesize serviceDelegate = _serviceDelegate;

// next
//id<Service> _next;
@property (nonatomic, retain) id<JBService> next;
//@synthesize next = _next;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation JBChainedService


#pragma mark <Service> implementation

-(JBBrokerMessage*)process:(JBBrokerMessage*)request {
    
    NSString* serviceName = [request serviceName];
    if( [_serviceName isEqualToString:serviceName] ) { 
        return [_serviceDelegate process:request];
    }
    return [_next process:request];
    
}

#pragma mark instance lifecycle


-(id)initWithServiceName:(NSString*)serviceName serviceDelegate:(id<JBService>)serviceDelegate nextService:(id<JBService>)nextService {

    JBChainedService* answer = [super init];
    
    if( nil != answer ) { 
        
        [answer setServiceName:serviceName];
        [answer setServiceDelegate:serviceDelegate];
        [answer setNext:nextService];
    }
    
    return answer;
    
}
-(void)dealloc { 
    
    [self setServiceName:nil];
    [self setServiceDelegate:nil];
    [self setNext:nil];
    
    [super dealloc];
}

#pragma mark fields


// serviceName
//NSString* _serviceName;
//@property (nonatomic, retain) NSString* serviceName;
@synthesize serviceName = _serviceName;

// next
//id<Service> _serviceDelegate;
//@property (nonatomic, retain) id<Service> serviceDelegate;
@synthesize serviceDelegate = _serviceDelegate;

// next
//id<Service> _next;
//@property (nonatomic, retain) id<Service> next;
@synthesize next = _next;


@end
