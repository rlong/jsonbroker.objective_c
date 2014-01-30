//  Copyright (c) 2013 Richard Long & HexBeerium
//
//  Released under the MIT license ( http://opensource.org/licenses/MIT )
//

#import <Foundation/Foundation.h>



// vvv derived from https://github.com/ccgus/fmdb/blob/master/src/FMDatabase.h


#if ! __has_feature(objc_arc)

    #define JBAutorelease(__v) ([__v autorelease]);

    #define JBRetain(__v) ([__v retain])

    #define JBRelease(__v) ([__v release])

    #define JBSuperDealloc() ([super dealloc])

#else
    // -fobjc-arc

    #define JBAutorelease(__v)

    #define JBRetain(__v)

    #define JBRelease(__v)

    #define JBSuperDealloc(__v)

#endif

// ^^^ derived from https://github.com/ccgus/fmdb/blob/master/src/FMDatabase.h

