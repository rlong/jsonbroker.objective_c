//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBAuthProcessor.h"
#import "JBConnectionHandler.h"
#import "JBFileProcessor.h"
#import "JBHttpErrorHelper.h"
#import "JBHttpResponseWriter.h"

#import "JBBaseException.h"
#import "JBHttpRequest.h"
#import "JBHttpRequestReader.h"
#import "JBLog.h"
#import "JBObjectTracker.h"
#import "JBOpenRequestHandler.h"
#import "JBOutputStreamHelper.h"
#import "JBInputStreamHelper.h"
#import "JBStreamHelper.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBConnectionHandler () 


// socket
//JBFileDescriptor* _socket;
@property (nonatomic, retain) JBFileHandle* socket;
//@synthesize socket = _socket;


// inputStream
//NSInputStream* _inputStream;
@property (nonatomic, retain) NSInputStream* inputStream;
//@synthesize inputStream = _inputStream;



// outputStream
//NSOutputStream* _outputStream;
@property (nonatomic, retain) NSOutputStream* outputStream;
//@synthesize outputStream = _outputStream;


//NSTimer* _callbackTimer;
@property (nonatomic, retain) NSTimer* callbackTimer;
//@synthesize callbackTimer = _callbackTimer;


// httpProcessor
//id<HttpProcessor> _httpProcessor;
@property (nonatomic, retain) id<JBRequestHandler> httpProcessor;
//@synthesize httpProcessor = _httpProcessor;


- (void)teardownTimerCallback;

#pragma mark instance setup/teardown

-(id)initWithSocket:(JBFileHandle*)socket httpProcessor:(id<JBRequestHandler>)httpProcessor;

@end 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////



@implementation JBConnectionHandler

static int _connectionId = 1;



////////////////////////////////////////////////////////////////////////////

static NSMutableArray* _httpProcessors = nil; 

+(void)initialize {
	
	_httpProcessors = [[NSMutableArray alloc] init];
	
}

+(void)addHttpProcessor:(id<JBRequestHandler>)httpProcessor {
    
    [_httpProcessors addObject:httpProcessor];
    
}


////////////////////////////////////////////////////////////////////////////


-(JBHttpRequest*)readRequest {
    
    JBHttpRequest* answer = nil;
    
    @try {

        answer = [JBHttpRequestReader readRequest:_inputStream];

    }
    @catch (NSException *exception) {
        Log_warnException( exception );
    }
    
    return answer;
}




-(JBHttpResponse*)processRequest:(JBHttpRequest*)request {
    
    
    @try {
        return [_httpProcessor processRequest:request];
    }
    @catch (NSException *exception) {
        Log_warnException( exception );
        return [JBHttpErrorHelper toHttpResponse:exception];
    }
    
}

-(bool)writeResponse:(JBHttpResponse*)response {
    
    @try {
        // write the response ...
        [JBHttpResponseWriter writeResponse:response outputStream:_outputStream];
    }
    @catch (BaseException* exception) {
        
        if( [[JBStreamHelper ERROR_DOMAIN_BROKEN_PIPE] isEqualToString:[exception errorDomain]] ) {
#ifdef DEBUG
            Log_warn( @"broken pipe" );
#else
            // quietly swallow the 'broken pipe'
#endif
        } else {
            Log_warnException( exception );
        }
        return false;
    }
    @catch (NSException *exception) {
        Log_warnException( exception );
        return false;
    }
    
    return true;

}

+(void)logReqest:(JBHttpRequest*)request response:(JBHttpResponse*)response writeResponseSucceded:(bool)writeResponseSucceded{

    int statusCode = [response status];

    NSString* requestUri = [request requestUri];
    
    JBRange* range = [response range];
    
    long long contentLength = 0;
    if( nil != [response entity] ) {
        
        contentLength = [[response entity] getContentLength];
        if( nil != range ) {
            contentLength = [range getContentLength:contentLength];
        }
    }
    float timeTaken = -[[request created] timeIntervalSinceNow];
    
    NSString* completed;
    {
        if( writeResponseSucceded ) {
            completed = @"true";
        } else {
            completed = @"false";
        }
    }
    
    NSString* rangeString;
    {
        if( nil == range ) {
            rangeString = @"bytes";
            
        } else {
            rangeString = [range toContentRange:[[response entity] getContentLength]];
        }
    }
    
    NSString* info = [NSString stringWithFormat:@"status:%d uri:%@ content-length:%lld time-taken:%f completed:%@ range:%@", statusCode, requestUri, contentLength, timeTaken, completed, rangeString];
    Log_info( info );

}

-(bool)processRequest {

    // get the request ...
    JBHttpRequest* request = [self readRequest];
    
    if( nil == request )  {
        return false;
    }

    // process the request ... 
    JBHttpResponse* response = [self processRequest:request];
    
    
    bool continueProcessingRequests = true;
    
    // vvv http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.10
    if( [request isCloseConnectionIndicated] ) {
        continueProcessingRequests = false;
        
    }
    // ^^^ http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.10

    
    int statusCode = [response status];
    
    // close the connection on any non 2** response
    if( statusCode < 200 || statusCode > 299 ) {
        continueProcessingRequests = false;
    }

    if( continueProcessingRequests ) {
    
        [response putHeader:@"Connection" value:@"keep-alive"];
        
    } else {
    
        [response putHeader:@"Connection" value:@"close"];
    }
    
    // write the response ...
    bool writeResponseSucceded = [self writeResponse:response];
    
    // do some logging ...		
    [JBConnectionHandler logReqest:request response:response writeResponseSucceded:writeResponseSucceded];
    
    if (!writeResponseSucceded)
    {
        continueProcessingRequests = false;
    }

    // if the processing completed, we will permit more requests on this socket
    return continueProcessingRequests;

}



////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////



- (void)timerCallback:(NSTimer*)theTimer {

    
    bool terminate = true;
    @try {
        if( [self processRequest] ) { 
            terminate = false;
        }
    }
    @catch (NSException *exception) {
        Log_warnException(exception);
    }
    
    
    if( terminate ) {

        /////////////////////////////////////
        [self teardownTimerCallback];
        /////////////////////////////////////

        [_inputStream close];
        [_outputStream close];
        
        @try {
            
            [_socket close];
        }
        @catch (BaseException* exception) {
            Log_warnException( exception );
        }

    }
    
}


- (void)setupTimerCallback {
	
	NSTimer *callbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(timerCallback:) userInfo:nil repeats:YES];
	[self setCallbackTimer:callbackTimer];

}

- (void)teardownTimerCallback {
	
	[_callbackTimer invalidate];
	[self setCallbackTimer:nil];
	
}


-(void)run:(NSObject*)ignoredObject {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString* threadName = [NSString stringWithFormat:@"ConnectionHandler.%d.%d", _connectionId++, [_socket fileDescriptor]];
	[[NSThread currentThread] setName:threadName];
    
    {
        
        [self setupTimerCallback];
        [[NSRunLoop currentRunLoop] run];
        
    }
    [pool release];
}


+(void)handleConnection:(JBFileHandle*)fileDescriptor httpProcessor:(id<JBRequestHandler>)httpProcessor {
    
    JBConnectionHandler* connectionHandler = [[JBConnectionHandler alloc] initWithSocket:fileDescriptor httpProcessor:httpProcessor];
    {
        [NSThread detachNewThreadSelector:@selector(run:) toTarget:connectionHandler withObject:nil];
    }
	[connectionHandler release];

}


#pragma mark instance setup/teardown


-(id)initWithSocket:(JBFileHandle*)socket httpProcessor:(id<JBRequestHandler>)httpProcessor { 
    
    JBConnectionHandler* answer = [super init];
    
    if( nil != answer ) { 
        
        [JBObjectTracker allocated:answer];
        
        [answer setSocket:socket];
        
        
        int preFlags = fcntl([socket fileDescriptor], F_GETFL, 0);
        
        {
            // vvv derived from [ReceiveServerController startReceive:] in sample project `SimpleNetworkStreams`
            
            CFReadStreamRef readStream = NULL;
            CFWriteStreamRef writeStream = NULL;

            CFStreamCreatePairWithSocket(NULL, [socket fileDescriptor], &readStream, &writeStream);
            {
                assert(readStream != NULL);
                //assert(writeStream != NULL);
                
                [answer setInputStream:(NSInputStream*)readStream];
                //[answer setInputStream:(__bridge NSInputStream *) readStream]; // gives the warning '__bridge' casts have not effect when not using ARC
                [answer setOutputStream:(NSOutputStream*)writeStream];
                
    
            }
            CFRelease(readStream);
            CFRelease(writeStream);
            
            // ^^^ derived from [ReceiveServerController startReceive:] in sample project `SimpleNetworkStreams`
            
            [answer->_inputStream open];
            [answer->_outputStream open];

        }

        {
            int postFlags = fcntl([socket fileDescriptor], F_GETFL, 0);
            if( preFlags != postFlags ) {
                Log_warnFormat( @"preFlags != postFlags; preFlags = %d; postFlags = %d; will reset O_NONBLOCK if it has been set", preFlags, postFlags);
                if( O_NONBLOCK == ( postFlags & O_NONBLOCK ) ) {
                    postFlags = fcntl([socket fileDescriptor], F_SETFL, postFlags & (~O_NONBLOCK));
                }
            }
            Log_debugInt(postFlags);
            
        }

        [answer setHttpProcessor:httpProcessor];
    }

    
    return answer;
    
}

-(void)dealloc{ 
	
	[JBObjectTracker deallocated:self];
	
    [self setSocket:nil];
    
    [self setInputStream:nil];
    [self setOutputStream:nil];
	
	[self setCallbackTimer:nil];
    [self setHttpProcessor:nil];
	
	[super dealloc];
}

#pragma mark fields


// socket
//JBFileDescriptor* _socket;
//@property (nonatomic, retain) JBFileDescriptor* socket;
@synthesize socket = _socket;


// inputStream
//NSInputStream* _inputStream;
//@property (nonatomic, retain) NSInputStream* inputStream;
@synthesize inputStream = _inputStream;


// outputStream
//NSOutputStream* _outputStream;
//@property (nonatomic, retain) NSOutputStream* outputStream;
@synthesize outputStream = _outputStream;

//NSTimer* _callbackTimer;
//@property (nonatomic, retain) NSTimer* callbackTimer;
@synthesize callbackTimer = _callbackTimer;


// httpProcessor
//id<HttpProcessor> _httpProcessor;
//@property (nonatomic, retain) id<HttpProcessor> httpProcessor;
@synthesize httpProcessor = _httpProcessor;



@end
