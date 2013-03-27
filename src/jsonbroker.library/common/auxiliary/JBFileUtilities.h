// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


@interface JBFileUtilities : NSObject


+(unsigned long long)getFileLength:(NSString*)path;


+(BOOL)isFile:(NSString *)srcPath;
               
+(void)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;

+(void)writeContent:(NSString*)content toPath:(NSString*)path;





@end
