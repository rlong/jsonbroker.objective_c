//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBaseException.h"
#import "JBFileHandle.h"
#import "JBLog.h"
#import "JBObjectTracker.h"

@implementation JBFileHandle



-(void)close { 
    
    if( !_open ) { 
        return;
    }
    
    int closeResponse = close( _fileDescriptor);
    _open = false;
    
    if( -1 == closeResponse ) {
        BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ callTo:@"close" failedWithErrno:errno];
        @throw  e;
    }
    
}

#pragma mark instance lifecycle

-(id)initWithFileDescriptor:(int)fileDescriptor {
    
	JBFileHandle* answer = [super init];
    
	[JBObjectTracker allocated:answer];

    answer->_fileDescriptor = fileDescriptor;
    answer->_open = true;

	
	return answer;
}

-(void)dealloc {
	
	[JBObjectTracker deallocated:self];
    
    if( _open ) { 
        Log_warnFormat( @"_open; _fileDescriptor = %d", _fileDescriptor);
    }
	
}




#pragma mark fields



// fileDescriptor
//int _fileDescriptor;
//@property (nonatomic) int fileDescriptor;
@synthesize fileDescriptor = _fileDescriptor;

@end
