//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBWorkQueue.h"

@interface JBWorker : NSObject {
    
    NSString* _name;
	//@property (nonatomic, retain) NSString* name;
	//@synthesize name = _name;
	
	JBWorkQueue* _workQueue;
	//@property (nonatomic, retain) WorkQueue* workQueue;
	//@synthesize workQueue = _workQueue;

}


-(void)start;

#pragma mark instance lifecycle

-(id)initWithName:(NSString*)name workQueue:(JBWorkQueue*)queue;

@end
