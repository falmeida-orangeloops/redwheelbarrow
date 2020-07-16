//
//  NoteCell.h
//  mynotesapp
//
//  Created by Facundo Almeida on 6/6/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pinIndicator;

- (void)fillForNote: (Note *)note pinnedHint: (bool)pinnedHint;

@end

NS_ASSUME_NONNULL_END
