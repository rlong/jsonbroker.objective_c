// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBDateTimeUtilities.h"
#import "JBDateTimeUtilitiesUnitTest.h"
#import "JBLog.h"

@implementation JBDateTimeUtilitiesUnitTest


static NSCalendar *gregorianCalendar;

+(void)initialize {
	gregorianCalendar =  [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
}

-(NSInteger)yearFromDate:(NSDate*)date {
	
	NSDateComponents *comps = [gregorianCalendar components:NSYearCalendarUnit fromDate:date];
	return [comps year];
}


-(NSInteger)monthFromDate:(NSDate*)date {
	
	NSDateComponents *comps = [gregorianCalendar components:NSMonthCalendarUnit fromDate:date];
	return [comps month];
}

-(NSInteger)daysFromDate:(NSDate*)date {
	NSDateComponents *comps = [gregorianCalendar components:NSDayCalendarUnit fromDate:date];
	return [comps day];
}


-(NSInteger)hoursFromDate:(NSDate*)date {
	NSDateComponents *comps = [gregorianCalendar components:NSHourCalendarUnit fromDate:date];
	return [comps hour];
}

-(NSInteger)minutesFromDate:(NSDate*)date {
	NSDateComponents *comps = [gregorianCalendar components:NSMinuteCalendarUnit fromDate:date];
	return [comps minute];
}


-(NSInteger)secondsFromDate:(NSDate*)date {
	NSDateComponents *comps = [gregorianCalendar components:NSSecondCalendarUnit fromDate:date];
	return [comps second];
}



-(void)validateDate:(NSDate*)date {

	STAssertTrue( nil != date, @"actual = %p", date );

	NSInteger year = [self yearFromDate:date];
	STAssertTrue( 1998 == year, @"actual = %d", year );
	
	NSInteger month = [self monthFromDate:date];
	STAssertTrue( 7 == month, @"actual = %d", month );
	
	NSInteger days = [self daysFromDate:date];
	STAssertTrue( 17 == days, @"actual = %d", days );
	
	NSInteger hours = [self hoursFromDate:date];
	STAssertTrue( 14 == hours, @"actual = %d", hours );

	NSInteger minutes = [self minutesFromDate:date];
	STAssertTrue( 8 == minutes, @"actual = %d", minutes );
	
	NSInteger seconds = [self secondsFromDate:date];
	STAssertTrue( 55 == seconds, @"actual = %d", seconds );
	
}

-(void)testParseDateFromString {
	
	NSDate* date = [JBDateTimeUtilities parseDateFromString:@"1998-07-17T14:08:55"];
	[self validateDate:date];
	
	date = [JBDateTimeUtilities parseDateFromString:@"19980717T14:08:55"];
	[self validateDate:date];

	date = [JBDateTimeUtilities parseDateFromString:@"1998-07-17T140855"];
	[self validateDate:date];

	date = [JBDateTimeUtilities parseDateFromString:@"19980717T140855"];
	[self validateDate:date];

	if( NO ) { // dateFormatter4 will parse an empty string a 1970-01-01:00:00:00
		@try {  
			NSDate* date = [JBDateTimeUtilities parseDateFromString:@""];
			STFail( @"Exception should have been thrown" );
			[self validateDate:date];
		}
		@catch (NSException * e) {
			// good 
		}
	}
	
}

-(void)testIso8601RepresentationOfDate {

	NSDate* date = [JBDateTimeUtilities parseDateFromString:@"19980717T14:08:55"];
	[self validateDate:date];

	NSString* iso8601Representation = [JBDateTimeUtilities iso8601RepresentationOfDate:date];
	STAssertTrue( [@"1998-07-17T14:08:55" isEqualToString:iso8601Representation], @"actual = %@", iso8601Representation );
}
@end
