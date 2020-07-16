//
//  NoteCell.m
//  mynotesapp
//
//  Created by Facundo Almeida on 6/6/20.
//  Copyright © 2020 Facundo Almeida. All rights reserved.
//

#import "NoteCell.h"
#import "../Models/NSDate+MyFormats.h"

@implementation Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillForNote:(Note *)note pinnedHint: (bool)pinnedHint {
    self.titleLabel.text = note.title;
    self.contentLabel.text = note.content;
    [self.categoryButton setTitle:note.category.title forState:UIControlStateNormal];
    self.createdDateLabel.text = [note.createdDate shortString];
    
    if (pinnedHint) {
        self.backgroundColor = [UIColor systemFillColor];
        self.pinIndicator.hidden = !note.pinned;
    }
    
    else {
        self.backgroundColor = nil;
        self.pinIndicator.hidden = true;
    }
}

@end
