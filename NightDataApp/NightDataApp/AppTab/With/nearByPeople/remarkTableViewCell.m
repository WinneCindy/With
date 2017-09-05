//
//  remarkTableViewCell.m
//  NightDataApp
//
//  Created by 黄梦炜 on 2017/8/17.
//  Copyright © 2017年 黄梦炜. All rights reserved.
//

#import "remarkTableViewCell.h"

@implementation remarkTableViewCell
{
    UILabel *worning;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *contentView = self.contentView;
        UIImageView *backLine = [UIImageView new];
        [contentView addSubview:backLine];
        backLine.sd_layout
        .leftSpaceToView(contentView, 12)
        .topSpaceToView(contentView, 12)
        .rightSpaceToView(contentView, 12)
        .bottomSpaceToView(contentView, 12);
        [backLine setImage:[UIImage imageNamed:@"textViewLine"]];
        
        UITextView *textView = [UITextView new];
        [contentView addSubview:textView];
        textView.sd_layout
        .leftSpaceToView(contentView, 24)
        .topSpaceToView(contentView, 20)
        .rightSpaceToView(contentView, 24)
        .bottomSpaceToView(contentView, 20);
        [textView setBackgroundColor:Color_blackBack];
        [textView setTextColor:[UIColor whiteColor]];
        textView.delegate = self;
        [textView setReturnKeyType:UIReturnKeyDone];
        [textView setTintColor:Color_white];
        
        
        worning = [UILabel new];
        [contentView addSubview:worning];
        worning.sd_layout
        .leftSpaceToView(contentView, 24)
        .topSpaceToView(contentView, 24)
        .rightSpaceToView(contentView, 24)
        .heightIs(20);
        [worning setTextColor:Color_white];
        [worning setText:@"说点什么..."];
        [worning setFont:[UIFont systemFontOfSize:13]];
        
        
    }
    return self;
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    

    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [worning setHidden:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0) {
        [worning setHidden:YES];
    } else {
        [worning setHidden:NO];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
