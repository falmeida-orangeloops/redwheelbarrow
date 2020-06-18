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

@property (copy, nonnull, nonatomic) NSString *identifier;
@property (copy, nonnull, nonatomic) NSString *title;
@property (copy, nonnull, nonatomic) NSString *content;
@property (copy, nonnull, nonatomic) NSDate *createdDate;
@property (strong, nonnull, nonatomic) NoteCategory *category;

- (id _Nonnull)initWithDict:(NSDictionary *_Nonnull)dict;

@end

#endif /* Note_h */
