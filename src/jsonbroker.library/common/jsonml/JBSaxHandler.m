// Copyright (c) 2014 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBaseException.h"
#import "JBLog.h"
#import "JBMemoryModel.h"
#import "JBSaxHandler.h"
#import "JBStringHelper.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface JBSaxHandler ()



// elementText
//NSMutableString* _elementText;
@property (nonatomic, retain) NSMutableString* elementText;
//@synthesize elementText = _elementText;



// indices
//NSMutableArray* _indices;
@property (nonatomic, retain) NSMutableArray* indices;
//@synthesize indices = _indices;

// jsonHandler
//id<JBJsonDocumentHandler> _jsonHandler;
@property (nonatomic, retain) id<JBJsonDocumentHandler> jsonHandler;
//@synthesize jsonHandler = _jsonHandler;


@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@implementation JBSaxHandler


-(void)flushElementText {
    
    
    if( 0 == [_elementText length] ) {
        return; // no-op
    }
    
    NSString* string = _elementText;
    if( _trim ) {
        
        string = [JBStringHelper trim:string];
    }
    
    if( _ignoreEmptyStrings && 0 == [string length] ) {
            
        [_elementText setString:@""]; // http://stackoverflow.com/questions/3332617/clearing-rather-than-releasing-a-nsmutablestring
        return;
    }

//    Log_debugString( string );
    
    [_jsonHandler onStringWithIndex:_currentIndex value:string];
    _currentIndex++;
    
    [_elementText setString:@""]; // http://stackoverflow.com/questions/3332617/clearing-rather-than-releasing-a-nsmutablestring
    
    
}

#pragma mark -
#pragma mark <NSXMLParserDelegate> implementation

// sent when the parser finds an element start tag.
// In the case of the cvslog tag, the following is what the delegate receives:
//   elementName == cvslog, namespaceURI == http://xml.apple.com/cvslog, qualifiedName == cvslog
// In the case of the radar tag, the following is what's passed in:
//    elementName == radar, namespaceURI == http://xml.apple.com/radar, qualifiedName == radar:radar
// If namespace processing >isn't< on, the xmlns:radar="http://xml.apple.com/radar" is returned as an attribute pair, the elementName is 'radar:radar' and there is no qualifiedName.
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

    
    // root element ?
    if( 0 == [_indices count] ) {
        [_jsonHandler onArrayDocumentStart];
    } else {
        
        [self flushElementText];
        [_jsonHandler onArrayStartWithIndex:_currentIndex];
        
    }
    
    // 'push'
    {
        [_indices addObject:[NSNumber numberWithInt:_currentIndex]];
        _currentIndex = 0;
    }
    
//    Log_debugString( elementName );
    
    [_jsonHandler onStringWithIndex:_currentIndex value:elementName];
    
    _currentIndex = 1;
    
    long count = [attributeDict count];
    if( 0 < count ) {
        
        [_jsonHandler onObjectStartWithIndex:_currentIndex];
        {
            for( NSString* attName in attributeDict ) {
                NSString* attValue = [attributeDict objectForKey:attName];
                [_jsonHandler  onStringWithKey:attName value:attValue];
            }
            
        }
        [_jsonHandler onObjectEndWithIndex:_currentIndex];
        _currentIndex = 2;
    }
    
    
    

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    
    [self flushElementText];
    
    if( 0 == [_indices count] ) {
        
        [_jsonHandler onArrayDocumentEnd];
        
    } else {

        // 'pop'
        {
            NSNumber* currentIndex = [_indices lastObject];
            _currentIndex = [currentIndex intValue];
            [_indices removeLastObject];
        }

        [_jsonHandler onArrayEndWithIndex:_currentIndex];

    }


    
}



- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    [_elementText appendString:string];
    
}




- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    NSString* parseErrorDomain = [parseError domain];
    NSInteger parseErrorCode = [parseError code];
    //
    
    // if parsing was aborted by the delegate (i.e. self)
    if( NSXMLParserDelegateAbortedParseError == parseErrorCode &&  [NSXMLParserErrorDomain isEqualToString:parseErrorDomain] ) {
        
        return;
    }
    
    Log_warnError( parseError );
    @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ callTo:@"[NSXMLParser parse]" failedWithError:parseError];

}
// ...and this reports a fatal error to the delegate. The parser will stop parsing.


#pragma mark -
#pragma mark instance lifecycle


-(id)initWithJsonHandler:(id<JBJsonDocumentHandler>)jsonHandler {
    
    JBSaxHandler* answer = [super init];
    
    if( nil != answer ) {
        answer->_currentIndex = 0;
        answer->_elementText = [[NSMutableString alloc] init];
        answer->_ignoreEmptyStrings = true;
        answer->_indices = [[NSMutableArray alloc] init];
        [answer setJsonHandler:jsonHandler];
        answer->_trim = true;
    }
    
    return answer;
}


-(void)dealloc {
	
    [self setElementText:nil];
	[self setIndices:nil];
    [self setJsonHandler:nil];

	JBSuperDealloc();
	
}



#pragma mark -
#pragma mark fields

// elementText
//NSMutableString* _elementText;
//@property (nonatomic, retain) NSMutableString* elementText;
@synthesize elementText = _elementText;


// indices
//NSMutableArray* _indices;
//@property (nonatomic, retain) NSMutableArray* indices;
@synthesize indices = _indices;

// jsonHandler
//id<JBJsonDocumentHandler> _jsonHandler;
//@property (nonatomic, retain) id<JBJsonDocumentHandler> jsonHandler;
@synthesize jsonHandler = _jsonHandler;


@end
