// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@interface JBStringHelper : NSObject


+(NSString*)trim:(NSString*)input;

// DEPRECATED: use [DataHelper toUtf8String]
+(NSString*)getUtf8String:(NSData*)data;

+(NSData*)toUtf8Data:(NSString*)input;
+(NSMutableData*)toUtf8MutableData:(NSString*)input;


// as per javascript
+(NSString*)decodeURIComponent:(NSString*)encodedURIComponent;

//
//// as per javascript
//+(NSString*)encodeURIComponent:(NSString*)decodedURIComponent;

+(NSString*)escapeString:(NSString*)input;

+(NSString*)toHexString:(UInt8[16])bytes;
+(NSString*)toHexString:(UInt8*)bytes count:(int)count;



// replace the likes of "&#39;" with "'" (e.g. playlist.osx.vlc-1.1.12.xml)
+(NSString*)unescapeHtmlCodes:(NSString*)input;

@end
