//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBService.h"

@interface JBNullService : NSObject <JBService> {
    
    // serviceName
	NSString* _serviceName;
	//@property (nonatomic, retain) NSString* serviceName;
	//@synthesize serviceName = _serviceName;


}


#pragma mark instance lifecycle


-(id)initWithServiceName:(NSString*)serviceName;

#pragma mark fields


// serviceName
//NSString* _serviceName;
@property (nonatomic, retain) NSString* serviceName;
//@synthesize serviceName = _serviceName;


@end
