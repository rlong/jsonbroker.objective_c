// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>

@interface JBFileUtilities : NSObject

+(BOOL)fileExistsAtPath:(NSString*)path;
+(BOOL)fileWithName:(NSString*)filename existsInFolder:(NSString*)folderPath;

+(unsigned long long)getFileLength:(NSString*)path;

+(BOOL)isFile:(NSString *)srcPath;
               
+(void)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;

+(BOOL)removeFileWithPath:(NSString*)path swallowErrors:(BOOL)swallowErrors;

+(void)writeContent:(NSString*)content toPath:(NSString*)path;





@end
