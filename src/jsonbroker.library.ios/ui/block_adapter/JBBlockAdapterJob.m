//
//  BlockAdapterJob.m
//  jsonbroker
//
//  Created by rlong on 17/05/13.
//
//

#import "JBBlockAdapterJob.h"
#import "JBLog.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBBlockAdapterJob ()


// adapteeResponse
//id _adapteeResponse;
@property (nonatomic, retain) id adapteeResponse;
//@synthesize adapteeResponse = _adapteeResponse;


// asyncTask
//AsyncTask _asyncTask;
@property (nonatomic, copy) AsyncTask asyncTask;
//@synthesize asyncTask = _asyncTask;

// asyncTaskResponse
//id _asyncTaskResponse;
@property (nonatomic, retain) id asyncTaskResponse;
//@synthesize asyncTaskResponse = _asyncTaskResponse;


// asyncTaskDone
//AsyncTaskDone _asyncTaskDone;
@property (nonatomic, copy) AsyncTaskDone asyncTaskDone;
//@synthesize asyncTaskDone = _asyncTaskDone;


// asyncTaskFailed
//AsyncTaskFailed _asyncTaskFailed;
@property (nonatomic, copy) AsyncTaskFailed asyncTaskFailed;
//@synthesize asyncTaskFailed = _asyncTaskFailed;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBBlockAdapterJob


#pragma mark -
#pragma mark <JBJob> implementation

-(void)execute {
    
    //Log_enteredMethod();
    
    
    if( nil == _asyncTask ) {
        Log_warn(@"nil == _asyncTask");
        return;
    }
    
    
    JBBaseException *exceptionCaught = nil;
    
    @try {
        
        id asyncTaskResponse = _asyncTask(_adapteeResponse);
        [self setAsyncTaskResponse:asyncTaskResponse];
    }
    @catch (JBBaseException *exception) {
        
        exceptionCaught = exception;
        
        if( nil != _asyncTaskFailed ) {
            
            // vvv http://stackoverflow.com/questions/7364169/how-to-dispatch-a-block-with-parameter-on-main-queue-or-thread
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                @try {
                    _asyncTaskFailed( _adapteeResponse, exception );
                }
                @catch (NSException *exception) {
                    Log_errorException( exception );
                }
                
            });
            
            // ^^^ http://stackoverflow.com/questions/7364169/how-to-dispatch-a-block-with-parameter-on-main-queue-or-thread
            
        } else {
            Log_errorException( exception );
        }
        
        // we are not 'done' so we return ...
        return;
        
    }
    
    if( nil == exceptionCaught ) { // if we completed the call to '_asyncAdaptee' successfully ...
        if( nil != _asyncTaskDone ) {
            
            // vvv http://stackoverflow.com/questions/7364169/how-to-dispatch-a-block-with-parameter-on-main-queue-or-thread
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                @try {
                    _asyncTaskDone( _adapteeResponse, _asyncTaskResponse);
                }
                @catch (NSException *exception) {
                    Log_errorException( exception );
                }
            });
            // ^^^ http://stackoverflow.com/questions/7364169/how-to-dispatch-a-block-with-parameter-on-main-queue-or-thread
            
        }
    }
}



#pragma mark -
#pragma mark instance lifecycle

-(id)initWithAdapteeResponse:(id)adapteeResponse asyncTask:(AsyncTask)asyncTask asyncTaskDone:(AsyncTaskDone)asyncTaskDone asyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed {
    
    
    JBBlockAdapterJob* answer = [super init];
    
    if( nil != answer ) {
        [answer setAdapteeResponse:adapteeResponse];
        [answer setAsyncTask:asyncTask];
        [answer setAsyncTaskDone:asyncTaskDone];
        [answer setAsyncTaskFailed:asyncTaskFailed];
    }
    
    return answer;
    
    
}


-(void)dealloc {
    
    Log_enteredMethod();
	
    [self setAdapteeResponse:nil];
    [self setAsyncTask:nil];
    [self setAsyncTaskResponse:nil];
    [self setAsyncTaskDone:nil];
	[self setAsyncTaskFailed:nil];
	
	[super dealloc];
	
}

#pragma mark -
#pragma mark fields


// adapteeResponse
//id _adapteeResponse;
//@property (nonatomic, retain) id adapteeResponse;
@synthesize adapteeResponse = _adapteeResponse;


// asyncTask
//AsyncTask _asyncTask;
//@property (nonatomic, copy) AsyncTask asyncTask;
@synthesize asyncTask = _asyncTask;


// asyncTaskResponse
//id _asyncTaskResponse;
//@property (nonatomic, retain) id asyncTaskResponse;
@synthesize asyncTaskResponse = _asyncTaskResponse;


// asyncTaskDone
//AsyncTaskDone _asyncTaskDone;
//@property (nonatomic, copy) AsyncTaskDone asyncTaskDone;
@synthesize asyncTaskDone = _asyncTaskDone;

// asyncTaskFailed
//AsyncTaskFailed _asyncTaskFailed;
//@property (nonatomic, copy) AsyncTaskFailed asyncTaskFailed;
@synthesize asyncTaskFailed = _asyncTaskFailed;


@end
