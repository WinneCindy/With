
//
//  storyDetailTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/7/31.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "storyDetailTableViewCell.h"
#import "commentTableViewCell.h"
#import "commentModel.h"
@implementation storyDetailTableViewCell
{
    UITableView *comentTable;
    NSMutableArray *modelArray;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        modelArray = [NSMutableArray array];
        [self setUp];
    }
    return self;
}

-(void)setUp
{
    comentTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    comentTable.dataSource = self;
    comentTable.delegate = self;
    [comentTable setBackgroundColor:getUIColor(Color_black)];
    [self.contentView addSubview:comentTable];
    [comentTable registerClass:[commentTableViewCell class] forCellReuseIdentifier:@"comment"];
    [comentTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    comentTable.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .heightIs(200);

    
}


-(void)setModel:(storyDetailModel *)model
{
    _model = model;
    
    for (NSDictionary *dic in model.commentList) {
        commentModel *model = [commentModel new];
        model.userName = [dic stringForKey:@"name"];
        model.userHead = [dic stringForKey:@"avatar"];
        model.commentContent = [dic stringForKey:@"content"];
        model.beCommentUserName = [dic stringForKey:@"p_user_name"];
        model.pId = [dic stringForKey:@"pid"];
        [modelArray addObject:model];
    }
    
    [comentTable reloadData];
    
    [self setupAutoHeightWithBottomView:comentTable bottomMargin:10];

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [modelArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commentModel *model= modelArray[indexPath.row];
    CGFloat height = [comentTable cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[commentTableViewCell class] contentViewWidth:SCREEN_WIDTH];
    return height;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Class currentClass = [commentTableViewCell class];
    commentTableViewCell *cell = nil;
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    [cell setBackgroundColor:getUIColor(Color_black)];
    cell.model = modelArray[indexPath.row];
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
