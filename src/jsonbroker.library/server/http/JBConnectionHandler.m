//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#include <sys/socket.h> // `SOL_SOCKET`



#import "JBAuthRequestHandler.h"
#import "JBBaseException.h"
#import "JBConnectionHandler.h"
#import "JBConnectionDelegate.h"
#import "JBFileHandle.h"
#import "JBFileRequestHandler.h"
#import "JBHttpDelegate.h"
#import "JBHttpErrorHelper.h"
#import "JBHttpRequest.h"
#import "JBHttpRequestReader.h"
#import "JBHttpResponseWriter.h"
#import "JBHttpStatus.h"
#import "JBRequestHandler.h"
#import "JBLog.h"
#import "JBMemoryModel.h"
#import "JBObjectTracker.h"
#import "JBOpenRequestHandler.h"
#import "JBOutputStreamHelper.h"
#import "JBInputStreamHelper.h"
#import "JBStreamHelper.h"


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBConnectionHandler ()



// delegate
//id<JBConnectionDelegate> _delegate;
@property (nonatomic, retain) id<JBConnectionDelegate> delegate;
//@synthesize delegate = _delegate;


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




- (void)teardownTimerCallback;

#pragma mark instance setup/teardown

-(id)initWithSocket:(JBFileHandle*)socket httpProcessor:(id<JBRequestHandler>)requestHandler;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////




@implementation JBConnectionHandler

static int _connectionId = 1;




////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////



- (void)timerCallback:(NSTimer*)theTimer {
    

    @try {
        _delegate = [_delegate processRequestOnSocket:_socket inputStream:_inputStream outputStream:_outputStream];
    }
    @catch (NSException *exception) {
        Log_warnException(exception);
    }
    
    
    if( nil == _delegate ) {
        
        Log_debug( @"finishing" );
        
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


+(void)handleConnection:(JBFileHandle*)socket httpProcessor:(id<JBRequestHandler>)httpProcessor {
    
    JBConnectionHandler* connectionHandler = [[JBConnectionHandler alloc] initWithSocket:socket httpProcessor:httpProcessor];
    {
        [NSThread detachNewThreadSelector:@selector(run:) toTarget:connectionHandler withObject:nil];
    }
    [connectionHandler release];
    
}

#pragma mark -
#pragma mark instance setup/teardown


-(id)initWithSocket:(JBFileHandle*)socket httpProcessor:(id<JBRequestHandler>)requestHandler {
    
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
                
                [answer setInputStream:(NSInputStream*)readStream];
                [answer setOutputStream:(NSOutputStream*)writeStream];
                
                
            }
            CFRelease(readStream);
            CFRelease(writeStream);
            
            // ^^^ derived from [ReceiveServerController startReceive:] in sample project `SimpleNetworkStreams`
            

            // vvv derived from [iphone - CFNetwork HTTP timeout? - Stack Overflow](http://stackoverflow.com/questions/962076/cfnetwork-http-timeout)
            {
                
                // setup the `readStream` to never timeout on a read
                
#define _kCFStreamPropertyReadTimeout CFSTR("_kCFStreamPropertyReadTimeout")
                
                double to = 0; // never timeout
                CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberDoubleType, &to);
                CFReadStreamSetProperty(readStream, _kCFStreamPropertyReadTimeout, num);
                CFRelease(num);
                
            }
            // ^^^ derived from [iphone - CFNetwork HTTP timeout? - Stack Overflow](http://stackoverflow.com/questions/962076/cfnetwork-http-timeout)

            
            [answer->_inputStream open];
            [answer->_outputStream open];
            
        }
        
        
        {
            int postFlags = fcntl([socket fileDescriptor], F_GETFL, 0);
            if( preFlags != postFlags ) {
                Log_debugFormat( @"preFlags != postFlags; preFlags = %d; postFlags = %d; will reset O_NONBLOCK if it has been set", preFlags, postFlags);
                if( O_NONBLOCK == ( postFlags & O_NONBLOCK ) ) {
                    postFlags = fcntl([socket fileDescriptor], F_SETFL, postFlags & (~O_NONBLOCK));
                }
            }
            Log_debugInt(postFlags);
            
        }

        {
            socklen_t vslen = sizeof(struct timeval);
            struct timeval trcv;
            
            int32_t err = getsockopt( [socket fileDescriptor], SOL_SOCKET, SO_RCVTIMEO, &trcv, &vslen);
            if( 0 != err ) {
                Log_errorFormat( @"getsockopt() call failed; err = %d; errno = %d; strerror(errno) = '%s'", err, errno, strerror(errno) );
            } else {
                Log_debugFormat( @"trcv.tv_sec = %ld; trcv.tv_usec = %ld", trcv.tv_sec, trcv.tv_usec );
            }
            
        }

        answer->_delegate = [[JBHttpDelegate alloc] initWithRequestHandler:requestHandler];
    }
    
    
    return answer;
    
}

-(void)dealloc{
    
    [JBObjectTracker deallocated:self];
    
    [self setDelegate:nil];

    [self setSocket:nil];
    
    [self setInputStream:nil];
    [self setOutputStream:nil];
    
    [self setCallbackTimer:nil];
    
    JBSuperDealloc();
}

#pragma mark fields


// delegate
//id<JBConnectionDelegate> _delegate;
//@property (nonatomic, retain) id<JBConnectionDelegate> delegate;
@synthesize delegate = _delegate;


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





@end
