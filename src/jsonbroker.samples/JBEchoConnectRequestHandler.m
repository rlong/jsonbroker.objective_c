//  Copyright (c) 2015 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import "JBEchoConnectRequestHandler.h"
#import "JBEchoWebSocket.h"
#import "JBHttpErrorHelper.h"
#import "JBHttpRequest.h"
#import "JBHttpResponse.h"
#import "JBHttpStatus.h"
#import "JBLog.h"
#import "JBMemoryModel.h"
#import "JBWebSocketUtilities.h"


@implementation JBEchoConnectRequestHandler

-(NSString*)getProcessorUri {
    
    return @"/echo";
    
}

-(JBHttpResponse*)processRequest:(JBHttpRequest*)request {
    
    NSString* upgrade = [request getHttpHeader:@"upgrade"];
    Log_debugString( upgrade );
    
    if( nil == upgrade ) {
        Log_error( @"nil == upgrade" );
        @throw [JBHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
    }

    NSString* secWebSocketKey = [request getHttpHeader:@"sec-websocket-key"];
    Log_debugString( secWebSocketKey );
    
    if( nil == secWebSocketKey ) {
        Log_error( @"nil == secWebSocketKey" );
        @throw [JBHttpErrorHelper badRequest400FromOriginator:self line:__LINE__];
    }
    
    JBHttpResponse* answer = [[JBHttpResponse alloc] initWithStatus:HttpStatus_SWITCHING_PROTOCOLS_101];
    JBAutorelease( answer );
    
    NSString* secWebSocketAccept = [JBWebSocketUtilities buildSecWebSocketAccept:secWebSocketKey];
    
    [answer putHeader:@"Connection" value:@"Upgrade"];
    [answer putHeader:@"Sec-WebSocket-Accept" value:secWebSocketAccept];
    [answer putHeader:@"Upgrade" value:@"websocket"];
    
    {
        JBEchoWebSocket* connectionDelegate = [[JBEchoWebSocket alloc] init];
        {
        
            [answer setConnectionDelegate:connectionDelegate];
        }
        JBRelease( connectionDelegate );
        
    }

    return answer;
}

@end
