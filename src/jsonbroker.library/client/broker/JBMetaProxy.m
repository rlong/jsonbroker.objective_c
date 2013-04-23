// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBBrokerMessage.h"
#import "JBMetaProxy.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBMetaProxy () 

// service
//id<Service> _service;
@property (nonatomic, retain) id<JBService> service;
//@synthesize service = _service;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation JBMetaProxy


-(NSArray*)getVersion:(NSString*)serviceName {
    
    JBBrokerMessage* metaRequest = [JBBrokerMessage buildMetaRequestWithServiceName:serviceName methodName:@"getVersion"];
    JBBrokerMessage* metaResponse = [_service process:metaRequest];
    
    JBJsonObject* associativeParamaters = [metaResponse associativeParamaters];
    bool exists = [associativeParamaters boolForKey:@"exists"];
    
    if( !exists ) { 
        return nil;
    } else {
        int majorVersion = [associativeParamaters intForKey:@"majorVersion"];
        int minorVersion = [associativeParamaters intForKey:@"minorVersion"];
        
        NSArray* answer = [NSArray arrayWithObjects:[NSNumber numberWithInt:majorVersion], [NSNumber numberWithInt:minorVersion], nil];
        return answer;
    }
    
}

#pragma mark instance lifecycle

-(id)initWithService:(id<JBService>)service {
    
    JBMetaProxy* answer = [super init];
    
    
    if( nil != answer ) {
        
        [answer setService:service];
    
    }
    
    return answer;
    
    
}

-(void)dealloc {
	
	[self setService:nil];
	
	[super dealloc];
	
}


#pragma mark fields

// service
//id<Service> _service;
//@property (nonatomic, retain) id<Service> service;
@synthesize service = _service;

@end
