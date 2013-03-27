// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

#import "JBEntity.h"


@protocol JBHttpResponseHandler <NSObject>

-(void)handleResponseHeaders:(NSDictionary*)headers responseEntity:(id<JBEntity>)responseEntity;

@end
