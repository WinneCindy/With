//
//  JYHTabBarItem.m
//  CongestionOfGod
//
//  Created by 黄 梦炜 on 15/5/21.
//  Copyright (c) 2015年 黄 梦炜. All rights reserved.
//

#import "JYHTabBarItem.h"
#import "RDVTabBarItem.h"

@implementation JYHTabBarItem

- (instancetype)initWithTabBar:(RDVTabBar*)tabBar
                  forItemIndex:(NSUInteger)itemIndex {
    
    if(self = [super init]) {
        [self installTheButton:tabBar forItemIndex:itemIndex];
    }

    
    return self;
}

- (void)installTheButton:(RDVTabBar*)tabBar
            forItemIndex:(NSUInteger)itemIndex  {
    
    NSString *reason = [NSString stringWithFormat:@"The selected index %d is out of bounds for tabBar.items = %d",
                        (int)itemIndex, (int)tabBar.items.count];
    
    NSAssert((tabBar.items.count -1 >= itemIndex), reason);
    
    if(tabBar.items.count > itemIndex) {
        
        int intSize = 60;
        
        CGRect myFrame = CGRectMake(0.0, 0.0, intSize, intSize);

        //1- disable the button underneath BROptionsButton
        [[tabBar.items objectAtIndex:itemIndex] setEnabled:NO];
        
        // Get Button Center;
        RDVTabBarItem *item = [tabBar.items objectAtIndex:itemIndex];
        
//        UIView *view = [item valueForKey:@"view"];
        
        CGPoint buttonCenter = item.center;
        
        if (intSize - item.frame.size.height > 0) {
            buttonCenter.y -= (intSize - item.frame.size.height) / 2;
        }
        
        self.frame = myFrame;
        
        self.center = buttonCenter;
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                
//        self.backgroundColor = [UIColor blackColor];
//        self.layer.cornerRadius = 6;
//        self.clipsToBounds = YES;
        self.layer.zPosition = MAXFLOAT;
        [tabBar addSubview:self];
        
//        self.translatesAutoresizingMaskIntoConstraints = YES;
    }
}

@end
