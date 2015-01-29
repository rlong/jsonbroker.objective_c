
//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBEchoWebSocket.h"
#import "JBLog.h"
#import "JBMemoryModel.h"
#import "JBTextWebSocket.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBEchoWebSocket ()

// echoWebSocket
//JBTextWebSocket* _echoWebSocket;
@property (nonatomic, retain) JBTextWebSocket* echoWebSocket;
//@synthesize echoWebSocket = _echoWebSocket;

// socket
//JBFileHandle* _socket;
@property (nonatomic, retain) JBFileHandle* socket;
//@synthesize socket = _socket;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation JBEchoWebSocket

// can return a `nil` which indicates processing on the socket should stop
-(id<JBConnectionDelegate>)processRequestOnSocket:(JBFileHandle*)socket inputStream:(NSInputStream*)inputStream outputStream:(NSOutputStream*)outputStream {
    
    
    if( socket != _socket ) {
        [self setSocket:socket];
        [self setEchoWebSocket:nil];
        _echoWebSocket = [[JBTextWebSocket alloc] initWithSocket:socket inputStream:inputStream outputStream:outputStream];
    }
    
    NSString* line = [_echoWebSocket recieveTextFrame];
    Log_debugString( line );

    if( nil == line ) {
        return nil;
    }

    [_echoWebSocket sendTextFrame:line];
    
    return self;
    
}


#pragma mark -
#pragma mark instance lifecycle

-(id)init {
    
    JBEchoWebSocket* answer = [super init];
    
    if( nil != answer ) {
        answer->_echoWebSocket = nil; // just to be explicit
        answer->_socket = nil; // just to be explicit
    }
    
    return answer;
    
}

-(void)dealloc {
    
    [self setEchoWebSocket:nil];
    [self setSocket:nil];

    
    JBSuperDealloc();
    
}

#pragma mark -
#pragma mark fields

// echoWebSocket
//JBTextWebSocket* _echoWebSocket;
//@property (nonatomic, retain) JBTextWebSocket* echoWebSocket;
@synthesize echoWebSocket = _echoWebSocket;


// socket
//JBFileHandle* _socket;
//@property (nonatomic, retain) JBFileHandle* socket;
@synthesize socket = _socket;


@end
