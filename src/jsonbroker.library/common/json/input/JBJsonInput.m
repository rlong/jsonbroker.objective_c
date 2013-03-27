// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBJsonInput.h"
#import "JBObjectTracker.h"


#define POOL_SIZE 5 

@implementation JBJsonInput


-(BOOL)hasNextByte {
    
    BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"unimplmeneted"];
    [e autorelease];
    @throw e;
    
}
-(UInt8)currentByte {
    BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"unimplmeneted"];
    [e autorelease];
    @throw e;

}

-(UInt8)nextByte {
    BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:@"unimplmeneted"];
    [e autorelease];
    @throw e;

}



-(BOOL)doesByteBeginToken:(UInt8)candidateByte { 
	
	if( ' ' == candidateByte ) { 
		return false;
	}
	
	if( '\n' == candidateByte) {
		return false;
	}
    
	if( '\r' == candidateByte) {
		return false;
	}
	
	
	if( ',' == candidateByte) {
		return false;
	}
	
	if( ':' == candidateByte) {
		return false;
	}
	
	
	return true;
	
}

-(UInt8)scanToNextToken { 
    
	UInt8 currentByte = [self currentByte];
	
	if( [self doesByteBeginToken:currentByte] ) {
		
		return currentByte;
		
	}
	
	do {
		currentByte = [self nextByte];
		
        
	} while( ![self doesByteBeginToken:currentByte] );
	
	
	return currentByte;
	
	
    
}


#pragma mark pool management



-(NSMutableData*)reserveMutableData {
	
	if( nil == _mutableDataPool ) {
		_mutableDataPool = calloc( POOL_SIZE, sizeof(NSMutableData*) );
	}
	
	if( _mutableDataPoolIndex >= POOL_SIZE ) { 
		
		// revert to disposable MutableData objects
		
		_mutableDataPoolIndex++;
		
		NSMutableData* answer = [[NSMutableData alloc] init];
		[answer autorelease];
		return answer;
		
	}
	
	if( nil == _mutableDataPool[_mutableDataPoolIndex] ) {
		
		_mutableDataPool[_mutableDataPoolIndex] = [[NSMutableData alloc] init];
		
	}
	
	NSMutableData* answer = _mutableDataPool[_mutableDataPoolIndex];
	
	_mutableDataPoolIndex++;
	
	return answer;
	
	
}


-(void)releaseMutableData:(NSMutableData*)freedMutableData {
	
	
	if( _mutableDataPoolIndex > POOL_SIZE ) {
		
		// release of disposable MutableData objects
		
		_mutableDataPoolIndex--;
        
		return;
		
		
	}
	
	_mutableDataPoolIndex--;
    
	[_mutableDataPool[_mutableDataPoolIndex] setLength:0];
    
	
}


-(id)init {
	
	JBJsonInput* answer = [super init];
	[JBObjectTracker allocated:answer];
	
	answer->_mutableDataPool = nil; // just to explicit about our intent
	answer->_mutableDataPoolIndex = 0; // the next free MutableData
	
 	
	return answer;
	
}
-(void)dealloc { 
    
    [JBObjectTracker deallocated:self];

    if( nil != _mutableDataPool ) { 
		for( int i = 0; i < POOL_SIZE; i++ ) {
			NSMutableData* data = _mutableDataPool[i];
			
			if( nil != data ) { 
				[data release];
			}
			
		}
		
		free(_mutableDataPool);
	}
	
	
	[super dealloc];

}

@end
