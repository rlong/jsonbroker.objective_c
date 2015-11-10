// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBHttpHeader.h"

@interface JBAuthenticationInfo : NSObject <JBHttpHeader> {

	NSString* _cnonce;
	//@property (nonatomic, retain) NSString* cnonce;
	//@synthesize cnonce = _cnonce;
	
	
	NSString* _nextnonce;
	//@property (nonatomic, retain) NSString* nextnonce;
	//@synthesize nextnonce = _nextnonce;
	
	UInt32 _nc;
	//@property (nonatomic) UInt32 nc;
	//@synthesize nc = _nc;

	NSString* _qop;
	//@property (nonatomic, retain) NSString* qop;
	//@synthesize qop = _qop;

	NSString* _rspauth;
	//@property (nonatomic, retain) NSString* rspauth;
	//@synthesize rspauth = _rspauth;
	
	
	
}

-(NSString*)toString;

+(JBAuthenticationInfo*)buildFromString:(NSString*)authInfo;


#pragma mark fields

//NSString* _cnonce;
@property (nonatomic, retain) NSString* cnonce;
//@synthesize cnonce = _cnonce;


//NSString* _nextnonce;
@property (nonatomic, retain) NSString* nextnonce;
//@synthesize nextnonce = _nextnonce;

//UInt32 _nc;
@property (nonatomic) UInt32 nc;
//@synthesize nc = _nc;


//NSString* _qop;
@property (nonatomic, retain) NSString* qop;
//@synthesize qop = _qop;

//NSString* _rspauth;
@property (nonatomic, retain) NSString* rspauth;
//@synthesize rspauth = _rspauth;


@end
