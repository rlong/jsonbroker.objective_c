// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import <Foundation/Foundation.h>

@interface JBFolderUtilities : NSObject

+(BOOL)directoryExistsAtPath:(NSString*)path;

+(NSString*)getApplicationSupportDirectory;
+(NSString*)getCachesDirectory;
+(NSString*)getDocumentDirectory;
+(NSString*)getLibraryDirectory;

+(void)mkdirs:(NSString*)pathname;

@end
