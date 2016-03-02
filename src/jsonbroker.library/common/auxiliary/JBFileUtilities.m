// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//




#import "JBBaseException.h"
#import "JBFileUtilities.h"
#import "JBLog.h"

@implementation JBFileUtilities


+(BOOL)fileExistsAtPath:(NSString*)path {

    NSFileManager* defaultManager = [NSFileManager defaultManager];
    return [defaultManager fileExistsAtPath:path];

}

+(BOOL)fileWithName:(NSString*)filename existsInFolder:(NSString*)folderPath {
    
    
    NSString* fullPath = [folderPath stringByAppendingPathComponent:filename];
    
    NSFileManager* defaultManager = [NSFileManager defaultManager];
    return [defaultManager fileExistsAtPath:fullPath];
    
}

+(unsigned long long)getFileLength:(NSString*)path {
    
    
    NSFileManager* defaultManager = [NSFileManager defaultManager];
    NSError* error = nil;
    NSDictionary* fileAttributes = [defaultManager attributesOfItemAtPath:path error:&error];
    
    if( nil != error ) {
        
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ callTo:@"[ NSFileManager attributesOfItemAtPath:error:]" failedWithError:error];
        @throw  e;
        
    }
    
    return [fileAttributes fileSize];
    
    
}


+(BOOL)isFile:(NSString *)srcPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL fileExists = [fileManager fileExistsAtPath:srcPath isDirectory:&isDirectory];
    
    if( !fileExists ) {
        return false;
    }
    
    if( isDirectory ) {
        return false;
    }
    
    return true;
}


+(void)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    
    NSError* error = nil;
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL success = [fileManager moveItemAtPath:srcPath toPath:dstPath error:&error];
    
    if( !success ) {
        
        NSString* technicalError = nil;
        if( nil != error ) {
            technicalError = [error localizedDescription];
        } else {
            technicalError = [NSString stringWithFormat:@"failed to moving '%@' to '%@'", srcPath, dstPath];
        }
        
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        
        if( nil != error )  {
            [e setError:error];
        }
        
        [e addStringContext:srcPath withName:@"srcPath"];
        [e addStringContext:dstPath withName:@"dstPath"];
        
        @throw  e;
        
        
        
    }
    
}


+(BOOL)removeFileWithPath:(NSString*)path swallowErrors:(BOOL)swallowErrors {
    
    NSFileManager* defaultManager = [NSFileManager defaultManager];
    
    if( [defaultManager fileExistsAtPath:path] ) {
        
        NSError* error = nil;
        
        [defaultManager removeItemAtPath:path error:&error];
        
        if( nil != error ) {
            
            if( swallowErrors ) {
                Log_warnError( error);
                return false;
                
            } else {
                
                JBBaseException* e = [JBBaseException baseExceptionWithOriginator:self line:__LINE__ callTo:@"[NSFileManager removeItemAtPath:error:]" failedWithError:error];
                [e addStringContext:path withName:@"path"];
                @throw  e;
            }
        }
    }
    
    return true;
    
}





+(void)writeContent:(NSString*)content toPath:(NSString*)path { 
    
    NSError* error = nil;
    
    
    BOOL success = [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if( !success ) {
        
        NSString* technicalError = nil;
        if( nil != error ) {
            
            technicalError = [error localizedDescription];
            
        } else {
            technicalError = [NSString stringWithFormat:@"failed to write to '%@'", path];
        }
        
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
        
        if( nil != error )  {
            [e setError:error];
        }
        
        [e addStringContext:path withName:@"path"];
        
        @throw  e;
        
    }
    
}






@end
