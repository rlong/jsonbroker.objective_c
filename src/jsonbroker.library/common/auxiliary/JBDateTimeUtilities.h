// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//



#import <Foundation/Foundation.h>

#import <sys/time.h>

@interface JBDateTimeUtilities : NSObject 
{

}

+(void)getTime:(struct timeval *)tp;

+(void)getTime:(struct timeval *)tp inTimezone:(struct timezone *)tzp;

+(long)getTimeFrom:(struct timeval*)start to:(struct timeval*)end;

+(long)getElapsedTimeSince:(struct timeval*)timestamp;


+(NSString*)iso8601RepresentationOfDate:(NSDate*)date;

+(NSDate*)parseDateFromString:(NSString*)string;

@end
