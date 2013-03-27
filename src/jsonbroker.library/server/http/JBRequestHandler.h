//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBHttpRequest.h"
#import "JBHttpResponse.h"

@protocol JBRequestHandler <NSObject>


-(JBHttpResponse*)processRequest:(JBHttpRequest*)request;

-(NSString*)getProcessorUri;

@end
