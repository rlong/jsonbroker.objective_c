//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"

#import "JBListenedJob.h"
#import "JBMainThreadJobListener2.h"






////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBListenedJob ()


// delegate
//id<Job> _delegate;
@property (nonatomic, retain) id<JBJob> delegate;
//@synthesize delegate = _delegate;

// listener
//id<JobListener> _listener;
@property (nonatomic, retain) id<JBJobListener> listener;
//@synthesize listener = _listener;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBListenedJob


-(void)jobFailedWithException:(BaseException*)exception {
    
    
    id<JBMainThreadJobListener2> mainThreadJobListener = (id<JBMainThreadJobListener2>)_listener;
    
    if( [mainThreadJobListener jobListenerIsRunning] ) {
        [mainThreadJobListener jobFailed:_delegate withException:exception];
    }
    
    
}


-(void)jobCompleted:(id)ignoredObject {
    
    id<JBMainThreadJobListener2> mainThreadJobListener = (id<JBMainThreadJobListener2>)_listener;
    
    if( [mainThreadJobListener jobListenerIsRunning] ) {
        [mainThreadJobListener jobCompleted:_delegate];
    }

    
}

-(void)execute {
    
    @try {
        [_delegate execute];
        
        if( [_listener conformsToProtocol:@protocol(JBMainThreadJobListener2)] ) {
            [self performSelectorOnMainThread:@selector(jobCompleted:) withObject:nil waitUntilDone:NO];
        } else {
            [_listener jobCompleted:_delegate];
        }
    }
    @catch (JBBaseException *exception) {
        
        if( [_listener conformsToProtocol:@protocol(JBMainThreadJobListener2)] ) {
            [self performSelectorOnMainThread:@selector(jobFailedWithException:) withObject:exception waitUntilDone:NO];
        } else {
            [_listener jobFailed:_delegate withException:exception];
        }
        
    }
    @catch (BaseException *exception) {
        
        if( [_listener conformsToProtocol:@protocol(JBMainThreadJobListener2)] ) {
            [self performSelectorOnMainThread:@selector(jobFailedWithException:) withObject:exception waitUntilDone:NO];
        } else {
            [_listener jobFailed:_delegate withException:exception];
        }
    }
    
}




#pragma mark -
#pragma mark instance lifecycle


-(id)initWithDelegate:(id<JBJob>)delegate listener:(id<JBJobListener>)listener {
    
    JBListenedJob* answer = [super init];
    if( nil != answer ) {
        [answer setDelegate:delegate];
        [answer setListener:listener];
    }
    return answer;
    
}

-(void)dealloc {
	
    [self setDelegate:nil];
	[self setListener:nil];
	
	[super dealloc];
	
}



#pragma mark -
#pragma mark fields



// delegate
//id<Job> _delegate;
//@property (nonatomic, retain) id<Job> delegate;
@synthesize delegate = _delegate;

// listener
//id<JobListener> _listener;
//@property (nonatomic, retain) id<JobListener> listener;
@synthesize listener = _listener;



@end
