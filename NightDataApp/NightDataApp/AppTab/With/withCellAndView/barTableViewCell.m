//
//  barTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/20.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "barTableViewCell.h"

@implementation barTableViewCell
{
//    UIImageView *backImage;    //活动版面
    UIImageView *headUser;    //发布者头像
    UILabel *userName;        //发布者名字
    UILabel *distance;         //与用户距离
    UILabel *activityLabel;     //活动详情
    UILabel *activityName;
    UIImageView *sexImg;  //用户性别
    UILabel *activityAddress; //地址
    UILabel *timeLabel;
    UILabel *activityDetail;
    
    UIButton *shareBtn;
    UIButton *commentBtn;
    UIButton *likeBtn;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        
        
        [self setUp];
        
        
    }
    
    return self;
}

-(void)setUp
{
    UIView *contentview = self.contentView;
    
//    UIImageView *imageHot = [UIImageView new];
//    [contentview addSubview:imageHot];
//    imageHot.sd_layout
//    .topSpaceToView(contentview, 5)
//    .leftSpaceToView(contentview, 12)
//    .heightIs(19)
//    .widthIs(16);
//    [imageHot setImage:[UIImage imageNamed:@"hotFire"]];
//    
//    activityName = [UILabel new];
//    [contentview addSubview:activityName];
//    activityName.sd_layout
//    .leftSpaceToView(imageHot, 6)
//    .topSpaceToView(contentview, 8)
//    .heightIs(20)
//    .rightSpaceToView(contentview, 20);
//    [activityName setTextColor:Color_white];
//    [activityName setFont:[UIFont systemFontOfSize:16]];
    
    
   UIImageView* headUserCir = [UIImageView new];
    [contentview addSubview:headUserCir];
    headUserCir.sd_layout
    .leftSpaceToView(contentview, 12)
    .topSpaceToView(contentview, 13)
    .heightIs(44)
    .widthIs(44);
    [headUserCir setImage:[UIImage imageNamed:@"smallHead"]];
    [headUserCir.layer setCornerRadius:22];
    [headUserCir.layer setMasksToBounds:YES];
    
    
    headUser = [UIImageView new];
    [contentview addSubview:headUser];
    headUser.sd_layout
    .leftSpaceToView(contentview, 14)
    .topSpaceToView(contentview, 15)
    .heightIs(40)
    .widthIs(40);
    [headUser.layer setCornerRadius:20];
    [headUser.layer setMasksToBounds:YES];
    
    
    _headButton = [UIButton new];
    [contentview addSubview:_headButton];
    _headButton.sd_layout
    .leftSpaceToView(contentview, 14)
    .topSpaceToView(contentview, 15)
    .heightIs(40)
    .widthIs(40);
    [_headButton.layer setCornerRadius:20];
    [_headButton.layer setMasksToBounds:YES];
    
    
    userName = [UILabel new];
    [contentview addSubview:userName];
//    userName.sd_layout
//    .leftSpaceToView(headUserCir, 13)
//    .topSpaceToView(imageHot, 18)
//    .heightIs(20)
//    .
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headUserCir.mas_right).with.offset(13);
        make.top.equalTo(contentview.mas_top).with.offset(18);
        make.height.equalTo(@15);
    }];
    
    [userName setFont:[UIFont systemFontOfSize:12]];
    [userName setTextColor:Color_white];
    
//    sexImg = [UIImageView new];
//    [contentview addSubview:sexImg];
//    [sexImg mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.left.equalTo(userName.mas_right).with.offset(4);
//        make.top.equalTo(contentview.mas_top).with.offset(21);
//        make.height.equalTo(@11);
//        make.width.equalTo(@11);
//    }];
    
    activityAddress = [UILabel new];
    [contentview addSubview:activityAddress];
    [activityAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(headUserCir.mas_right).with.offset(13);
        make.top.equalTo(userName.mas_bottom).with.offset(1);
        make.height.equalTo(@20);
        make.width.equalTo(@200);
    }];
    
    [activityAddress setFont:[UIFont systemFontOfSize:12]];
    [activityAddress setTextColor:Color_white];
    
    
    timeLabel = [UILabel new];
    [contentview addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentview.mas_right).with.offset(-12);
        make.top.equalTo(contentview.mas_top).with.offset(18);
        make.height.equalTo(@15);
    }];
    [timeLabel setFont:[UIFont systemFontOfSize:12]];
    [timeLabel setTextColor:Color_white];
    
    
    
    distance = [UILabel new];
    [contentview addSubview:distance];
    [distance mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(contentview.mas_right).with.offset(- 12);
        make.top.equalTo(timeLabel.mas_bottom).with.offset(3);
        make.height.equalTo(@15);
    }];
    [distance setFont:[UIFont systemFontOfSize:12]];
    [distance setTextColor:Color_white];
    
    
    
    
    _backImage = [UIImageView new];
    [contentview addSubview:_backImage];
    _backImage.sd_layout
    .leftEqualToView(contentview)
    .topSpaceToView(headUserCir, 12)
    .bottomSpaceToView(contentview, 44)
    .rightEqualToView(contentview);
    [_backImage.layer setMasksToBounds:YES];
    [_backImage setContentMode:UIViewContentModeScaleAspectFill];

    
    UIImageView *alphaDetail = [UIImageView new];
    [_backImage addSubview:alphaDetail];
    alphaDetail.sd_layout
    .leftEqualToView(_backImage)
    .bottomEqualToView(_backImage)
    .rightEqualToView(_backImage)
    .heightIs(100);
    [alphaDetail setImage:[UIImage imageNamed:@"lowAlpha"]];
    
    activityDetail = [UILabel new];
    [_backImage addSubview:activityDetail];
    activityDetail.sd_layout
    .leftSpaceToView(_backImage,20)
    .bottomSpaceToView(_backImage,10)
    .rightSpaceToView(_backImage,20)
    .autoHeightRatio(0);
    [activityDetail setNumberOfLines:0];
    [activityDetail setFont:[UIFont systemFontOfSize:14]];
    [activityDetail setTextColor:Color_white];
    [activityDetail setTextAlignment:NSTextAlignmentCenter];
    
    
    shareBtn = [UIButton new];
    [contentview addSubview:shareBtn];
    shareBtn.tag = 3;
    shareBtn.sd_layout
    .leftEqualToView(contentview)
    .bottomEqualToView(contentview)
    .topSpaceToView(_backImage, 0)
    .widthIs(SCREEN_WIDTH / 3);
    
    [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(1, -5, -1, 5)];
    [shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [shareBtn addTarget:self action:@selector(clickThreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    commentBtn = [UIButton new];
    [contentview addSubview:commentBtn];
    commentBtn.sd_layout
    .leftSpaceToView(shareBtn, 0)
    .bottomEqualToView(contentview)
    .topSpaceToView(_backImage, 0)
    .widthIs(SCREEN_WIDTH / 3);
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    
    [commentBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [commentBtn setImageEdgeInsets:UIEdgeInsetsMake(1, -5, -1, 5)];
    [commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [commentBtn addTarget:self action:@selector(clickThreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.tag = 2;
    
    
   
    
    
    
    likeBtn = [UIButton new];
    [contentview addSubview:likeBtn];
    likeBtn.sd_layout
    .leftSpaceToView(commentBtn,0)
    .bottomEqualToView(contentview)
    .topSpaceToView(_backImage, 0)
    .widthIs(SCREEN_WIDTH / 3);
    [likeBtn setTitle:@"点赞" forState:UIControlStateNormal];
    [likeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [likeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [likeBtn addTarget:self action:@selector(clickThreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    likeBtn.tag = 1;
    
}

-(void)clickThreeBtn:(UIButton *)sender
{
    if (sender.tag == 1) {
        if ([_model.isLike integerValue] == 0) {
            [self praiseAnimation];
        } else {
            if ([_delegate respondsToSelector:@selector(clickBtn:section:)]) {
                [_delegate clickBtn:sender.tag section:self.tag];
            }
        }
    } else {
        if ([_delegate respondsToSelector:@selector(clickBtn:section:)]) {
            [_delegate clickBtn:sender.tag section:self.tag];
        }
    }
    
}


-(void)setModel:(ActivityModel *)model
{
    _model = model;
    
    [_backImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL, model.imgaeBack]]];
    [activityName setText:model.activityName];
    [userName setText:model.nameUser];
    [distance setText:model.distance];
    [headUser sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_HEADURL,model.imageUser]] placeholderImage:ImagePlaceHolder];
    [activityAddress setText:model.barAddress];
    [timeLabel setText:model.activityTime];
    [activityDetail setText:model.activityIntro];
    if ([model.sex integerValue] == 1) {
        [sexImg setImage:[UIImage imageNamed:@"girl"]];
    }
    if ([model.isLike integerValue] == 0) {
        [likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    } else {
        [likeBtn setImage:[UIImage imageNamed:@"haveLike"] forState:UIControlStateNormal];
    }
    
    [commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareBtn setTitle:model.viewNum forState:UIControlStateNormal];
}

- (void)praiseAnimation {
    UIImageView *imageView = [[UIImageView alloc] init]; CGRect frame = self.frame; //  初始frame，即设置了动画的起点
    imageView.frame = CGRectMake(self.frame.size.width - 60, frame.size.height - 50, 30, 30);
    //  初始化imageView透明度为0
    imageView.alpha = 0; imageView.backgroundColor = [UIColor clearColor]; imageView.clipsToBounds = YES;
    //  用0.2秒的时间将imageView的透明度变成1.0，同时将其放大1.3倍，再缩放至1.1倍，这里参数根据需求设置
    [UIView animateWithDuration:0.5 animations:^{ imageView.alpha = 1.0; imageView.frame = CGRectMake(frame.size.width - 40, frame.size.height - 90, 30, 30); CGAffineTransform transfrom = CGAffineTransformMakeScale(1.3, 1.3); imageView.transform = CGAffineTransformScale(transfrom, 1, 1); }]; [self addSubview:imageView];
    //  随机产生一个动画结束点的X值
    CGFloat finishX = round(random() % 200);
    //  动画结束点的Y值
    CGFloat finishY = 20;
    //  imageView在运动过程中的缩放比例
    CGFloat scale = round(random() % 2) + 0.7;
    // 生成一个作为速度参数的随机数
    CGFloat speed = 1 / round(random() % 900) + 0.6;
    //  动画执行时间
    NSTimeInterval duration = 4 * speed;
    //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
    if (duration == INFINITY) duration = 2.412346;
    // 随机生成一个0~7的数，以便下面拼接图片名
    int imageName = round(random() % 8);
    //  开始动画
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    //  设置动画时间
    [UIView setAnimationDuration:duration];
    //  拼接图片名字
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"like%d",imageName]];
    //  设置imageView的结束frame
    imageView.frame = CGRectMake( finishX, finishY, 30 * scale, 30 * scale);
    //  设置渐渐消失的效果，这里的时间最好和动画时间一致
    [UIView animateWithDuration:duration animations:^{ imageView.alpha = 0; }]; //  结束动画，调用onAnimationComplete:finished:context:函数
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    //  设置动画代理
    [UIView setAnimationDelegate:self]; [UIView commitAnimations];
}

/// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{ UIImageView *imageView = (__bridge UIImageView *)(context); [imageView removeFromSuperview]; imageView = nil;
    if ([_delegate respondsToSelector:@selector(clickBtn:section:)]) {
        [_delegate clickBtn:1 section:self.tag];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
