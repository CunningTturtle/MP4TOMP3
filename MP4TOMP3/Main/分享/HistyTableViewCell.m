//
//  HistyTableViewCell.m
//  MP4TOMP3
//
//  Created by mc309 on 2019/4/11.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import "HistyTableViewCell.h"

@implementation HistyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _iconImg.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)shareOnClick:(UIButton *)sender {
    if (self.shareblock) {
        self.shareblock(self);
    }
}

@end
