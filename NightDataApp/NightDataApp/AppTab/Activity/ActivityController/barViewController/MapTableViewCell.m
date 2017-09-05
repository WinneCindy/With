//
//  MapTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/22.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "MapTableViewCell.h"

@implementation MapTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        _mapImage = [UIImageView new];
        [self.contentView addSubview:_mapImage];
        
        _mapImage.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .topEqualToView(self.contentView)
        .bottomEqualToView(self.contentView);
        
        
        
        [_mapImage setContentMode:UIViewContentModeScaleAspectFill];
        
        [_mapImage.layer setMasksToBounds:YES];
        [self.contentView addSubview:_mapImage];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
