// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJsonHandler.h"
#import "JBJsonObject.h"


@interface JBJsonObjectHandler : JBJsonHandler {

}


+(JBJsonObjectHandler*)getInstance;


-(JBJsonObject*)readJSONObject:(JBJsonInput*)reader;

@end
