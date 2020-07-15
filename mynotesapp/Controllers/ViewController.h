//
//  ViewController.h
//  mynotesapp
//
//  Created by Facundo Almeida on 6/3/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/NoteCategory.h"
#import "../Models/Note.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (readonly, strong, nullable, nonatomic) UIRefreshControl *refreshControl;
@property (readwrite, strong, nonnull, nonatomic) NSString *textFilter;
@property (readwrite, strong, nullable, nonatomic) NoteCategory *categoryFilter;
@property (readonly, strong, nullable, nonatomic) NSArray<Note*> *filteredNotes;

- (NSArray<Note*> *_Nonnull)notes;
- (void)reloadNotes;
- (void)didReloadNotes:(NSError *)error;
- (void)applyTextFilter:(NSString *)newFilter;
- (void)applyCategoryFilter:(NoteCategory *_Nullable)newFilter;
- (void)didSearchBarTextChange;
- (void)updateFilteredNotes;
- (void)updateFilterSubView;
@end

