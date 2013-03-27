// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBJsonArray.h"
#import "JBJsonHandler.h"
#import "JBJsonDataInput.h"

@interface JBJsonArrayHandler : JBJsonHandler {

}


+(JBJsonArrayHandler*)getInstance;


-(JBJsonArray*)readJSONArray:(JBJsonDataInput*)reader;


@end
