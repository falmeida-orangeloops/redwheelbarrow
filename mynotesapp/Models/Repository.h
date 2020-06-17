//
//  Repository.h
//  mynotesapp
//
//  Created by Facundo Almeida on 6/17/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#ifndef Repository_h
#define Repository_h

#import <Foundation/Foundation.h>
#import "Note.h"
#import "NoteCategory.h"

@interface Repository : NSObject

@property NSMutableArray<Note*> *notes;
@property NSMutableDictionary<NSString*,NoteCategory*> *categories;

- (void)reloadNotesAndCategories;
+ (Repository *)sharedRepository;

@end

#endif /* Repository_h */
