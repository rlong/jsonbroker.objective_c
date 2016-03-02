//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBLog.h"
#import "JBMainThreadJob.h"
#import "JBObjectTracker.h"
#import "JBWorker.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBWorker () 

//NSString* _name;
@property (nonatomic, retain) NSString* name;
//@synthesize name = _name;

//WorkQueue* _workQueue;
@property (nonatomic, retain) JBWorkQueue* workQueue;
//@synthesize workQueue = _workQueue;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@implementation JBWorker


-(void)executeJob:(id<JBJob>)job {
    
    //Log_enteredMethod();
	
    @try {
        
        [job execute];
        
    }
    @catch (NSException* exception) {
        
        Log_errorException(exception);
        
    }
	
}


-(void)processJob:(NSTimer*)theTimer {
	
	id<JBJob> job = [_workQueue dequeue];
    
    if( [job conformsToProtocol:@protocol(JBMainThreadJob)] ) {
        
        [self performSelectorOnMainThread:@selector(executeJob:) withObject:job waitUntilDone:NO];
        
    } else {
        
        [self executeJob:job];
        
    }
	
}

-(void)main:(NSObject*)ignoredObject {
	
	
	Log_enteredMethod();
	
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	
	[[NSThread currentThread] setName:_name];
	
	Log_debug( @"Starting ... ");
	
	[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(processJob:) userInfo:nil repeats:YES];
	
	[[NSRunLoop currentRunLoop] run];
	
	Log_debug( @"... Finished" );
	
//	[pool release];
	
}


-(void)start {
	
	Log_enteredMethod();
	
	[NSThread detachNewThreadSelector:@selector(main:) toTarget:self withObject:nil];	
	
}


#pragma mark instance lifecycle



-(id)initWithName:(NSString*)name workQueue:(JBWorkQueue*)queue {
	
	JBWorker* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	[answer setName:name];
	[answer setWorkQueue:queue];
	
	return answer;
	
}


-(void)dealloc {
	
	[JBObjectTracker deallocated:self];
	
	[self setName:nil];
	[self setWorkQueue:nil];
	
}
#pragma mark fields

//NSString* _name;
//@property (nonatomic, retain) NSString* name;
@synthesize name = _name;

//WorkQueue* _workQueue;
//@property (nonatomic, retain) WorkQueue* workQueue;
@synthesize workQueue = _workQueue;

@end
