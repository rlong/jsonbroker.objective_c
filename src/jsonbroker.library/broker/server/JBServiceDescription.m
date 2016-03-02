//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBServiceDescription.h"

@implementation JBServiceDescription 


-(int)majorVersion {
    
    return 1;
    
}

-(int)minorVersion {
    
    return 0;    
    
}

#pragma mark instance lifecycle


-(id)initWithServiceName:(NSString*)serviceName {
    
    JBServiceDescription* answer = [super init];
    
    if( nil != answer ) {
        [answer setServiceName:serviceName];        
    }
    
    return answer;
    
    
}

-(void)dealloc {
	
	[self setServiceName:nil];
	
	
}


#pragma mark fields 

// serviceName
//NSString* _serviceName;
//@property (nonatomic, retain) NSString* serviceName;
@synthesize serviceName = _serviceName;

@end
