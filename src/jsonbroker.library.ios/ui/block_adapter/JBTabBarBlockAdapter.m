//
//  JBTabBarBlockAdapter.m
//  jsonbroker
//
//  Created by rlong on 17/05/13.
//
//

#import "JBBlockAdapterJob.h"
#import "JBLog.h"
#import "JBTabBarBlockAdapter.h"
#import "JBWorkManager.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBTabBarBlockAdapter ()

// client
//UITabBar* _client;
@property (nonatomic, retain) UITabBar* client;
//@synthesize client = _client;

// adaptee
//JBTabBarDelegate _adaptee;
@property (nonatomic, copy) JBTabBarDelegate adaptee;
//@synthesize adaptee = _adaptee;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation JBTabBarBlockAdapter


+(JBTabBarBlockAdapter*)adapterWithClient:(UITabBar *)client adaptee:(JBTabBarDelegate)adaptee {
    
    
    JBTabBarBlockAdapter* answer = [[JBTabBarBlockAdapter alloc] initWithClient:client adaptee:adaptee asyncTask:nil asyncTaskDone:nil asyncTaskFailed:nil];
    
    
    [answer autorelease];
    
    [client setDelegate:answer];
    
    return answer;
    
    
}


+(JBTabBarBlockAdapter*)adapterWithClient:(UITabBar *)client adaptee:(JBTabBarDelegate)adaptee asyncTask:(AsyncTask)asyncTask afterAsyncTaskDone:(AsyncTaskDone)asyncTaskDone afterAsyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed {
    
    JBTabBarBlockAdapter* answer = [[JBTabBarBlockAdapter alloc] initWithClient:client adaptee:adaptee asyncTask:asyncTask asyncTaskDone:asyncTaskDone asyncTaskFailed:asyncTaskFailed];
    
    [answer autorelease];
    
    [client setDelegate:answer];
    
    return answer;
    
}


#pragma mark - 
#pragma mark <UITabBarDelegate> implementation

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    Log_enteredMethod();
    
    id adapteeResponse = _adaptee( tabBar, item );
    
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

-(id)initWithClient:(UITabBar*)client adaptee:(JBTabBarDelegate)adaptee asyncTask:(AsyncTask)asyncTask asyncTaskDone:(AsyncTaskDone)asyncTaskDone asyncTaskFailed:(AsyncTaskFailed)asyncTaskFailed {
    
    JBTabBarBlockAdapter* answer = [super initWithAsyncTask:asyncTask asyncTaskDone:asyncTaskDone asyncTaskFailed:asyncTaskFailed];
    
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
//UITabBar* _client;
//@property (nonatomic, retain) UITabBar* client;
@synthesize client = _client;

// adaptee
//JBTabBarDelegate _adaptee;
//@property (nonatomic, copy) JBTabBarDelegate adaptee;
@synthesize adaptee = _adaptee;



@end
