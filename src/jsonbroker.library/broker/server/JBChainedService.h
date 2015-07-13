//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBService.h"

@interface JBChainedService : NSObject <JBService> {
    
	// serviceName
	NSString* _serviceName;
	//@property (nonatomic, retain) NSString* serviceName;
	//@synthesize serviceName = _serviceName;

    // next
	id<JBService> _serviceDelegate;
	//@property (nonatomic, retain) id<Service> serviceDelegate;
	//@synthesize serviceDelegate = _serviceDelegate;

    // next
	id<JBService> _next;
	//@property (nonatomic, retain) id<Service> next;
	//@synthesize next = _next;

    
}

@end
