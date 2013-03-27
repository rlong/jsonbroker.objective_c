//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <Foundation/Foundation.h>



#import "JBHttpRequest.h"
#import "JBRequestHandler.h"
#import "JBServicesRegistery.h"


@interface JBCorsServicesRequestHandler : NSObject <JBRequestHandler> {
    
	// servicesRegistery
	JBServicesRegistery* _servicesRegistery;
	//@property (nonatomic, retain) ServicesRegistery* servicesRegistery;
	//@synthesize servicesRegistery = _servicesRegistery;
    
}

-(void)addService:(id<JBDescribedService>)service;

#pragma mark -
#pragma mark instance lifecycle


-(id)init;
-(id)initWithServicesRegistery:(JBServicesRegistery*)servicesRegistery;



@end
