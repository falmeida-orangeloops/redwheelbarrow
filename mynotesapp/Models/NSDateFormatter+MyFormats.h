//
//  NSDateFormatter+MyFormats.h
//  mynotesapp
//
//  Created by Facundo Almeida on 6/17/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#ifndef NSDateFormatter_MyFormats_h
#define NSDateFormatter_MyFormats_h

#import <Foundation/Foundation.h>

@interface NSDateFormatter (MyFormats)

+ (NSString *)shortStringFromDate:(NSDate *)date;

@end

#endif /* NSDateFormatter_MyFormats_h */
