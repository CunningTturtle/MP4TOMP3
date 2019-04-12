//
//  HistyTableViewCell.h
//  MP4TOMP3
//
//  Created by mc309 on 2019/4/11.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CellShareBlock)(UITableViewCell *shareCell);


NS_ASSUME_NONNULL_BEGIN

@interface HistyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic,strong) CellShareBlock shareblock;
@end

NS_ASSUME_NONNULL_END
