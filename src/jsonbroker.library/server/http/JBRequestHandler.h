//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

@class JBHttpRequest;
@class JBHttpResponse;

@protocol JBRequestHandler <NSObject>


-(NSString*)getProcessorUri;

-(JBHttpResponse*)processRequest:(JBHttpRequest*)request;


@end
