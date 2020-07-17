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

@property (readonly, strong, nonnull, nonatomic) NSMutableArray<Note*> *notes;
@property (readonly, strong, nonnull, nonatomic) NSMutableDictionary<NSString*, NoteCategory*> *categories;
@property (readonly, strong, nonnull, nonatomic) NSMutableArray<Note*> *pinnedNotes;
@property (readonly, strong, nonnull, nonatomic) NSMutableArray<Note*> *archivedNotes;

- (void)addCategory:(NoteCategory *_Nonnull)category;
- (void)addNote:(Note *_Nonnull)note atIndex:(int)index;
- (void)addNote:(Note *_Nonnull)note;
- (Note *_Nonnull)addEmptyNote;
- (void)removeCategory:(NoteCategory *_Nonnull)category;
- (void)removeNote:(Note *_Nonnull)note;
- (void)updateNote:(Note *_Nonnull)note;
- (void)togglePinNote:(Note *_Nonnull)note;
- (void)toggleArchiveNote:(Note *_Nonnull)note;
- (void)reloadNotesAndCategories:(void (^_Nonnull)(NSError * _Nonnull error))completionHandler;
+ (instancetype _Nonnull)sharedRepository;

@end

#endif /* Repository_h */
