//
//  JBButtonBlockAdapter.m
//  jsonbroker
//
//  Created by rlong on 16/05/13.
//
//

#import "JBBlockAdapterJob.h"
#import "JBButtonBlockAdapter.h"
#import "JBLog.h"
#import "JBWorkManager.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBButtonBlockAdapter ()


// client
//UIButton* _client;
@property (nonatomic, retain) UIButton* client;
//@synthesize client = _client;


// adaptee
//ButtonDelegate _adaptee;
@property (nonatomic, copy) ButtonDelegate adaptee;
//@synthesize adaptee = _adaptee;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation JBButtonBlockAdapter



#pragma mark -



-(void)adaptCall:(id)sender {

    id adapteeResponse = _adaptee( _client );

    if( nil != _asyncTask ) {
        
        JBBlockAdapterJob* job = [[JBBlockAdapterJob alloc] initWithAdapteeResponse:adapteeResponse asyncTask:_asyncTask asyncTaskDone:_asyncTaskDone asyncTaskFailed:_asyncTaskFailed];
        {
            [JBWorkManager enqueue:job];
        }
        [job release];
    }

}



+(JBButtonBlockAdapter*)onTouchUpInside:(UIButton*)button adaptee:(ButtonDelegate)adaptee {
    
    JBButtonBlockAdapter* answer = [[JBButtonBlockAdapter alloc] initWithClient:button adaptee:adaptee asyncTask:nil asyncTaskDone:nil asyncTaskFailed:nil];
    [answer autorelease];
    
    [button addTarget:answer action:@selector(adaptCall:) forControlEvents:UIControlEventTouchUpInside];
    
    return answer;
}

+(JBButtonBlockAdapter*)onTouchUpInside:(UIButton*)button adaptee:(ButtonDelegate)adaptee asyncTask:(AsyncTask)asyncTask afterAsyncTaskDone:(AsyncTaskDone)asyncTaskDone afterAsyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed {

    JBButtonBlockAdapter* answer = [[JBButtonBlockAdapter alloc] initWithClient:button
                                                                        adaptee:adaptee
                                                                      asyncTask:asyncTask
                                                                  asyncTaskDone:asyncTaskDone
                                                                asyncTaskFailed:asyncTaskFailed];
    [answer autorelease];
    
    
    [button addTarget:answer action:@selector(adaptCall:) forControlEvents:UIControlEventTouchUpInside];
    
    return answer;
    
    
    
}



#pragma mark -
#pragma mark instance lifecycle

-(id)initWithClient:(UIButton*)client adaptee:(ButtonDelegate)adaptee asyncTask:(AsyncTask)asyncTask asyncTaskDone:(AsyncTaskDone)asyncTaskDone asyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed {
    
    JBButtonBlockAdapter* answer = [super initWithAsyncTask:asyncTask asyncTaskDone:asyncTaskDone asyncTaskFailed:asyncTaskFailed];
    
    if( nil != answer ) {
        
        [answer setClient:client];
        [answer setAdaptee:adaptee];
        
    }
    
    return answer;
    
    
}


-(void)dealloc {
	
    Log_enteredMethod();

    [_client removeTarget:self action:@selector(callDelegate:) forControlEvents:UIControlEventTouchUpInside];
    [self setClient:nil];
    [self setAdaptee:nil];


	[super dealloc];
	
}


#pragma mark -
#pragma mark fields

// client
//UIButton* _client;
//@property (nonatomic, retain) UIButton* client;
@synthesize client = _client;

// adaptee
//ButtonDelegate _adaptee;
//@property (nonatomic, copy) ButtonDelegate adaptee;
@synthesize adaptee = _adaptee;


@end
