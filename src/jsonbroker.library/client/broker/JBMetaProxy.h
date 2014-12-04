// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>


@protocol JBService;

@interface JBMetaProxy : NSObject {
    
    // service
	id<JBService> _service;
	//@property (nonatomic, retain) id<Service> service;
	//@synthesize service = _service;

}


-(NSArray*)getVersion:(NSString*)serviceName;

#pragma mark instance lifecycle

-(id)initWithService:(id<JBService>)service;

@end
