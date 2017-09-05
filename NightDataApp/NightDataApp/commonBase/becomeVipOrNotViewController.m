//
//  becomeVipOrNotViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/22.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "becomeVipOrNotViewController.h"

@interface becomeVipOrNotViewController ()

@end

@implementation becomeVipOrNotViewController
{
    NSTimer *timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self createView];
    // Do any additional setup after loading the view.
}

-(void)createView
{
    UIView *backAlpha = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [backAlpha setBackgroundColor:Color_blackBack];
    [backAlpha setAlpha:0.5];
    [self.view addSubview:backAlpha];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf)];
//    [backAlpha addGestureRecognizer:tap];
    
    
    if (_ifTimeShow) {
        UIImageView *buttonBack = [UIImageView new];
        [buttonBack setUserInteractionEnabled:YES];
        [self.view addSubview:buttonBack];
        buttonBack.sd_layout
        .centerYEqualToView(self.view)
        .centerXEqualToView(self.view)
        .widthIs(260)
        .heightIs(140);
        [buttonBack setImage:[UIImage imageNamed:@"alertBackView"]];
        [buttonBack.layer setCornerRadius:5];
        [buttonBack.layer setMasksToBounds:YES];
        
        
        UILabel *titleLabel = [UILabel new];
        [buttonBack addSubview:titleLabel];
        
        titleLabel.sd_layout
        .centerXEqualToView(buttonBack)
        .topSpaceToView(buttonBack, 20)
        .heightIs(30)
        .rightSpaceToView(buttonBack, 10)
        .leftSpaceToView(buttonBack, 10);
        [titleLabel setText:_message];
        [titleLabel setTextColor:Color_white];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setNumberOfLines:0];
        
        
        UIImageView *NOData = [UIImageView new];
        [buttonBack addSubview:NOData];
        NOData.sd_layout
        .topSpaceToView(buttonBack, 60)
        .centerXEqualToView(buttonBack)
        .heightIs(40)
        .widthIs(40);
        
        [NOData setImage:[UIImage imageNamed:@"NoDataAlert"]];
        
        
        timer= [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(hiddenselfView) userInfo:nil repeats:NO];
        

    } else {
        UIImageView *buttonBack = [UIImageView new];
        [buttonBack setUserInteractionEnabled:YES];
        [self.view addSubview:buttonBack];
        buttonBack.sd_layout
        .centerYEqualToView(self.view)
        .centerXEqualToView(self.view)
        .widthIs(260)
        .heightIs(180);
        [buttonBack setImage:[UIImage imageNamed:@"alertBackView"]];
        [buttonBack.layer setCornerRadius:5];
        [buttonBack.layer setMasksToBounds:YES];
        
        UILabel *titleLabel = [UILabel new];
        [buttonBack addSubview:titleLabel];
        
        titleLabel.sd_layout
        .centerXEqualToView(buttonBack)
        .topSpaceToView(buttonBack, 20)
        .heightIs(20)
        .rightSpaceToView(buttonBack, 10)
        .leftSpaceToView(buttonBack, 10);
        [titleLabel setText:_message];
        [titleLabel setTextColor:Color_white];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        if (_btnTitle) {
            UIButton *buttonDo = [UIButton new];
            [buttonBack addSubview:buttonDo];
            buttonDo.sd_layout
            .topSpaceToView(buttonBack, 60)
            .centerXEqualToView(buttonBack)
            .heightIs(40)
            .widthIs(120);
            [buttonDo.layer setCornerRadius:5];
            [buttonDo.layer setMasksToBounds:YES];
            [buttonDo setTitle:_btnTitle forState:UIControlStateNormal];
            [buttonDo setBackgroundColor:Color_Gold];
            [buttonDo setTitleColor:getUIColor(Color_black) forState:UIControlStateNormal];
            [buttonDo.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [buttonDo setTitleColor:getUIColor(Color_black) forState:UIControlStateNormal];
            [buttonDo addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *buttonCancel = [UIButton new];
            [buttonBack addSubview:buttonCancel];
            buttonCancel.sd_layout
            .topSpaceToView(buttonDo, 20)
            .centerXEqualToView(buttonBack)
            .heightIs(40)
            .widthIs(120);
            [buttonCancel.layer setCornerRadius:5];
            [buttonCancel.layer setMasksToBounds:YES];
            [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
            [buttonCancel setBackgroundColor:[UIColor lightGrayColor]];
            [buttonCancel setTitleColor:Color_Cancel forState:UIControlStateNormal];
            [buttonCancel.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [buttonCancel addTarget:self action:@selector(hiddenSelf) forControlEvents:UIControlEventTouchUpInside];
        } else {
            
            UIImageView *NOData = [UIImageView new];
            [buttonBack addSubview:NOData];
            NOData.sd_layout
            .topSpaceToView(buttonBack, 60)
            .centerXEqualToView(buttonBack)
            .heightIs(40)
            .widthIs(40);
            
            [NOData setImage:[UIImage imageNamed:@"NoDataAlert"]];
            
            
            UIButton *buttonCancel = [UIButton new];
            [buttonBack addSubview:buttonCancel];
            buttonCancel.sd_layout
            .topSpaceToView(NOData, 20)
            .centerXEqualToView(buttonBack)
            .heightIs(40)
            .widthIs(120);
            [buttonCancel.layer setCornerRadius:5];
            [buttonCancel.layer setMasksToBounds:YES];
            [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
            [buttonCancel setBackgroundColor:[UIColor lightGrayColor]];
            [buttonCancel setTitleColor:Color_white forState:UIControlStateNormal];
            [buttonCancel.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [buttonCancel addTarget:self action:@selector(hiddenSelf) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    
    
   
    
    
    
}


-(void)hiddenselfView
{
    if (timer.isValid) {
        [timer invalidate];
    }
    timer=nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickAction
{
    if ([_delegate respondsToSelector:@selector(doneClickActin)]) {
        [self hiddenSelf];
        [_delegate doneClickActin];
    }
}

-(void)hiddenSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
