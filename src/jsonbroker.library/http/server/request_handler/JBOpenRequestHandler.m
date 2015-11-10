//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBLog.h"
#import "JBOpenRequestHandler.h"
#import "JBHttpErrorHelper.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBOpenRequestHandler () 


// processors
//NSMutableDictionary* _processors;
@property (nonatomic, retain) NSMutableDictionary* processors;
//@synthesize processors = _processors;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBOpenRequestHandler


static NSString* _REQUEST_URI = @"/_dynamic_/open"; 


+(NSString*)REQUEST_URI {
    return _REQUEST_URI;
}


static NSMutableDictionary* _processors; 

+(void)initialize {
	
    
    _processors = [[NSMutableDictionary alloc] init];
	
}


-(void)addRequestHandler:(id<JBRequestHandler>)processor {
    
    NSString* requestUri = [NSString stringWithFormat:@"%@%@", _REQUEST_URI, [processor getProcessorUri]];
    Log_debugString( requestUri );
    Log_infoFormat( @"'%@' -> '%@'", requestUri, NSStringFromClass( [processor class]) );
    
    [_processors setObject:processor forKey:requestUri];
    
}


-(id<JBRequestHandler>)getRequestHandler:(NSString*)requestUri {
    
    NSRange indexOfQuestionMark = [requestUri rangeOfString:@"?"];
    if( NSNotFound != indexOfQuestionMark.location ) { 
        
        requestUri = [requestUri substringToIndex:indexOfQuestionMark.location];
        Log_debugString( requestUri );
    }
    
    
    id<JBRequestHandler> answer = [_processors objectForKey:requestUri];
    
    return answer;
}


-(NSString*)getProcessorUri {
    return _REQUEST_URI;
}


-(JBHttpResponse*)processRequest:(JBHttpRequest*)request {
    
    NSString* requestUri = [request requestUri];
    
    NSRange rangeOfParameters = [requestUri rangeOfString:@"?"];
    if( NSNotFound != rangeOfParameters.location ) {
        requestUri = [requestUri substringToIndex:rangeOfParameters.location];
        Log_debugString( requestUri );
    }
    
    id<JBRequestHandler> processor = [self getRequestHandler:requestUri];
    
    if( nil ==  processor ) { 
        
        Log_errorFormat( @"nil ==  processor; requestUri = '%@'", requestUri );
        @throw [JBHttpErrorHelper notFound404FromOriginator:self line:__LINE__];
    }

    return [processor processRequest:request];

}


#pragma mark instance lifecycle

-(id)init { 
    
    JBOpenRequestHandler* answer = [super init];
    
    if( nil != answer ) { 
        
        answer->_processors = [[NSMutableDictionary alloc] init];
        
    }
    
    return answer;
    
}


-(void)dealloc {
	
	[self setProcessors:nil];
	
	[super dealloc];
	
}


#pragma mark fields

// processors
//NSMutableDictionary* _processors;
//@property (nonatomic, retain) NSMutableDictionary* processors;
@synthesize processors = _processors;


@end
