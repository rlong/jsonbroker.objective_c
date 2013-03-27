//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBCorsServicesRequestHandler.h"
#import "JBDataEntity.h"
#import "JBDataHelper.h"
#import "JBHttpErrorHelper.h"
#import "JBLog.h"
#import "JBSerializer.h"
#import "JBServicesRequestHandler.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBCorsServicesRequestHandler ()

// servicesRegistery
//ServicesRegistery* _servicesRegistery;
@property (nonatomic, retain) JBServicesRegistery* servicesRegistery;
//@synthesize servicesRegistery = _servicesRegistery;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation JBCorsServicesRequestHandler



-(void)addService:(id<JBDescribedService>)service {
    
    [_servicesRegistery addService:service];
    
}

#pragma mark -
#pragma mark <JBRequestHandler> implementation




-(JBHttpResponse*)buildOptionsResponse:(JBHttpRequest*)request {
    
    JBHttpResponse* answer = [[JBHttpResponse alloc] initWithStatus:HttpStatus_NO_CONTENT_204];
    [answer autorelease];
    
    // vvv http://www.w3.org/TR/cors/#access-control-allow-methods-response-header
    [answer putHeader:@"Access-Control-Allow-Methods" value:@"OPTIONS, POST"];
    // ^^^ http://www.w3.org/TR/cors/#access-control-allow-methods-response-header
    
    NSString* accessControlAllowOrigin = [request getHttpHeader:@"origin"];
    if( nil == accessControlAllowOrigin ) {
        accessControlAllowOrigin = @"*";
    }
    
    [answer putHeader:@"Access-Control-Allow-Origin" value:accessControlAllowOrigin];
    
    NSString* accessControlRequestHeaders = [request getHttpHeader:@"access-control-request-headers"];
    if( nil != accessControlRequestHeaders ) {
        
        [answer putHeader:@"Access-Control-Allow-Headers" value:accessControlRequestHeaders];
    }
    
    return answer;
    
}

-(JBHttpResponse*)processRequest:(JBHttpRequest*)request {
    
    
    // vvv `chrome` (and possibly others) preflights any CORS requests
    if( [JBHttpMethod OPTIONS] == [request method] ) {
        return [self buildOptionsResponse:request];
    }
    // ^^^ `chrome` (and possibly others) preflights any CORS requests
    
    if( [JBHttpMethod POST] != [request method] ) {
        Log_errorFormat( @"unsupported method; [[request method] name] = '%@'", [[request method] name]);
        @throw [JBHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
    }
    
    JBHttpResponse* answer = [JBServicesRequestHandler processPostRequest:request withServiceRegistery:_servicesRegistery];
    
    // vvv without echoing back the 'origin' for CORS requests, chrome (and possibly others) complains "Origin http://localhost:8081 is not allowed by Access-Control-Allow-Origin."
    
    {
        NSString* origin = [request getHttpHeader:@"origin"];
        if( nil != origin ) {
            
            [answer putHeader:@"Access-Control-Allow-Origin" value:origin];
        }
    }
    
    // ^^^ without echoing back the 'origin' for CORS requests, chrome (and possibly others) complains "Origin http://localhost:8081 is not allowed by Access-Control-Allow-Origin."
    
    
    return answer;
    
}

-(NSString*)getProcessorUri {
    return @"/cors_services";
    
}


#pragma mark -
#pragma mark instance lifecycle



-(id)init {
    
    JBCorsServicesRequestHandler* answer = [super init];
    
    if( nil != answer ) {
        answer->_servicesRegistery = [[JBServicesRegistery alloc] init];
    }
    
    return answer;
    
}

-(id)initWithServicesRegistery:(JBServicesRegistery*)servicesRegistery {
    
    
    JBCorsServicesRequestHandler* answer = [super init];
    
    if( nil != answer ) {
        [answer setServicesRegistery:servicesRegistery];
    }
    
    
    return answer;
    
}

-(void)dealloc {
	
    [self setServicesRegistery:nil];
	
	[super dealloc];
	
}


#pragma mark fields


// servicesRegistery
//ServicesRegistery* _servicesRegistery;
//@property (nonatomic, retain) ServicesRegistery* servicesRegistery;
@synthesize servicesRegistery = _servicesRegistery;


@end
