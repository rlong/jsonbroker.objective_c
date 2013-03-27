// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import "JBLog.h"
#import "JBStringHelper.h"

@implementation JBStringHelper

const char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

+(NSString*)trim:(NSString*)input {
    
    NSString* answer = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return answer;
    
}


// DEPRECATED: use [DataHelper toUtf8String]
+(NSString*)getUtf8String:(NSData*)data { 
    NSString* answer = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [answer autorelease];
    return answer;
}


+(NSData*)toUtf8Data:(NSString*)input { 
    
	const char* bytes = [input UTF8String];
	
	NSData* answer = [NSData dataWithBytes:bytes length:[input lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    
    return answer;
    
}


+(NSString*)convertPathToUri:(NSString*)path { 
    
    Log_debugString( path );
    
    bool isWindowsPath = false;
    
    // if the path looks like a windows path ... 
    if( [path length] >= 3 && '/' != [path characterAtIndex:0] && ':' == [path characterAtIndex:1] ) { 
        
        isWindowsPath = true;
        path = [path stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        
    }
    
    NSString* answer;
    
    if( NO ) { 
        
        NSURL* url = [NSURL fileURLWithPath:path];
        
        NSString* answer = [url absoluteString];
        
        if( [answer hasPrefix:@"file://localhost/"] )  {
            
            answer = [answer stringByReplacingOccurrencesOfString:@"file://localhost/" withString:@"file:///"];
            
        }
    }
    
    if( isWindowsPath ) { 
        answer = [NSString stringWithFormat:@"file:///%@", path];
        
    } else {
        answer = [NSString stringWithFormat:@"file://%@", path];
    }
    
    
    
    Log_debugString( answer );
    
    return answer;
    
    
}


// replace the likes of "&#39;" with "'" (e.g. playlist.osx.vlc-1.1.12.xml)
+(NSString*)unescapeHtmlCodes:(NSString*)input { 
    

    
    
#if defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
	
    if( NO ) { 
        // OSX ... 
        Log_debug(@"OSX");
        
        // vvv http://stackoverflow.com/questions/1067652/converting-amp-to-in-objective-c
        
        CFStringRef escapedAnswer = (CFStringRef)input;
        CFStringRef unescapedAnswer = CFXMLCreateStringByUnescapingEntities(kCFAllocatorDefault, escapedAnswer, NULL);
        return (NSString*)[NSMakeCollectable(unescapedAnswer) autorelease];
        
        // ^^^ http://stackoverflow.com/questions/1067652/converting-amp-to-in-objective-c
    }
	
#endif
    
    
    NSRange rangeOfHTMLEntity = [input rangeOfString:@"&#"];
    if( NSNotFound == rangeOfHTMLEntity.location ) { 
        return input;
    }
    
    
    NSMutableString* answer = [[NSMutableString alloc] init];
    [answer autorelease];
    
    NSScanner* scanner = [NSScanner scannerWithString:input];
    [scanner setCharactersToBeSkipped:nil]; // we want all white-space
    
    while( ![scanner isAtEnd] ) { 
        
        NSString* fragment;
        [scanner scanUpToString:@"&#" intoString:&fragment];
        if( nil != fragment ) { // e.g. '&#38; B'
            [answer appendString:fragment];        
        }
        
        if( ![scanner isAtEnd] ) { // implicitly we scanned to the next '&#'
            
            int scanLocation = (int)[scanner scanLocation];
            [scanner setScanLocation:scanLocation+2]; // skip over '&#'
            
            int htmlCode;
            if( [scanner scanInt:&htmlCode] ) {
                char c = htmlCode;
                [answer appendFormat:@"%c", c];
                
                scanLocation = (int)[scanner scanLocation];
                [scanner setScanLocation:scanLocation+1]; // skip over ';'
                
            } else {
                // err ? 
            }
        }
        
    }
    
    return answer;
    
}


// see also RFC-2396
+(NSString*)escapeString:(NSString*)input { 
	
	
	CFStringRef inputAsStringRef = (CFStringRef)input;
	CFStringRef answerAsStringRef;
    
	answerAsStringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, inputAsStringRef, NULL,CFSTR(":/=,!$&'()*+;@?"),kCFStringEncodingUTF8);
	
	// from http://discussions.apple.com/thread.jspa?messageID=7996967 ...
	// answerAsStringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, inputAsStringRef, NULL,CFSTR("!$&'()*+,-./:;=?@_~"),kCFStringEncodingUTF8);
	
	NSString* answer = (NSString*)answerAsStringRef;
	[answer autorelease];
    
	return answer;
}



+(NSString*)toHexString:(UInt8[16])bytes {
	
	char utf8HashString[33];
	
	for( int i = 0; i < 16; i++ ) {
		UInt8 byte = bytes[i];
		
		utf8HashString[ i * 2 ] = hexDigits[ byte >> 4 ];
		utf8HashString[ (i * 2) + 1 ] = hexDigits[ byte & 0xf ];
	}
	
	utf8HashString[32] = 0; // null terminate	
	NSString* answer = [NSString stringWithUTF8String:utf8HashString];

	return answer;
	
}


// as per javascript
+(NSString*)decodeURIComponent:(NSString*)encodedURIComponent {
    
    NSString* answer = [encodedURIComponent stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return answer;
    
}


@end
