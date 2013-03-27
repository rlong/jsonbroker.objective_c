//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//




@interface JBKeychainUtilities : NSObject {

}

+(void)dump;

// can return nil
+(NSString*)getSavedUsername;

// returns nil if no such user exists
+(NSString*)passwordForUsername:(NSString*)username service:(NSString*)service;

// returns whether the password was set successfully
+(BOOL)setPassword:(NSString*)password forUsername:(NSString*)username atService:(NSString*)service label:(NSString*)label throwExceptionOnFail:(BOOL)throwExceptionOnFail;

+(void)removePasswordForUsername:(NSString*)username atService:(NSString*)service;



@end
