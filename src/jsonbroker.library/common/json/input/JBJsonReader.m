// Copyright (c) 2013 Richard Long & HexBeerium
//
// Released under the MIT license ( http://opensource.org/licenses/MIT )
//


#import "JBBaseException.h"
#import "JBJsonBooleanHandler.h"
#import "JBJsonDataInput.h"
#import "JBJsonNumberHandler.h"
#import "JBJsonNullHandler.h"
#import "JBJsonReader.h"
#import "JBJsonStringHandler.h"


@implementation JBJsonReader

-(void)readArrayFromInput:(JBJsonInput*)input handler:(id<JBJsonDocumentHandler>)handler {
 
    int index = -1;

    for (UInt8 nextTokenStart = [input scanToNextToken]; ']' != nextTokenStart; nextTokenStart = [input scanToNextToken] ) {
        
        if( !_continue ) {
            return;
        }

        index++;
        
        if ('"' == nextTokenStart) {
            
            NSString* value = [JBJsonStringHandler readString:input];
            [handler onStringWithIndex:index value:value];
            continue;
        }
        
        if ('0' <= nextTokenStart && nextTokenStart <= '9') {
            
            NSNumber* value = [JBJsonNumberHandler readNumber:input];
            [handler onNumberWithIndex:index value:value];
            continue;
        }
        
        if ('[' == nextTokenStart) {
            
            [handler onArrayStartWithIndex:index];
            [input nextByte]; // skip past the '['
            [self readArrayFromInput:input handler:handler];
            [input nextByte]; // skip past the ']'
            [handler onArrayEndWithIndex:index];
            continue;
        }
        
        if ('{' == nextTokenStart) {
            
            [handler onObjectStartWithIndex:index];
            [input nextByte]; // skip past the '{'
            [self readObjectFromInput:input handler:handler];
            [input nextByte]; // skip past the '}'
            [handler onObjectEndWithIndex:index];
            continue;
            
        }
        
        if ('+' == nextTokenStart ) {
            
            NSNumber* value = [JBJsonNumberHandler readNumber:input];
            [handler onNumberWithIndex:index value:value];
            continue;
        }
        
        if ('-' == nextTokenStart ) {
            
            NSNumber* value = [JBJsonNumberHandler readNumber:input];
            [handler onNumberWithIndex:index value:value];
            continue;
        }
        
        if( 't' == nextTokenStart || 'T' == nextTokenStart ) {
            bool value = [JBJsonBooleanHandler readBoolean:input];
            [handler onBooleanWithIndex:index value:value];
            continue;
        }
        
        
        if( 'f' == nextTokenStart || 'F' == nextTokenStart ) {
            bool value = [JBJsonBooleanHandler readBoolean:input];
            [handler onBooleanWithIndex:index value:value];
            continue;
        }
        
        if( 'n' == nextTokenStart || 'N' == nextTokenStart ) {
            [JBJsonNullHandler readNull:input];
            [handler onNullWithIndex:index];
            continue;
        }


        @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"bad tokenBeginning; tokenBeginning = %d (%c)", nextTokenStart, nextTokenStart];

    }
}


-(void)readObjectFromInput:(JBJsonInput*)input handler:(id<JBJsonDocumentHandler>)handler {
    

    for (UInt8 nextTokenStart = [input scanToNextToken]; '}' != nextTokenStart; nextTokenStart = [input scanToNextToken] ) {
        
        if( !_continue ) {
            return;
        }
        
        NSString* key = [JBJsonStringHandler readString:input];
        
        nextTokenStart = [input scanToNextToken];
        
        if ('"' == nextTokenStart) {
            
            NSString* value = [JBJsonStringHandler readString:input];
            [handler onStringWithKey:key value:value];
            continue;
        }
        
        if ('0' <= nextTokenStart && nextTokenStart <= '9') {
            
            NSNumber* value = [JBJsonNumberHandler readNumber:input];
            [handler onNumberWithKey:key value:value];
            continue;
        }
        
        if ('[' == nextTokenStart) {
            
            [handler onArrayStartWithKey:key];
            [input nextByte]; // skip past the '['
            [self readArrayFromInput:input handler:handler];
            [input nextByte]; // skip past the ']'
            [handler onArrayEndWithKey:key];
            continue;
        }
        
        if ('{' == nextTokenStart) {
            
            [handler onObjectStartWithKey:key];
            [input nextByte]; // skip past the '{'
            [self readObjectFromInput:input handler:handler];
            [input nextByte]; // skip past the '}'
            [handler onObjectEndWithKey:key];
            continue;
            
        }
        
        if ('+' == nextTokenStart ) {
            
            NSNumber* value = [JBJsonNumberHandler readNumber:input];
            [handler onNumberWithKey:key value:value];
            continue;
        }
        
        if ('-' == nextTokenStart ) {
            
            NSNumber* value = [JBJsonNumberHandler readNumber:input];
            [handler onNumberWithKey:key value:value];
            continue;
        }
        
        if( 't' == nextTokenStart || 'T' == nextTokenStart ) {
            bool value = [JBJsonBooleanHandler readBoolean:input];
            [handler onBooleanWithKey:key value:value];
            continue;
        }
        
        
        if( 'f' == nextTokenStart || 'F' == nextTokenStart ) {
            bool value = [JBJsonBooleanHandler readBoolean:input];
            [handler onBooleanWithKey:key value:value];
            continue;
        }
        
        if( 'n' == nextTokenStart || 'N' == nextTokenStart ) {
            [JBJsonNullHandler readNull:input];
            [handler onNullWithKey:key];
            continue;
        }

        @throw [JBBaseException baseExceptionWithOriginator:self line:__LINE__ faultStringFormat:@"bad tokenBeginning; tokenBeginning = %d (%c)", nextTokenStart, nextTokenStart];
        
    }
    
}



-(void)readFromInput:(JBJsonInput*)input handler:(id<JBJsonDocumentHandler>)handler {
    
    _continue = true;
    
    UInt8 nextByte = [input currentByte];
    [input nextByte];  // skip past the '{' / '['
    
    if( '{' == nextByte ) {
        
        [handler onObjectDocumentStart];
        [self readObjectFromInput:input handler:handler];
        [handler onObjectDocumentEnd];
        
    } else {
        
        [handler onArrayDocumentStart];
        [self readArrayFromInput:input handler:handler];
        [handler onArrayDocumentEnd];
        
    }
    
    
}


-(void)readFromData:(NSData*)data handler:(id<JBJsonDocumentHandler>)handler {
    
    JBJsonDataInput* input = [[JBJsonDataInput alloc] initWithData:data];
    @try {
        [self readFromInput:input handler:handler];
    }
    @finally {
        [input release];
    }
}



+(void)readFromInput:(JBJsonInput*)input handler:(id<JBJsonDocumentHandler>)handler {
    
    
    JBJsonReader* reader = [[JBJsonReader alloc] init];
    
    @try {
        
        [reader readFromInput:input handler:handler];
    }
    @finally {
        [reader release];
    }
    
    
    
}

+(void)readFromData:(NSData*)data handler:(id<JBJsonDocumentHandler>)handler {

    JBJsonDataInput* input = [[JBJsonDataInput alloc] initWithData:data];
    JBJsonReader* reader = [[JBJsonReader alloc] init];

    @try {
        
        [reader readFromInput:input handler:handler];
    }
    @finally {
        [reader release];
        [input release];
    }

}


-(void)stop {
    _continue = false;
}



#pragma mark -
#pragma mark instance lifecycle

-(id)init {
    
    JBJsonReader* answer = [super init];
    if( nil != answer ) {
        
        answer->_continue = true;
        
    }
    
    return answer;
}


@end
