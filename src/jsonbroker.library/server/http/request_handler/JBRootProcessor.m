//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBHttpErrorHelper.h"
#import "JBLog.h"
#import "JBObjectTracker.h"
#import "JBRootProcessor.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBRootProcessor () 

// httpProcessors
//NSMutableArray* _httpProcessors;
@property (nonatomic, retain) NSMutableArray* httpProcessors;
//@synthesize httpProcessors = _httpProcessors;


// defaultProcessor
//id<HttpProcessor> _defaultProcessor;
@property (nonatomic, retain) id<JBRequestHandler> defaultProcessor;
//@synthesize defaultProcessor = _defaultProcessor;


@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBRootProcessor



-(void)addHttpProcessor:(id<JBRequestHandler>)httpProcessor {
    
    Log_debugString( [httpProcessor getProcessorUri] );
    
    [_httpProcessors addObject:httpProcessor];
    
    
}

#pragma mark <HttpProcessor> implementation


-(NSString*)getProcessorUri {
    return @"/";
}

-(JBHttpResponse*)processRequest:(JBHttpRequest*)request {
    
    NSString* requestUri = [request requestUri];
    for( id<JBRequestHandler> httpProcessor in _httpProcessors ) { 
        
        NSString* processorUri = [httpProcessor getProcessorUri];
        if( 0 == [requestUri rangeOfString:processorUri].location ) {
            return [httpProcessor processRequest:request];
        }
    }
    
    if( nil != _defaultProcessor ) { 
        return [_defaultProcessor processRequest:request];
    }
    
    Log_errorFormat( @"bad requestUri; requestUri = '%@'" , requestUri );
    @throw [JBHttpErrorHelper notFound404FromOriginator:self line:__LINE__];
}


#pragma mark instance lifecycle 

-(id)init { 
    
    JBRootProcessor* answer = [super init];
    
    if( nil != answer ) { 
        answer->_httpProcessors = [[NSMutableArray alloc] init];
        [answer setDefaultProcessor:nil]; // just to be explicit
    }
    
    return answer;
    
}


-(id)initWithDefaultProcessor:(id<JBRequestHandler>)defaultProcessor { 
    
    JBRootProcessor* answer = [super init];
    
    if( nil != answer ) { 
        answer->_httpProcessors = [[NSMutableArray alloc] init];
        [answer setDefaultProcessor:defaultProcessor];
    }
    
    return answer;

}

-(void)dealloc {
    
    [JBObjectTracker deallocated:self];
    [self setHttpProcessors:nil];
    [self setDefaultProcessor:nil];
    
    [super dealloc];
}

#pragma mark fields

// httpProcessors
//NSMutableArray* _httpProcessors;
//@property (nonatomic, retain) NSMutableArray* httpProcessors;
@synthesize httpProcessors = _httpProcessors;

// defaultProcessor
//id<HttpProcessor> _defaultProcessor;
//@property (nonatomic, retain) id<HttpProcessor> defaultProcessor;
@synthesize defaultProcessor = _defaultProcessor;



@end
