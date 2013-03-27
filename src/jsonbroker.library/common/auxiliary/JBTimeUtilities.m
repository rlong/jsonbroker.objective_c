// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <sys/time.h>

#import "JBBaseException.h"
#import "JBTimeUtilities.h"

#import "JBLog.h"


@implementation JBTimeUtilities


+(void)getTime:(struct timeval *)tp {
	[JBTimeUtilities getTime:tp inTimezone:NULL];
}

// tzp can be null 
+(void)getTime:(struct timeval *)tp inTimezone:(struct timezone *)tzp {
	int success = gettimeofday( tp, tzp );
	
	if( 0 != success ) {
		NSString* technicalError = [NSString stringWithFormat:@"%s (errno = %d)", strerror(errno), errno];
		BaseException* e = [[BaseException alloc] initWithOriginator:self line:__LINE__ faultMessage:technicalError];
		[e autorelease];
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
	[JBTimeUtilities getTime:&now];
	long answer = [JBTimeUtilities getTimeFrom:timestamp to:&now];	
	return answer;
}



@end
