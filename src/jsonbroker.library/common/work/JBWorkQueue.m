//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBWorkQueue.h"
#import "JBObjectTracker.h"

#import "JBLog.h"


#define NO_MESSAGES_PENDING 1
#define MESSAGES_PENDING 2


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBWorkQueue () 


//NSConditionLock* _inqueueLock;
@property (nonatomic, retain) NSConditionLock* inqueueLock;
//@synthesize inqueueLock = _inqueueLock;

//NSMutableArray* _inqueue;
@property (nonatomic, retain) NSMutableArray* inqueue;
//@synthesize inqueue = _inqueue;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@implementation JBWorkQueue


-(uint32_t)count {
    
    return (uint32_t)[_inqueue count];
}

-(void)enqueue:(id<JBJob>)request {
	
	[_inqueueLock lock];
	
	[_inqueue addObject:request];
	
	[_inqueueLock unlockWithCondition:MESSAGES_PENDING];
}

-(id<JBJob>)dequeue {
    
    
	[_inqueueLock lockWhenCondition:MESSAGES_PENDING];
	
	id<JBJob> answer = [_inqueue objectAtIndex:0];
	
	[_inqueue removeObjectAtIndex:0];
	
	if( 0 == [_inqueue count] ) { 
		
		[_inqueueLock unlockWithCondition:NO_MESSAGES_PENDING];
		
	} else {
		[_inqueueLock unlockWithCondition:MESSAGES_PENDING];
		
	}
	
	return answer;
}


#pragma mark instance lifecycle


-(id)init {
	JBWorkQueue* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	answer->_inqueueLock = [[NSConditionLock alloc] initWithCondition:NO_MESSAGES_PENDING]; 
	answer->_inqueue = [[NSMutableArray alloc] init];
	
	return answer;
}

-(void)dealloc {
	
	[JBObjectTracker deallocated:self];
	
	[self setInqueueLock:nil];
	[self setInqueue:nil];
	
}

#pragma mark fields

//NSConditionLock* _inqueueLock;
//@property (nonatomic, retain) NSConditionLock* inqueueLock;
@synthesize inqueueLock = _inqueueLock;

//NSMutableArray* _inqueue;
//@property (nonatomic, retain) NSMutableArray* inqueue;
@synthesize inqueue = _inqueue;


@end
