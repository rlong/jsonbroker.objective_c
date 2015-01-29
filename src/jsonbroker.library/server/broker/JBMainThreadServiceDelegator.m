//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBLog.h"
#import "JBObjectTracker.h"
#import "JBMainThreadServiceDelegator.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBMainThreadServiceDelegator () 



//NSException* _exception;
@property (nonatomic, retain) NSException* exception;
//@synthesize exception = _exception;

//BrokerMessage* _response;
@property (nonatomic, retain) JBBrokerMessage* response;
//@synthesize response = _response;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBMainThreadServiceDelegator


-(void)processInMainThread:(JBBrokerMessage*)request {
	
	
	@try {
		JBBrokerMessage* response = [_delegate process:request];
		[self setResponse:response];
	}
	@catch (NSException * e) {
		[self setException:e];
	}
}


#pragma mark <NamedService> implementation 

-(NSString*)serviceName {
    
    NSString* answer = [[_delegate serviceDescription] serviceName];

    return answer;
}

-(JBBrokerMessage*)process:(JBBrokerMessage*)request {
	
	Log_enteredMethod();
	
	[self setException:nil];
	[self setResponse:nil];
	
	[self performSelectorOnMainThread:@selector(processInMainThread:) withObject:request waitUntilDone:YES];
	
	if( nil != _exception ) {
		@throw _exception;
	}
	
	return _response;
	
}

#pragma mark instance lifecycle 

-(id)initWithDelegate:(id<JBMainThreadService>)delegate { 
	
	JBMainThreadServiceDelegator* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	[answer setDelegate:delegate];
	
	return answer;
	
	
}

-(void)dealloc { 
	
	[JBObjectTracker deallocated:self];
	
	[self setDelegate:nil];
	[self setException:nil];
	[self setResponse:nil];
	
	[super dealloc];
	
}
#pragma mark fields



//id<UserInterfaceService> _delegate;
//@property (nonatomic, retain) id<UserInterfaceService> delegate;
@synthesize delegate = _delegate;

//NSException* _exception;
//@property (nonatomic, retain) NSException* exception;
@synthesize exception = _exception;

//BrokerMessage* _response;
//@property (nonatomic, retain) BrokerMessage* response;
@synthesize response = _response;


@end
