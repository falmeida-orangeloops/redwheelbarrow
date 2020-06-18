//
//  NoteCategory.h
//  mynotesapp
//
//  Created by Facundo Almeida on 6/4/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#ifndef NoteCategory_h
#define NoteCategory_h

@interface NoteCategory : NSObject

@property (copy, nonnull, nonatomic) NSString *identifier;
@property (copy, nonnull, nonatomic) NSString *title;
@property (copy, nonnull, nonatomic) NSDate *createdDate;

- (id _Nonnull)initWithDict:(NSDictionary *_Nonnull)dict;

@end

#endif /* NoteCategory_h */
