//
//  vipTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/8.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "vipTableViewCell.h"

@implementation vipTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _vipCard = [UIImageView new];
        [self.contentView addSubview:_vipCard];
        
        _vipCard.sd_layout
        .leftSpaceToView(self.contentView, 12)
        .rightSpaceToView(self.contentView, 12)
        .topEqualToView(self.contentView)
        .bottomEqualToView(self.contentView);
        
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
