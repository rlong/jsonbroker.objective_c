// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <sys/time.h>

#import "JBBaseException.h"
#import "JBDateTimeUtilities.h"

#import "JBLog.h"


@implementation JBDateTimeUtilities


static NSDateFormatter *dateFormatter1;
static NSDateFormatter *dateFormatter2;
static NSDateFormatter *dateFormatter3;
static NSDateFormatter *dateFormatter4;

+(void)initialize {
	
	dateFormatter1 = [[NSDateFormatter alloc] init]; 
	[dateFormatter1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];

	dateFormatter2 = [[NSDateFormatter alloc] init]; 
	[dateFormatter2 setDateFormat:@"yyyyMMdd'T'HH:mm:ss"];

	dateFormatter3 = [[NSDateFormatter alloc] init]; 
	[dateFormatter3 setDateFormat:@"yyyy-MM-dd'T'HHmmss"];

	dateFormatter4 = [[NSDateFormatter alloc] init]; 
	[dateFormatter4 setDateFormat:@"yyyyMMdd'T'HHmmss"];

}


+(void)getTime:(struct timeval *)tp {
	[JBDateTimeUtilities getTime:tp inTimezone:NULL];
}

// tzp can be null 
+(void)getTime:(struct timeval *)tp inTimezone:(struct timezone *)tzp {
	int success = gettimeofday( tp, tzp );
	
	if( 0 != success ) {
		BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ callTo:@"gettimeofday" failedWithErrno:errno];
		@throw e;
	}
}

+(long)getTimeFrom:(struct timeval*)start to:(struct timeval*)end {
	long answer = 0;
	answer = (end->tv_sec - start->tv_sec ) * 1000 * 1000;
	answer += end->tv_usec;
	answer -= start->tv_usec;
	return answer;
}

+(long)getElapsedTimeSince:(struct timeval*)timestamp {
	struct timeval now;
	[JBDateTimeUtilities getTime:&now];
	long answer = [JBDateTimeUtilities getTimeFrom:timestamp to:&now];	
	return answer;
}


+(NSString*)iso8601RepresentationOfDate:(NSDate*)date {
	
	return [dateFormatter1 stringFromDate:date];
}

+(NSDate*)parseDateFromString:(NSString*)string {
	
	NSDate *answer = nil;
	
	answer = [dateFormatter1 dateFromString:string];
	if( nil != answer ) {
		return answer;
	}
	
	answer = [dateFormatter2 dateFromString:string];
	if( nil != answer ) {
		return answer;
	}
	
	answer = [dateFormatter3 dateFromString:string];
	if( nil != answer ) {
		return answer;
	}

	answer = [dateFormatter4 dateFromString:string];
	if( nil != answer ) {
		return answer;
	}
	
	NSString* technicalError = [NSString stringWithFormat:@"could not interpret '%@' as a date", string];
	BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
	@throw e;
	
}


@end
