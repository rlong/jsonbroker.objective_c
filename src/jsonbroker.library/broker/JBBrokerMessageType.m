// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBaseException.h"
#import "JBBrokerMessageType.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBBrokerMessageType () 

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithIdentifer:(NSString*)identifer;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBBrokerMessageType


static JBBrokerMessageType* _fault = nil; 

static JBBrokerMessageType* _metaRequest = nil;

static JBBrokerMessageType* _metaResponse = nil;

static JBBrokerMessageType* _notification = nil;

static JBBrokerMessageType* _oneway = nil; 

static JBBrokerMessageType* _request = nil; 

static JBBrokerMessageType* _response = nil; 



+(void)initialize {
	
	_fault = [[JBBrokerMessageType alloc] initWithIdentifer:@"fault"];
    _metaRequest = [[JBBrokerMessageType alloc] initWithIdentifer:@"meta-request"];
    _metaResponse = [[JBBrokerMessageType alloc] initWithIdentifer:@"meta-response"];
	_notification = [[JBBrokerMessageType alloc] initWithIdentifer:@"notification"];	
	_oneway = [[JBBrokerMessageType alloc] initWithIdentifer:@"oneway"];
	_request = [[JBBrokerMessageType alloc] initWithIdentifer:@"request"];
	_response = [[JBBrokerMessageType alloc] initWithIdentifer:@"response"];
	
}




+(JBBrokerMessageType*)fault {
	return _fault;
}

+(JBBrokerMessageType*)metaRequest {
	return _metaRequest;
}

+(JBBrokerMessageType*)metaResponse {
	return _metaResponse;
}

+(JBBrokerMessageType*)notification {
	return _notification;
}

+(JBBrokerMessageType*)oneway {
	return _oneway;
}

+(JBBrokerMessageType*)request {
	return _request;
}


+(JBBrokerMessageType*)response {
	return _response;
}

+(JBBrokerMessageType*)lookup:(NSString*)identifier {
	
	if( [[_fault identifier] isEqualToString:identifier] ) {
		return _fault;
	}

    if( [[_metaRequest identifier] isEqualToString:identifier] ) {
		return _metaRequest;
	}

    if( [[_metaResponse identifier] isEqualToString:identifier] ) {
		return _metaResponse;
	}

	if( [[_notification identifier] isEqualToString:identifier] ) {
		return _notification;
	}
	
	if( [[_oneway identifier] isEqualToString:identifier] ) {
		return _oneway;
	}
	
	if( [[_request identifier] isEqualToString:identifier] ) {
		return _request;
	}

	if( [[_response identifier] isEqualToString:identifier] ) {
		return _response;
	}
	
	NSString*  technicalError = [NSString stringWithFormat:@"unexpected identifier; identifier =  '%@'", identifier];
	BaseException* e = [[BaseException alloc] initWithOriginator:[JBBrokerMessageType class] line:__LINE__ faultMessage:technicalError];
	[e autorelease];
	
	@throw e;
	
}


#pragma mark -
#pragma mark instance lifecycle

-(id)initWithIdentifer:(NSString*)identifer {
	
	JBBrokerMessageType* answer = [super init];
	
	[answer setIdentifier:identifer];
	
	return answer;
	
}


#pragma mark -
#pragma mark fields


//NSString* _identifier;
//@property (nonatomic, retain) NSString* identifier;
@synthesize identifier = _identifier;


@end
