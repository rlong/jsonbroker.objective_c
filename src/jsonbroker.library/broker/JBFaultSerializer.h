// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBaseException.h"
#import "JBJsonObject.h"

@interface JBFaultSerializer : NSObject


+(JBJsonObject*)toJSONObject:(NSException*)exception;

+(JBBaseException*)toBaseException:(JBJsonObject*)jsonObject;

@end
