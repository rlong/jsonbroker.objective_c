// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//




#import "JBClassHelper.h"


@implementation JBClassHelper {

}


+(NSString*)getClassName:(id)object {
    if( nil == object ) { 
        return @"NULL";
    }
    
    return NSStringFromClass( [object class] );
}


@end
