//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


@interface JBSecurityUtilities : NSObject {

}

+(NSString*)generateNonce;


+(NSString*)md5HashOfData:(NSData*)input;

+(NSString*)md5HashOfString:(NSString*)input;

+(NSString*)generateNumericUserPassword;

@end
