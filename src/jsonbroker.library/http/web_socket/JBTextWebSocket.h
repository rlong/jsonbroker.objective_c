//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <Foundation/Foundation.h>


@class JBFileHandle;




@interface JBTextWebSocket : NSObject {
    

    // inputStream
    NSInputStream* _inputStream;
    //@property (nonatomic, retain) NSInputStream* inputStream;
    //@synthesize inputStream = _inputStream;

    // outputStream
    NSOutputStream* _outputStream;
    //@property (nonatomic, retain) NSOutputStream* outputStream;
    //@synthesize outputStream = _outputStream;

    // socket
    JBFileHandle* _socket;
    //@property (nonatomic, retain) JBFileHandle* socket;
    //@synthesize socket = _socket;

}


-(NSString*)recieveTextFrame;

-(void)sendCloseFrame;

-(void)sendTextFrame:(NSString*)text;

#pragma mark -
#pragma mark instance lifecycle

-(id)initWithSocket:(JBFileHandle*)socket inputStream:(NSInputStream*)inputStream outputStream:(NSOutputStream*)outputStream;

@end
