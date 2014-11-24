//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBJob.h"

@interface JBWorkQueue : NSObject {
    
    NSConditionLock* _inqueueLock;
	//@property (nonatomic, retain) NSConditionLock* inqueueLock;
	//@synthesize inqueueLock = _inqueueLock;
	
	NSMutableArray* _inqueue;
	//@property (nonatomic, retain) NSMutableArray* inqueue;
	//@synthesize inqueue = _inqueue;

}

-(uint32_t)count;
-(void)enqueue:(id<JBJob>)request;
-(id<JBJob>)dequeue;


@end
