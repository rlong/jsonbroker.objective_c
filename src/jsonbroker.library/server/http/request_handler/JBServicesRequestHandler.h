//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <Foundation/Foundation.h>


#import "JBServicesRegistery.h"

#import "JBRequestHandler.h"

@interface JBServicesRequestHandler : NSObject <JBRequestHandler> {
    
	// servicesRegistery
	JBServicesRegistery* _servicesRegistery;
	//@property (nonatomic, retain) ServicesRegistery* servicesRegistery;
	//@synthesize servicesRegistery = _servicesRegistery;

}


-(void)addService:(id<JBDescribedService>)service;


+(JBHttpResponse*)processPostRequest:(JBHttpRequest*)request withServiceRegistery:(JBServicesRegistery*)servicesRegistery;

#pragma mark instance lifecycle 

-(id)init;
-(id)initWithServicesRegistery:(JBServicesRegistery*)servicesRegistery;


@end
