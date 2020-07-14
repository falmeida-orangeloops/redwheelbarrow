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

@property (copy, nonatomic, nullable) void (^categoryFilterChangedCallback)(void);

- (void)fillForNote: (Note *)note;
+ (void (^)(void))categoryFilterChangedCallback;
+ (void)setCategoryFilterChangedCallback:(void (^)(void))callback;

@end

NS_ASSUME_NONNULL_END
