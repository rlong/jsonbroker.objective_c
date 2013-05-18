//
//  JBActionSheetBlockAdapter.m
//  jsonbroker
//
//  Created by rlong on 17/05/13.
//
//

#import "JBActionSheetBlockAdapter.h"
#import "JBBlockAdapterJob.h"
#import "JBWorkManager.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBActionSheetBlockAdapter ()

// client
//UIActionSheet* _client;
@property (nonatomic, retain) UIActionSheet* client;
//@synthesize client = _client;


// adaptee
//ActionSheetDelegate _adaptee;
@property (nonatomic, copy) ActionSheetDelegate adaptee;
//@synthesize adaptee = _adaptee;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBActionSheetBlockAdapter


+(JBActionSheetBlockAdapter*)adapterWithClient:(UIActionSheet *)client adaptee:(ActionSheetDelegate)adaptee {
    
    
    JBActionSheetBlockAdapter* answer = [[JBActionSheetBlockAdapter alloc] initWithClient:client adaptee:adaptee asyncTask:nil asyncTaskDone:nil asyncTaskFailed:nil];
    
    
    [answer autorelease];
    
    [client setDelegate:answer];
    
    return answer;
    
    
}


+(JBActionSheetBlockAdapter*)adapterWithClient:(UIActionSheet *)client adaptee:(ActionSheetDelegate)adaptee asyncTask:(AsyncTask)asyncTask afterAsyncTaskDone:(AsyncTaskDone)asyncTaskDone afterAsyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed {
    
    JBActionSheetBlockAdapter* answer = [[JBActionSheetBlockAdapter alloc] initWithClient:client adaptee:adaptee asyncTask:asyncTask asyncTaskDone:asyncTaskDone asyncTaskFailed:asyncTaskFailed];
    
    
    [answer autorelease];
    
    [client setDelegate:answer];
    
    return answer;
    
    
    
}

#pragma mark -
#pragma mark <UIActionSheetDelegate> implementation


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    id adapteeResponse = _adaptee( actionSheet, buttonIndex );
    
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



-(id)initWithClient:(UIActionSheet*)client adaptee:(ActionSheetDelegate)adaptee asyncTask:(AsyncTask)asyncTask asyncTaskDone:(AsyncTaskDone)asyncTaskDone asyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed {
    
    JBActionSheetBlockAdapter* answer = [super initWithAsyncTask:asyncTask asyncTaskDone:asyncTaskDone asyncTaskFailed:asyncTaskFailed];
    
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
//UIActionSheet* _client;
//@property (nonatomic, retain) UIActionSheet* client;
@synthesize client = _client;


// adaptee
//ActionSheetDelegate _adaptee;
//@property (nonatomic, copy) ActionSheetDelegate adaptee;
@synthesize adaptee = _adaptee;



@end
