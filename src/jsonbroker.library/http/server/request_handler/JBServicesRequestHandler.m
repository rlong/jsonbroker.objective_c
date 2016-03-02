//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBBrokerMessageType.h"
#import "JBDataEntity.h"
#import "JBDataHelper.h"
#import "JBDefaults.h"
#import "JBHttpErrorHelper.h"
#import "JBHttpRequest.h"
#import "JBHttpResponse.h"
#import "JBJsonArrayHelper.h"
#import "JBLog.h"
#import "JBSerializer.h"
#import "JBServicesRequestHandler.h"




////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBServicesRequestHandler () 

// servicesRegistery
//ServicesRegistery* _servicesRegistery;
@property (nonatomic, retain) JBServicesRegistery* servicesRegistery;
//@synthesize servicesRegistery = _servicesRegistery;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBServicesRequestHandler


static int _MAXIMUM_REQUEST_ENTITY_LENGTH;

+(void)initialize {
    
    
    JBDefaults* defaults = [JBDefaults getDefaultsForScope:@"vlc_amigo.ServicesRequestHandler"];

    _MAXIMUM_REQUEST_ENTITY_LENGTH = [defaults intWithName:@"_MAXIMUM_REQUEST_ENTITY_LENGTH" defaultValue:32 * 1024];
    Log_debugInt( _MAXIMUM_REQUEST_ENTITY_LENGTH );
    
}


-(void)addService:(id<JBDescribedService>)service {
    
    Log_debugString( [[service serviceDescription] serviceName] );
    
    [_servicesRegistery addService:service];
    
}

#pragma mark -
#pragma mark <JBRequestHandler> implementation



+(JBBrokerMessage*)processBrokerRequest:(JBBrokerMessage*)request  withServiceRegistery:(JBServicesRegistery*)servicesRegistery {
    
    @try {
        
        return [servicesRegistery process:request];
        
    }
    @catch (NSException *exception) {
        Log_errorException( exception );
        return [JBBrokerMessage buildFault:request exception:exception];
    }
}


+(JBHttpResponse*)processPostRequest:(JBHttpRequest*)request withServiceRegistery:(JBServicesRegistery*)servicesRegistery {
    
    if( [JBHttpMethod POST] != [request method] ) {
        Log_errorFormat( @"unsupported method; [[request method] name] = '%@'", [[request method] name]);
        @throw [JBHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
    }
    
    id<JBEntity> entity = [request entity];
    
    
    
    if( _MAXIMUM_REQUEST_ENTITY_LENGTH < [entity getContentLength] ) {
        Log_errorFormat( @"_MAXIMUM_REQUEST_ENTITY_LENGTH < [entity getContentLength]; _MAXIMUM_REQUEST_ENTITY_LENGTH = %d; [entity getContentLength] = %d", _MAXIMUM_REQUEST_ENTITY_LENGTH, [entity getContentLength]);
        @throw  [JBHttpErrorHelper requestEntityTooLarge413FromOriginator:self line:__LINE__];
    }
    
    NSData* data = [JBDataHelper fromEntity:entity];
    
    
    JBBrokerMessage* call = [JBSerializer deserialize:data];
    JBBrokerMessage* response = [self processBrokerRequest:call withServiceRegistery:servicesRegistery];
    
    
    JBHttpResponse* answer;
    {
        if( [JBBrokerMessageType oneway] == [call messageType] ) {
            
            answer = [[JBHttpResponse alloc] initWithStatus:HttpStatus_NO_CONTENT_204];
            
        } else {
        
            JBJsonArray* responseComponents = [response toJsonArray];
            NSData* responseData = [JBJsonArrayHelper toData:responseComponents];
            
            
            id<JBEntity> responseBody = [[JBDataEntity alloc] initWithData:responseData];
            
            answer = [[JBHttpResponse alloc] initWithStatus:HttpStatus_OK_200 entity:responseBody];
        }
    }

    return answer;
}



-(JBHttpResponse*)processRequest:(JBHttpRequest*)request {
    
    return [JBServicesRequestHandler processPostRequest:request withServiceRegistery:_servicesRegistery];
    
}

-(NSString*)getProcessorUri {
    return @"/services";
    
}


#pragma mark -
#pragma mark instance lifecycle 



-(id)init {

    JBServicesRequestHandler* answer = [super init];
    
    if( nil != answer ) {
        answer->_servicesRegistery = [[JBServicesRegistery alloc] init];
    }
    
    return answer;

}


-(id)initWithServicesRegistery:(JBServicesRegistery*)servicesRegistery {
    
    
    JBServicesRequestHandler* answer = [super init];

    if( nil != answer ) {
        [answer setServicesRegistery:servicesRegistery];
    }
    
    
    return answer;
    
}

-(void)dealloc {
	
    [self setServicesRegistery:nil];
	
	
}


#pragma mark fields


// servicesRegistery
//ServicesRegistery* _servicesRegistery;
//@property (nonatomic, retain) ServicesRegistery* servicesRegistery;
@synthesize servicesRegistery = _servicesRegistery;



@end
