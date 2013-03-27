//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBHttpResponse.h"

#import "JBFileHandle.h"

@interface JBHttpResponseWriter : NSObject {

}



+(void)writeResponse:(JBHttpResponse*)response outputStream:(NSOutputStream*)outputStream;

@end
