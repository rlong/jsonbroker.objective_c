// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBFolderUtilities.h"
#import "JBLog.h"

@implementation JBFolderUtilities



static NSString* _applicationSupportDirectory = nil;
static NSString* _cachesDirectory = nil;


+(BOOL)directoryExistsAtPath:(NSString*)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    
    BOOL fileExists = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
    
    if( !fileExists ) {
        return false;
    }
    
    return isDirectory;

    
}

+(NSString*)getApplicationSupportDirectory {
    
    if( nil != _applicationSupportDirectory ) {
        return _applicationSupportDirectory;
    }
    

    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    if( 0 == [paths count] ) {
        
        @throw  [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"0 == [paths count], searching for `NSApplicationSupportDirectory`"];
        
    } else if( 1 == [paths count] ) {
        _applicationSupportDirectory = [[paths objectAtIndex:0] retain];
    } else {
        Log_warnInt([paths count]);
        _applicationSupportDirectory = [[paths objectAtIndex:0] retain];
    }

    Log_debugString(_applicationSupportDirectory);
    return _applicationSupportDirectory;
    
}





+(NSString*)getCachesDirectory {
    
    if( nil != _cachesDirectory ) {
        return _cachesDirectory;
    }
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if( 0 == [paths count] ) {
        
        @throw  [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"0 == [paths count], searching for `NSCachesDirectory`"];
        
    } else if( 1 == [paths count] ) {
        _cachesDirectory = [[paths objectAtIndex:0] retain];
    } else {
        Log_warnInt([paths count]);
        _cachesDirectory = [[paths objectAtIndex:0] retain];
    }

    Log_debugString(_cachesDirectory);
    return _cachesDirectory;
    
}


+(void)mkdirs:(NSString*)pathname {
    
    NSError* error = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager createDirectoryAtPath:pathname withIntermediateDirectories:TRUE attributes:nil error:&error];
    
    if( nil != error ) {
        
        JBBaseException* e = [JBBaseException baseExceptionWithOriginator:self line:__LINE__ callTo:@"[NSFileManager createDirectoryAtPath:withIntermediateDirectories:attributes:error:]" failedWithError:error];
        [e addStringContext:pathname withName:@"pathname"];
        @throw e;
        
    }
    
    
}

@end
