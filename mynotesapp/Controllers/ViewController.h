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

@property (readonly, weak, nullable, nonatomic) UIRefreshControl *refreshControl;

- (void)updateNotes;
@end

