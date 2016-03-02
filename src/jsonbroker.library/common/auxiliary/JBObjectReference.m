// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBObjectReference.h"


@implementation JBObjectReference


#pragma mark -
#pragma mark instance lifecycle 

-(id)initWithObject:(NSObject*)object {
	
	JBObjectReference* answer = [super init];
	
	answer->_object = object;
	
	return answer;
	
}

-(void)dealloc {
	
	
}

#pragma mark -
#pragma mark fields

//NSObject* _object;
//@property (nonatomic, assign) NSObject* object;
@synthesize object = _object;

@end
