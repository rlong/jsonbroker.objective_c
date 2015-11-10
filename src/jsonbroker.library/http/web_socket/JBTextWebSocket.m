//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBDataHelper.h"
#import "JBFileHandle.h"
#import "JBFrame.h"
#import "JBInputStreamHelper.h"
#import "JBLog.h"
#import "JBMemoryModel.h"
#import "JBOutputStreamHelper.h"
#import "JBStreamHelper.h"
#import "JBStringHelper.h"
#import "JBTextWebSocket.h"



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBTextWebSocket ()

// inputStream
//NSInputStream* _inputStream;
@property (nonatomic, retain) NSInputStream* inputStream;
//@synthesize inputStream = _inputStream;


// outputStream
//NSOutputStream* _outputStream;
@property (nonatomic, retain) NSOutputStream* outputStream;
//@synthesize outputStream = _outputStream;


// socket
//JBFileHandle* _socket;
@property (nonatomic, retain) JBFileHandle* socket;
//@synthesize socket = _socket;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -


@implementation JBTextWebSocket


-(void)close {
    
    [_socket close];
    
    [JBStreamHelper closeStream:_inputStream swallowErrors:false caller:self];
    [JBStreamHelper closeStream:_outputStream swallowErrors:false caller:self];

    
}



-(NSMutableData*)recieveTextFrameBytes {
    
    
    
    
    JBFrame* frame = [JBFrame readFrame:_inputStream];
    if( nil == frame ) {
        return nil;
    }
    
    // browser is letting us know that it's closing the connection
    if( JBFrame_OPCODE_CONNECTION_CLOSE == [frame opCode] ) {
        
        // vvv http://tools.ietf.org/html/rfc6455#section-5.5.1
        
        [self sendCloseFrame];
        
        // ^^^ http://tools.ietf.org/html/rfc6455#section-5.5.1
        
        return nil;
    }


    NSMutableData* answer = [JBInputStreamHelper readMutableDataFromStream:_inputStream count:[frame payloadLength]];
    [frame applyMask:answer];

    return answer;
    
}

-(NSString*)recieveTextFrame {
 
    NSMutableData* textFrameBytes = [self recieveTextFrameBytes];
    
    if( nil == textFrameBytes ) {
        
        return nil;
    }
    
    NSString* answer = [JBDataHelper toUtf8String:textFrameBytes];
    return answer;

}

-(void)sendCloseFrame {
    
    Log_enteredMethod();
    JBFrame* frame = [[JBFrame alloc] initWithOpCode:JBFrame_OPCODE_CONNECTION_CLOSE payloadLength:0];
    JBAutorelease( frame );
    
    [frame writeTo:_outputStream];
    
}

-(void)sendTextFrame:(NSString*)text {
    
    
    NSData* utf8Data = [JBStringHelper toUtf8Data:text];
    uint32_t payloadLength = (uint32_t)[utf8Data length];

    JBFrame* frame = [[JBFrame alloc] initWithOpCode:JBFrame_OPCODE_TEXT_FRAME payloadLength:payloadLength];
    JBAutorelease( frame );
    
    [frame writeTo:_outputStream];
    [JBOutputStreamHelper writeTo:_outputStream buffer:[utf8Data bytes] bufferLength:[utf8Data length]];

    // TextWebSocket.sendTextFrame() in java sends a flush but there does not appear to be an API to flush an `NSOutputStream`
    
    
}

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithSocket:(JBFileHandle*)socket inputStream:(NSInputStream*)inputStream outputStream:(NSOutputStream*)outputStream {
    
    JBTextWebSocket* answer = [super init];
    
    if( nil != answer ) {
        
        [answer setInputStream:inputStream];
        [answer setOutputStream:outputStream];
        [answer setSocket:socket];
        
    }
    
    return answer;
    
    
}

-(void)dealloc {
    
    [self setInputStream:nil];
    [self setOutputStream:nil];
    [self setSocket:nil];
    
    JBSuperDealloc();
    
}


#pragma mark -
#pragma mark fields


// inputStream
//NSInputStream* _inputStream;
//@property (nonatomic, retain) NSInputStream* inputStream;
@synthesize inputStream = _inputStream;

// outputStream
//NSOutputStream* _outputStream;
//@property (nonatomic, retain) NSOutputStream* outputStream;
@synthesize outputStream = _outputStream;


// socket
//JBFileHandle* _socket;
//@property (nonatomic, retain) JBFileHandle* socket;
@synthesize socket = _socket;



@end
