// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


@interface JBNumericUtilities : NSObject {

}

+(int)parseInteger:(NSString*)integerValue;
+(NSNumber*)parseIntegerObject:(NSString*)integerValue;

+(long)parseLong:(NSString*)longString;
+(NSNumber*)parseLongObject:(NSString*)longString;


+(double)parseDouble:(NSString*)doubleValue;

@end
