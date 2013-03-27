// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBBaseException.h"
#import "JBNumericUtilities.h"
#import "JBNumericUtilitiesUnitTest.h"


@implementation JBNumericUtilitiesUnitTest


-(void)testParseIntegerGood
{
	
	NSString* integerString = @"12";
	
	int integerValue = [JBNumericUtilities parseInteger:integerString];
	
	STAssertTrue( 12 == integerValue, @"actual = %d", integerValue );		
}

-(void)testParseIntegerBadData
{
	
	NSString* integerValue = @"blah blah";
	
	@try
	{
		
		[JBNumericUtilities parseInteger:integerValue];
		STFail( @"element does not have parseable integer data" );		
	}
	@catch( BaseException* e )
	{
		// good
	}

}

-(void)testParseIntegerEmptyData
{
	
	NSString* integerValue = @"";
	
	@try
	{
		[JBNumericUtilities parseInteger:integerValue];
		STAssertTrue( NO, @"element does not have any data" );		
	}
	@catch( BaseException* e )
	{
		// good
	}
}


-(void)testParseDoubleGood
{
	
	NSString* doubleString = @"-3.14";
	
	double doubleValue = [JBNumericUtilities parseDouble:doubleString];
	
	STAssertTrue( -3.14 == doubleValue, @"actual = %f", doubleValue );		
}

-(void)testParse_15_650912 {
    
	
	NSString* doubleString = @"15.650912";
	
	double doubleValue = [JBNumericUtilities parseDouble:doubleString];
	
	STAssertTrue( 15.650912 == doubleValue, @"actual = %f", doubleValue );
}



-(void)testParseDoubleBadData
{
	
	NSString* doubleString = @"blah blah";
	
	@try
	{
		
		[JBNumericUtilities parseDouble:doubleString];
		STFail( @"element does not have parseable integer data" );		
	}
	@catch( BaseException* e )
	{
		// good
	}
	
}

-(void)testParseDoubleEmptyData
{
	
	NSString* doubleString = @"";
	
	@try
	{
		[JBNumericUtilities parseDouble:doubleString];
		STAssertTrue( NO, @"element does not have any data" );		
	}
	@catch( BaseException* e )
	{
		// good
	}
}

@end
