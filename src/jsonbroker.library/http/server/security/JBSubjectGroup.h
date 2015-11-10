//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBSubject.h"

@interface JBSubjectGroup : NSObject {


	NSMutableDictionary* _subjectDictionary;
	//@property (nonatomic, retain) NSMutableDictionary* subjectDictionary;
	//@synthesize subjectDictionary = _subjectDictionary;
	
}


-(NSEnumerator*)subjectEnumerator;

-(int)count;

-(bool)containsUsername:(NSString*)username;
-(JBSubject*)subjectForUsername:(NSString*)username;

-(void)addSubject:(JBSubject*)subject;

-(void)removeSubjectWithUsername:(NSString*)username;
-(void)removeSubject:(JBSubject*)subject;



@end
