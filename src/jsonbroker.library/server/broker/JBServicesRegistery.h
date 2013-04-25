//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBDescribedService.h"
#import "JBGuiService.h"
#import "JBService.h"



@interface JBServicesRegisteryErrorDomain : NSObject {
}

-(NSString*)SERVICE_NOT_FOUND;

@end


@interface JBServicesRegistery : NSObject <JBService> {
	
	
	NSMutableDictionary* _services;
	//@property (nonatomic, retain) NSMutableDictionary* services;
	//@synthesize services = _services;
	
	// next
	JBServicesRegistery* _next;
	//@property (nonatomic, retain) ServicesRegistery* next;
	//@synthesize next = _next;
	
	
}

+(JBServicesRegisteryErrorDomain*)errorDomain;

-(void)addService:(id<JBDescribedService>)service;
-(bool)hasService:(NSString*)serviceName;
-(id<JBService>)getService:(NSString*)serviceName;
-(void)removeService:(id<JBDescribedService>)serviceToRemove;



#pragma mark instance lifecycle

-(id)init;

// 'next' can be nil
-(id)initWithService:(id<JBDescribedService>)service next:(JBServicesRegistery*)next;

#pragma mark fields


// next
//ServicesRegistery* _next;
@property (nonatomic, retain) JBServicesRegistery* next;
//@synthesize next = _next;

@end


