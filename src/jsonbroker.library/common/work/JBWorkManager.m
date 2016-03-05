//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJob.h"
#import "JBJobListener.h"
#import "JBListenedJob.h"
#import "JBLog.h"
#import "JBWorkManager.h"
#import "JBWorker.h"
#import "JBWorkQueue.h"


#define NUM_WORKERS 5


@implementation JBWorkManager

static JBWorkQueue* _workQueue = nil;
static NSMutableArray* _workers = nil;


+(void)initialize {
	
	_workQueue = [[JBWorkQueue alloc] init];
    
	
}


+(void)start {
	
	Log_enteredMethod();
    
    if( nil != _workers ) {
        Log_warn( @"nil != _workers" );
        return;
    }
    
    _workers = [[NSMutableArray alloc] init];
    
	for( int i = 0; i < NUM_WORKERS; i++ ) {
		NSString* name = [NSString stringWithFormat:@"Worker.%d",i+1];
        
        JBWorker* worker = [[JBWorker alloc] initWithName:name workQueue:_workQueue];
        [worker start];
        [_workers addObject:worker];
	}
	
}

+(void)enqueue:(id<JBJob>)request {
	
    if( nil == _workers ) {
        Log_warn( @"nil == _workers" );
    }
    
    
	[_workQueue enqueue:request];
    
}

+(void)enqueue:(id<JBJob>)request listener:(id<JBJobListener>)listener {

    if( nil == _workers ) {
        Log_warn( @"nil == _workers" );
    }

    JBListenedJob* wrapper  = [[JBListenedJob alloc] initWithDelegate:request listener:listener];
    {
        [_workQueue enqueue:wrapper];
    }
    
}


@end

