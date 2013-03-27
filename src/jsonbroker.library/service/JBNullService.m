//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBaseException.h"
#import "JBLog.h"
#import "JBNullService.h"


@implementation JBNullService



-(JBBrokerMessage*)process:(JBBrokerMessage*)request {
	
	NSString* warning = [NSString stringWithFormat:@"unimplemented; serviceName = '%@'; methodName = '%@'", [request serviceName], [request methodName]];
    Log_warn( warning );
	
	return [JBBrokerMessage buildResponse:request];
	
}


#pragma mark instance lifecycle


-(id)initWithServiceName:(NSString*)serviceName { 
    
    JBNullService* answer = [super init];
    
    [answer setServiceName:serviceName];
    
    return answer;
    
}

-(void)dealloc {
    
    [self setServiceName:nil];
	
	[super dealloc];

}


#pragma mark fields


// serviceName
//NSString* _serviceName;
//@property (nonatomic, retain) NSString* serviceName;
@synthesize serviceName = _serviceName;




@end
