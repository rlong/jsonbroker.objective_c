//
//  JBTableViewBlockAdapter.m
//  jsonbroker
//
//  Created by rlong on 17/05/13.
//
//

#import "JBBlockAdapterJob.h"
#import "JBLog.h"
#import "JBTableViewBlockAdapter.h"
#import "JBWorkManager.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBTableViewBlockAdapter ()

// client
//UITableView* _client;
@property (nonatomic, retain) UITableView* client;
//@synthesize client = _client;

// adaptee
//JBTableViewDelegate _adaptee;
@property (nonatomic, copy) JBTableViewDelegate adaptee;
//@synthesize adaptee = _adaptee;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation JBTableViewBlockAdapter



+(JBTableViewBlockAdapter*)adapterWithClient:(UITableView *)client adaptee:(JBTableViewDelegate)adaptee {
    
    
    JBTableViewBlockAdapter* answer = [[JBTableViewBlockAdapter alloc] initWithClient:client adaptee:adaptee asyncTask:nil asyncTaskDone:nil asyncTaskFailed:nil];
    
    
    [answer autorelease];
    
    [client setDelegate:answer];
    
    return answer;
    
    
}


+(JBTableViewBlockAdapter*)adapterWithClient:(UITableView *)client adaptee:(JBTableViewDelegate)adaptee asyncTask:(AsyncTask)asyncTask afterAsyncTaskDone:(AsyncTaskDone)asyncTaskDone afterAsyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed {
    
    JBTableViewBlockAdapter* answer = [[JBTableViewBlockAdapter alloc] initWithClient:client adaptee:adaptee asyncTask:asyncTask asyncTaskDone:asyncTaskDone asyncTaskFailed:asyncTaskFailed];
    
    [answer autorelease];
    
    [client setDelegate:answer];
    
    return answer;
    
}

#pragma mark -
#pragma mark <UITableViewDelegate> implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Log_enteredMethod();
    
    id adapteeResponse = _adaptee( tableView, indexPath );
    
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


-(id)initWithClient:(UITableView*)client adaptee:(JBTableViewDelegate)adaptee asyncTask:(AsyncTask)asyncTask asyncTaskDone:(AsyncTaskDone)asyncTaskDone asyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed {
    
    JBTableViewBlockAdapter* answer = [super initWithAsyncTask:asyncTask asyncTaskDone:asyncTaskDone asyncTaskFailed:asyncTaskFailed];
    
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
//UITableView* _client;
//@property (nonatomic, retain) UITableView* client;
@synthesize client = _client;

// adaptee
//JBTableViewDelegate _adaptee;
//@property (nonatomic, copy) JBTableViewDelegate adaptee;
@synthesize adaptee = _adaptee;


@end
