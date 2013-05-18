//
//  JBAbstractAdapter.m
//  jsonbroker
//
//  Created by rlong on 17/05/13.
//
//

#import "JBAbstractAdapter.h"
#import "JBLog.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBAbstractAdapter ()


// asyncTask
//AsyncTask _asyncTask;
@property (nonatomic, copy) AsyncTask asyncTask;
//@synthesize asyncTask = _asyncTask;

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

@implementation JBAbstractAdapter


#pragma mark -
#pragma mark instance lifecycle

-(id)initWithAsyncTask:(AsyncTask)asyncTask asyncTaskDone:(AsyncTaskDone)asyncTaskDone asyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed {
    
    
    JBAbstractAdapter* answer = [super init];
    
    if( nil != answer ) {
        [answer setAsyncTask:asyncTask];
        [answer setAsyncTaskDone:asyncTaskDone];
        [answer setAsyncTaskFailed:asyncTaskFailed];
    }
    
    return answer;
    
    
}


-(void)dealloc {
	
    [self setAsyncTask:nil];
    [self setAsyncTaskDone:nil];
	[self setAsyncTaskFailed:nil];
	
	[super dealloc];
	
}

#pragma mark -
#pragma mark fields

// asyncTask
//AsyncTask _asyncTask;
//@property (nonatomic, copy) AsyncTask asyncTask;
@synthesize asyncTask = _asyncTask;

// asyncTaskDone
//AsyncTaskDone _asyncTaskDone;
//@property (nonatomic, copy) AsyncTaskDone asyncTaskDone;
@synthesize asyncTaskDone = _asyncTaskDone;

// asyncTaskFailed
//AsyncTaskFailed _asyncTaskFailed;
//@property (nonatomic, copy) AsyncTaskFailed asyncTaskFailed;
@synthesize asyncTaskFailed = _asyncTaskFailed;

@end
