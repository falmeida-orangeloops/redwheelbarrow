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

@property (copy) NSString *identifier;
@property (copy) NSString *title;
@property (copy) NSDate *createdDate;

- (id)initWithDict:(NSDictionary *)dict;

@end

#endif /* NoteCategory_h */
