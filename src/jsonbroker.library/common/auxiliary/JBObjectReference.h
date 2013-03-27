// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>


@interface JBObjectReference : NSObject {
	
	
	NSObject* _object;
	//@property (nonatomic, assign) NSObject* object;
	//@synthesize object = _object;
	

}


#pragma mark -
#pragma mark instance lifecycle 

-(id)initWithObject:(NSObject*)object;


#pragma mark -
#pragma mark fields

//NSObject* _object;
@property (nonatomic, assign) NSObject* object;
//@synthesize object = _object;

@end
