//
//  Note.h
//  mynotesapp
//
//  Created by Facundo Almeida on 6/4/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#ifndef Note_h
#define Note_h

#import "NoteCategory.h"

@interface Note : NSObject

@property (copy) NSString *identifier;
@property (copy) NSString *title;
@property (copy) NSString *content;
@property (copy) NSDate *createdDate;
@property (weak) NoteCategory *category;

- (id)initWithDict:(NSDictionary *)dict;

@end

#endif /* Note_h */
