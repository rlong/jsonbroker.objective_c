//
//  JBBarButtonItemBlockAdapter.m
//  jsonbroker
//
//  Created by rlong on 18/05/13.
//
//

#import "JBBarButtonItemBlockAdapter.h"
#import "JBBlockAdapterJob.h"
#import "JBWorkManager.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBBarButtonItemBlockAdapter ()

// client
//UIBarButtonItem* _client;
@property (nonatomic, retain) UIBarButtonItem* client;
//@synthesize client = _client;

// adaptee
//JBBarButtonItemDelegate _adaptee;
@property (nonatomic, copy) JBBarButtonItemDelegate adaptee;
//@synthesize adaptee = _adaptee;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBBarButtonItemBlockAdapter


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


+(JBBarButtonItemBlockAdapter*)adapterWithClient:(UIBarButtonItem*)client adaptee:(JBBarButtonItemDelegate)adaptee {
    
    JBBarButtonItemBlockAdapter* answer = [[JBBarButtonItemBlockAdapter alloc] initWithClient:client adaptee:adaptee asyncTask:nil asyncTaskDone:nil asyncTaskFailed:nil];
    [answer autorelease];
    
    [client setTarget:answer];
    [client setAction:@selector(adaptCall:)];
    
    return answer;
}

+(JBBarButtonItemBlockAdapter*)adapterWithClient:(UIBarButtonItem*)client adaptee:(JBBarButtonItemDelegate)adaptee asyncTask:(AsyncTask)asyncTask afterAsyncTaskDone:(AsyncTaskDone)asyncTaskDone afterAsyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed {
    
    JBBarButtonItemBlockAdapter* answer = [[JBBarButtonItemBlockAdapter alloc] initWithClient:client
                                                                        adaptee:adaptee
                                                                      asyncTask:asyncTask
                                                                  asyncTaskDone:asyncTaskDone
                                                                asyncTaskFailed:asyncTaskFailed];
    [answer autorelease];
    
    [client setTarget:answer];
    [client setAction:@selector(adaptCall:)];
    
    return answer;
    
}


#pragma mark -
#pragma mark instance lifecycle

-(id)initWithClient:(UIBarButtonItem*)client adaptee:(JBBarButtonItemDelegate)adaptee asyncTask:(AsyncTask)asyncTask asyncTaskDone:(AsyncTaskDone)asyncTaskDone asyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed {
    
    JBBarButtonItemBlockAdapter* answer = [super initWithAsyncTask:asyncTask asyncTaskDone:asyncTaskDone asyncTaskFailed:asyncTaskFailed];
    
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
//UIBarButtonItem* _client;
//@property (nonatomic, retain) UIBarButtonItem* client;
@synthesize client = _client;

// adaptee
//JBBarButtonItemDelegate _adaptee;
//@property (nonatomic, copy) JBBarButtonItemDelegate adaptee;
@synthesize adaptee = _adaptee;


@end
