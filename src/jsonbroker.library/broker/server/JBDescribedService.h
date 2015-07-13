//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

#import "JBService.h"
#import "JBServiceDescription.h"

@protocol JBDescribedService <NSObject,JBService>

-(JBServiceDescription*)serviceDescription;

@end
