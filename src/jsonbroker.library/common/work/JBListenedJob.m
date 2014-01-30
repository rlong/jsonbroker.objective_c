//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"

#import "JBLog.h"
#import "JBListenedJob.h"
#import "JBMainThreadJob.h"
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

// exceptionCaughtDuringExecute
//BaseException* _exceptionCaughtDuringExecute;
@property (nonatomic, retain) BaseException* exceptionCaughtDuringExecute;
//@synthesize exceptionCaughtDuringExecute = _exceptionCaughtDuringExecute;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBListenedJob




-(void)callExecuteOnDelegate:(id)ignoredObject {
    
    @try {
        [_delegate execute];
    }
    @catch (JBBaseException *exception) {
        
        [self setExceptionCaughtDuringExecute:exception];
    }
    @catch (BaseException *exception) {
        
        [self setExceptionCaughtDuringExecute:exception];
    }
    
}

-(void)callJobCompletedOnListener:(id)ignoredObject {
    
    @try {
        
        if( [_listener conformsToProtocol:@protocol(JBMainThreadJobListener2)] ) {
            id<JBMainThreadJobListener2> mainThreadJobListener = (id<JBMainThreadJobListener2>)_listener;
            if( [mainThreadJobListener jobListenerIsRunning]) {
                [mainThreadJobListener jobCompleted:_delegate ];
            }
        } else {
            [_listener jobCompleted:_delegate];
        }

    }
    @catch (NSException *exception) {
        Log_errorException(exception);
    }
    
}

-(void)callJobFailedOnListener:(id)ignoredObject {
    
    @try {
        
        if( [_listener conformsToProtocol:@protocol(JBMainThreadJobListener2)] ) {
            id<JBMainThreadJobListener2> mainThreadJobListener = (id<JBMainThreadJobListener2>)_listener;
            if( [mainThreadJobListener jobListenerIsRunning]) {
                [mainThreadJobListener jobFailed:_delegate withException:_exceptionCaughtDuringExecute];
            } else {
                Log_warnException(_exceptionCaughtDuringExecute);
            }
        } else {
            [_listener jobFailed:_delegate withException:_exceptionCaughtDuringExecute];
        }
        
    }
    @catch (NSException *exception) {
        Log_errorException(exception);
    }
    
}


-(void)executeAllInMainThread:(id)ignoredObject {
    
    Log_enteredMethod();
    
    [self callExecuteOnDelegate:nil];
    
    //  make the callback to the listener
    if( nil == _exceptionCaughtDuringExecute ) {
        
        [self callJobCompletedOnListener:nil];
        
    } else {
        
        [self callJobFailedOnListener:nil];
        
    }
}




-(void)execute {
    
    // execute job and callback to listener in the main thread ?
    if( [_delegate conformsToProtocol:@protocol(JBMainThreadJob)] && [_listener conformsToProtocol:@protocol(JBMainThreadJobListener2)] ) {

        [self performSelectorOnMainThread:@selector(executeAllInMainThread:) withObject:nil waitUntilDone:NO];
        return;
    }

    // execute
    {
        if( [_delegate conformsToProtocol:@protocol(JBMainThreadJob)] ) {
            
            [self performSelectorOnMainThread:@selector(callExecuteOnDelegate:) withObject:nil waitUntilDone:YES];
            
        } else {
            
            [self callExecuteOnDelegate:nil];
        }
        
    }
    
    // callback
    {
        if( [_listener conformsToProtocol:@protocol(JBMainThreadJobListener2)] ) {
            
            if( nil == _exceptionCaughtDuringExecute ) {
                
                [self performSelectorOnMainThread:@selector(callJobCompletedOnListener:) withObject:nil waitUntilDone:YES];
                
            } else {

                [self performSelectorOnMainThread:@selector(callJobFailedOnListener:) withObject:nil waitUntilDone:YES];

            }
        
        } else {
            
            if( nil == _exceptionCaughtDuringExecute ) {
                
                [self callJobCompletedOnListener:nil];
                
            } else {
                
                [self callJobFailedOnListener:nil];
                
            }
            
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
	[self setExceptionCaughtDuringExecute:nil];

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

// exceptionCaughtDuringExecute
//BaseException* _exceptionCaughtDuringExecute;
//@property (nonatomic, retain) BaseException* exceptionCaughtDuringExecute;
@synthesize exceptionCaughtDuringExecute = _exceptionCaughtDuringExecute;


@end
