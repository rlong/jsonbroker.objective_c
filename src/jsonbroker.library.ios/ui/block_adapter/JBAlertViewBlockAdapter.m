//
//  JBAlertViewBlockAdapter.m
//  jsonbroker
//
//  Created by rlong on 16/05/13.
//
//

#import "JBAlertViewBlockAdapter.h"
#import "JBBlockAdapterJob.h"
#import "JBLog.h"
#import "JBWorkManager.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBAlertViewBlockAdapter ()

// client
//UIAlertView* _client;
@property (nonatomic, retain) UIAlertView* client;
//@synthesize client = _client;

// adaptee
//AlertViewDelegate _adaptee;
@property (nonatomic, copy) JBAlertViewDelegate adaptee;
//@synthesize adaptee = _adaptee;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBAlertViewBlockAdapter


+(JBAlertViewBlockAdapter*)adapterWithClient:(UIAlertView *)client adaptee:(JBAlertViewDelegate)adaptee {


    JBAlertViewBlockAdapter* answer = [[JBAlertViewBlockAdapter alloc] initWithClient:client adaptee:adaptee asyncTask:nil asyncTaskDone:nil asyncTaskFailed:nil];
    
    
    [answer autorelease];
    
    [client setDelegate:answer];
    
    return answer;

    
}


+(JBAlertViewBlockAdapter*)adapterWithClient:(UIAlertView *)client adaptee:(JBAlertViewDelegate)adaptee asyncTask:(AsyncTask)asyncTask afterAsyncTaskDone:(AsyncTaskDone)asyncTaskDone afterAsyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed {
    
    JBAlertViewBlockAdapter* answer = [[JBAlertViewBlockAdapter alloc] initWithClient:client adaptee:adaptee asyncTask:asyncTask asyncTaskDone:asyncTaskDone asyncTaskFailed:asyncTaskFailed];
    
    
    [answer autorelease];
    
    [client setDelegate:answer];
    
    return answer;
    
    
    
}


#pragma mark -
#pragma mark <UIAlertViewDelegate> implementation

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    Log_debugInt(buttonIndex);
    
    id adapteeResponse = _adaptee( alertView, buttonIndex );
    
    if( nil != _asyncTask ) {
        
        JBBlockAdapterJob* job = [[JBBlockAdapterJob alloc] initWithAdapteeResponse:adapteeResponse asyncTask:_asyncTask asyncTaskDone:_asyncTaskDone asyncTaskFailed:_asyncTaskFailed];
        {
            [JBWorkManager enqueue:job];
        }
        [job release];
    }
    
}


#pragma mark -
#pragma mark instance lifecycle


-(id)initWithClient:(UIAlertView*)client adaptee:(JBAlertViewDelegate)adaptee asyncTask:(AsyncTask)asyncTask asyncTaskDone:(AsyncTaskDone)asyncTaskDone asyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed {
    
    JBAlertViewBlockAdapter* answer = [super initWithAsyncTask:asyncTask asyncTaskDone:asyncTaskDone asyncTaskFailed:asyncTaskFailed];
    
    if( nil != answer ) {
        
        [answer setClient:client];
        [answer setAdaptee:adaptee];
    }
    
    return answer;
}


-(void)dealloc {
	
	[self setClient:nil];
    [self setAdaptee:nil];

	[super dealloc];
	
}



#pragma mark -
#pragma mark fields

// client
//UIAlertView* _client;
//@property (nonatomic, retain) UIAlertView* client;
@synthesize client = _client;

// adaptee
//AlertViewDelegate _adaptee;
//@property (nonatomic, copy) AlertViewDelegate adaptee;
@synthesize adaptee = _adaptee;

@end
