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
#import "mynotesapp-Swift.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (readonly, strong, nullable, nonatomic) RefreshControl *refreshControl;

- (void)reloadNotes;
- (void)didReloadNotes:(NSError *)error;
@end

