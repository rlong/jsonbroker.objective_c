//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBaseException.h"
#import "JBLog.h"
#import "JBObjectTracker.h"
#import "JBServiceHelper.h"
#import "JBServicesRegistery.h"
#import "JBGuiServiceDelegator.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBServicesRegistery () 

//NSMutableDictionary* _services;
@property (nonatomic, retain) NSMutableDictionary* services;
//@synthesize services = _services;



@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBServicesRegistery




-(void)addUserInterfaceService:(id<JBGuiService>)service  {
    
    if( nil == service ) {
        Log_warnPointer( service  );
        return;
    }
    
    NSString* serviceName = [[service serviceDescription] serviceName];
    
    id<JBService> existingService = [_services objectForKey:serviceName];
    if( nil != existingService ) { 
        Log_warnString( serviceName );
        Log_warnPointer( existingService );
    }
    
    JBGuiServiceDelegator* userInterfaceService = [[JBGuiServiceDelegator alloc] initWithDelegate:service];
    
	[_services setObject:userInterfaceService forKey:serviceName];
	
	[userInterfaceService release];
    
}

-(void)addService:(id<JBDescribedService>)service {

    
    // vvv http://stackoverflow.com/questions/2344672/objective-c-given-a-class-id-can-i-check-if-this-class-implements-a-certain-p
    
    if( [[service class] conformsToProtocol:@protocol(JBGuiService)] ) 
        
        // ^^^ http://stackoverflow.com/questions/2344672/objective-c-given-a-class-id-can-i-check-if-this-class-implements-a-certain-p
    { 
        
        id<JBGuiService> userInterfaceService = (id<JBGuiService>)service;
        [self addUserInterfaceService:userInterfaceService];
        
    } else { 
        
        NSString* serviceName = [[service serviceDescription] serviceName];
        [_services setObject:service forKey:serviceName];
    }

}





-(bool)hasService:(NSString*)serviceName {

    id<JBService> answer = [_services objectForKey:serviceName];
    
	if( nil != answer ) { 
        return true;
    }
    return false;
}

-(id<JBService>)getService:(NSString*)serviceName {
	
	
	id<JBService> answer = [_services objectForKey:serviceName];
	if( nil == answer ) { 
        
        if( nil != _next ) { 
            return [_next getService:serviceName];
        }
        
		NSString* technicalError = [NSString stringWithFormat:@"null == answer, serviceName = '%@'", serviceName];
		
		BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        [e setErrorDomain:@"jsonbroker.ServicesRegistery.SERVICE_NOT_FOUND"];
		[e autorelease];
		@throw e;
							  
	}
	
	return answer;
	
}


-(void)removeService:(id<JBDescribedService>)serviceToRemove {
 
    Log_enteredMethod();
    
    if( nil == serviceToRemove ) {
        Log_warnPointer( serviceToRemove  );
        return;
    }

    NSString* serviceName = [[serviceToRemove serviceDescription] serviceName];
	
    id<JBService> service = [_services objectForKey:serviceName];

    if( nil == service ) { 
		
		NSString* warning = [NSString stringWithFormat:@"nil == service; serviceName = '%@'", serviceName];
        Log_warn( warning );
        return;
	}
    
    if( serviceToRemove != service ) { 
		NSString* warning = [NSString stringWithFormat:@"serviceToRemove != service; serviceName = '%@'; serviceToRemove = %p; service = %p", serviceName, serviceToRemove, service];
        Log_warn( warning );
        return;
        
    }
    
	[_services removeObjectForKey:serviceName];

}


-(JBBrokerMessage*)processMetaRequest:(JBBrokerMessage*)request {
    
    
    NSString* methodName = [request methodName];
    
    if( [@"getVersion" isEqualToString:methodName] ) { 
        
        NSString* serviceName = [request serviceName];
        
        JBBrokerMessage* answer = [JBBrokerMessage buildMetaResponse:request];
        JBJsonObject* associativeParamaters = [answer associativeParamaters];
        
        id<JBDescribedService> describedService = [_services objectForKey:serviceName];
        if( nil == describedService ) { 
            
            [associativeParamaters setBoolean:false forKey:@"exists"];
            
        } else {
            
            [associativeParamaters setBoolean:true forKey:@"exists"];
            JBServiceDescription* serviceDescription = [describedService serviceDescription];
            [associativeParamaters setInt:[serviceDescription majorVersion] forKey:@"majorVersion"];
            [associativeParamaters setInt:[serviceDescription minorVersion] forKey:@"minorVersion"];
            
        }
        
        return answer;
        
    }
    
    @throw [JBServiceHelper methodNotFound:self request:request];
    
}

#pragma mark <Service> implmentation 




-(JBBrokerMessage*)process:(JBBrokerMessage*)request {
    
    
    if( [JBBrokerMessageType metaRequest] == [request messageType] ) { 
        
        return [self processMetaRequest:request];
        
    }
    
    
    id<JBService> serviceDelegate = [self getService:[request serviceName]];
    return [serviceDelegate process:request];
    
}


#pragma mark instance lifecycle

-(id)init { 
	
	JBServicesRegistery* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	answer->_services = [[NSMutableDictionary alloc] init];
	 
	
	return answer;
}

// 'next' can be nil
-(id)initWithService:(id<JBDescribedService>)service next:(JBServicesRegistery*)next { 
    
    JBServicesRegistery* answer = [super init];
	
	[JBObjectTracker allocated:answer];
	
	answer->_services = [[NSMutableDictionary alloc] init];
    [answer addService:service];      
    [answer setNext:next];
    
	return answer;

}


-(void)dealloc {
	
	[JBObjectTracker deallocated:self];
	
	[self setServices:nil];
    [self setNext:nil];
	
	[super dealloc];
}

#pragma mark fields

//NSMutableDictionary* _services;
//@property (nonatomic, retain) NSMutableDictionary* services;
@synthesize services = _services;


#pragma mark fields


// next
//ServicesRegistery* _next;
//@property (nonatomic, retain) ServicesRegistery* next;
@synthesize next = _next;



@end