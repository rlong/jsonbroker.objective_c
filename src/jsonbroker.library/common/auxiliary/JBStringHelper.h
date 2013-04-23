// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


@interface JBStringHelper : NSObject


+(NSString*)trim:(NSString*)input;

// DEPRECATED: use [DataHelper toUtf8String]
+(NSString*)getUtf8String:(NSData*)data;

+(NSData*)toUtf8Data:(NSString*)input;
+(NSMutableData*)toUtf8MutableData:(NSString*)input;

// replace the likes of "&#39;" with "'" (e.g. playlist.osx.vlc-1.1.12.xml)
+(NSString*)unescapeHtmlCodes:(NSString*)input;


+(NSString*)escapeString:(NSString*)input;

+(NSString*)toHexString:(UInt8[16])bytes;


// as per javascript
+(NSString*)decodeURIComponent:(NSString*)encodedURIComponent;

@end
