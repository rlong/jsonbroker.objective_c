//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


@interface JBHttpRequestReader : NSObject {

}

+(JBHttpRequest*)readRequest:(NSInputStream*)inputStream;



@end
