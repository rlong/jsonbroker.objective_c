// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBNumericUtilities.h"


@implementation JBNumericUtilities

+(int)parseInteger:(NSString*)integerValue;
{
	NSScanner* scanner = [NSScanner scannerWithString:integerValue];
	int answer;
	if( ! [scanner scanInt:&answer] ) {
	
		NSString* technicalError = [NSString stringWithFormat:@"failed to parse '%@' as an integer", integerValue];
		BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		
		@throw e;
	}
    
   
	return answer;
}


+(NSNumber*)parseIntegerObject:(NSString*)integerValue;
{
	NSScanner* scanner = [NSScanner scannerWithString:integerValue];
	int intValue;
	if( ! [scanner scanInt:&intValue] ) {
        
		NSString* technicalError = [NSString stringWithFormat:@"failed to parse '%@' as an integer", integerValue];
		BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		
		@throw e;
	}
    
    NSNumber* answer = [NSNumber numberWithInt:intValue];    
	return answer;

}


+(long)parseLong:(NSString*)longString { 

    NSScanner* scanner = [NSScanner scannerWithString:longString];
	long long answer;
	if( ! [scanner scanLongLong:&answer] ) {
        
		NSString* technicalError = [NSString stringWithFormat:@"failed to parse '%@' as a 'long long'", longString];
		BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		
		@throw e;
	}
    
	return (long)answer;

}


+(NSNumber*)parseLongObject:(NSString*)longString { 
    
    
    NSScanner* scanner = [NSScanner scannerWithString:longString];
	long long longValue;
	if( ! [scanner scanLongLong:&longValue] ) {
        
		NSString* technicalError = [NSString stringWithFormat:@"failed to parse '%@' as a 'long long'", longString];
		BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		
		@throw e;
	}
    
    NSNumber* answer = [NSNumber numberWithLong:(long)longValue];    
	return answer;

    
}


+(double)parseDouble:(NSString*)doubleValue;
{
	NSScanner* scanner = [NSScanner scannerWithString:doubleValue];
	double answer;
	if( ! [scanner scanDouble:&answer] ) {
		
		NSString* technicalError = [NSString stringWithFormat:@"failed to parse '%@' as a double", doubleValue];
		BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		
		@throw e;
	}
	
	return answer;
}
@end
