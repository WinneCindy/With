
//
//  ticketDetailViewController.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/26.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "ticketDetailViewController.h"

@interface ticketDetailViewController ()

@end

@implementation ticketDetailViewController
{
    BaseDomain *getData;
    NSDictionary *ticketDic;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    getData = [BaseDomain getInstance:NO];
    self.title = @"卡券详情";
    [self getData];
    // Do any additional setup after loading the view.
}

-(void)getData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_ticketId forKey:@"ticket_id"];
    [getData getData:URL_ticketDetail PostParams:params finish:^(BaseDomain *domain, Boolean success) {
        if ( [self checkHttpResponseResultStatus:domain]) {
            
            ticketDic = [domain.dataRoot dictionaryForKey:@"info"];
            
            [self createView];
        }
    }];
    
}

-(void)createView
{
    UIImageView *logoImge = [UIImageView new];
    [self.view addSubview:logoImge];
    logoImge.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 120)
    .widthIs(60)
    .heightIs(60);
    [logoImge.layer setCornerRadius:30];
    [logoImge.layer setMasksToBounds:YES];
    [logoImge setImage:ImagePlaceHolderHead];
    
    
    UIImageView *erWei = [UIImageView new];
    [self.view addSubview:erWei];
    erWei.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(logoImge, 20)
    .widthIs(300)
    .heightIs(300);
    [erWei sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",  [ticketDic stringForKey:@"code_img"]]]];
    
    
    
    UILabel *endTime = [UILabel new];
    [self.view addSubview:endTime];
    endTime.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(erWei, 20)
    .widthIs(SCREEN_WIDTH)
    .heightIs(15);
    [endTime setFont:[UIFont systemFontOfSize:10]];
    [endTime setTextColor:Color_white];
    [endTime setTextAlignment:NSTextAlignmentCenter];
    [endTime setText:[self getFriendlyDateStringFFF:[ticketDic integerForKey:@"end_time"]]];
    
    UILabel *woring = [UILabel new];
    [self.view addSubview:woring];
    woring.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(endTime, 20)
    .heightIs(20)
    .widthIs(SCREEN_WIDTH);
    [woring setTextColor:Color_white];
    [woring setFont:[UIFont systemFontOfSize:14]];
    [woring setText:@"兑换时请向收银员出示"];
    [woring setTextAlignment:NSTextAlignmentCenter];
    
    
    UILabel *codeLabel = [UILabel new];
    [self.view addSubview:codeLabel];
    codeLabel.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(woring, 10)
    .heightIs(20)
    .widthIs(SCREEN_WIDTH);
    [codeLabel setTextColor:Color_white];
    [codeLabel setFont:[UIFont systemFontOfSize:18]];
    [codeLabel setText:[ticketDic stringForKey:@"code"]];
   
    codeLabel = [self changeWordSpaceForLabel:codeLabel WithSpace:5];
    
    [codeLabel setTextAlignment:NSTextAlignmentCenter];
    
    
//    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.infoLabel.text attributes:@{NSKernAttributeName : @(1.5f)}]; NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init]; [paragraphStyle setLineSpacing:6]; [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.infoLabel.text.length)]; [self.infoLabel setAttributedText:attributedString]; self.infoLabel.numberOfLines = 0; [self.infoLabel sizeToFit]; [self.scrollView addSubview:self.infoLabel];
  
    
}


- (NSString*) getFriendlyDateStringFFF : (long long) lngDate {
    
    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:lngDate];
    
    NSDate *myDate = [NSDate date];
    
    NSString *DIF;
    NSString *strDate;
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *compsNow = [[NSDateComponents alloc] init];
    NSDateComponents *compsCur = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    compsNow = [calendar components:unitFlags fromDate:myDate];
    compsCur = [calendar components:unitFlags fromDate:curDate];
    if ([compsCur day]==[compsNow day]&&[compsCur month]==[compsNow month]&&[compsCur year]==[compsNow year] && [compsCur hour] == [compsNow hour] && ([compsNow minute] - [compsCur minute] < 5)) {
        DIF=@"还有5分钟到期咯";
        strDate=[NSString stringWithFormat:@"%@",DIF];
    } else if ([compsCur day]==[compsNow day]&&[compsCur month]==[compsNow month]&&[compsCur year]==[compsNow year] && [compsCur hour] == [compsNow hour] &&([compsNow minute] - [compsCur minute] > 5) ) {
        NSInteger minute = [compsNow minute] - [compsCur minute];
        strDate = [NSString stringWithFormat:@"%d分钟前",abs((int)minute)];
    }else if ([compsCur day]==[compsNow day]&&[compsCur month]==[compsNow month]&&[compsCur year]==[compsNow year]) {
        DIF=@"今天就要到期咯";
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"HH:mm"];
        NSString* dateStr = [formatter stringFromDate:curDate];
        strDate=[NSString stringWithFormat:@"%@ %@",DIF,dateStr];
    }else if ([compsCur day]+1==[compsNow day]&&[compsCur month]==[compsNow month]&&[compsCur year]==[compsNow year]){
        DIF=@"昨天就已经到期啦";
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"有效期到今天 HH:mm"];
        NSString* dateStr = [formatter stringFromDate:curDate];
        strDate=[NSString stringWithFormat:@"%@ %@",DIF,dateStr];
    }else{
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"有效期到 MM-dd"];
        
        NSString* dateStr = [formatter stringFromDate:curDate];
        
        
        strDate=dateStr;
    }
    
    return strDate;
    
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
