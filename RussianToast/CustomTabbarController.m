//
//  CustomTabbarController.m
//  Vedomosti
//
//  Created by Yuri Tsapkov on 06.02.10.
//  Copyright 2010 iD EAST. All rights reserved.
//

#import "CustomTabbarController.h"
#import <UIKit/UIKit.h>

#define NUM_TABS 2
#define TAB_BAR_TAG 111

@implementation CustomTabbarController

//----------------------------------------------------------------------------------------------------------------
- (void)dealloc
{
	for (int i = 0; i < 5; ++i)
		[tabIcon[i] release];
    
	[super dealloc];
}
//----------------------------------------------------------------------------------------------------------------
- (CustomTabbarController*)init 
{
	if (self = [super init]) 
    {
		// Ищем таббар.
		UITabBar *tabBar = nil;
		for (UIView *view in self.view.subviews) 
        {
			if ([view isKindOfClass:[UITabBar class]])
				tabBar = (UITabBar *)view;
		}
		
//		// Закрываем его белым фоном.		
//		UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, tabBar.frame.size.width, tabBar.frame.size.height)] autorelease];
//		lbl.backgroundColor = [UIColor whiteColor];
//		[lbl setTag:TAB_BAR_TAG];
//		[tabBar addSubview:lbl];
        
//        UIView *backView = [[[UIView alloc] initWithFrame:tabBar.bounds] autorelease];
//        backView.backgroundColor = RGB_Color(108.0f, 72.0f, 24.0f, 1.0f);
//        [tabBar addSubview:backView];
		
		// Загружаем картинки
		for (int i = 0; i < NUM_TABS; ++i) 
        {
			tabIcon[i] = [[UIImageView alloc] initWithFrame:CGRectMake(160.0f * i, 0.0f, 160.0f, 49.0f)];
			[tabIcon[i] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab%d.png",i]]];
            [tabIcon[i] setContentMode:UIViewContentModeScaleAspectFit];
			[tabBar addSubview:tabIcon[i]];
		}
		[tabIcon[0] setImage:[UIImage imageNamed:@"tab0_sel.png"]];
        
        [self hideNativeTabbarImages];
	}
	return self;
}
//----------------------------------------------------------------------------------------------------------------
- (void)hideNativeTabbarImages 
{
	// Выводим Custom контент на "поверхность".
	
	// Ищем таббар.
	UITabBar *tabBar = nil;
	for (UIView *view in self.view.subviews)
    {
		if ([view isKindOfClass:[UITabBar class]])
			tabBar = (UITabBar *)view;
	}
	
	// Подложку и градиент.
	[tabBar bringSubviewToFront:[tabBar viewWithTag:TAB_BAR_TAG]];
		
	// Картинки и надписи.
	for (int i = 0; i < NUM_TABS; ++i)
        [tabBar bringSubviewToFront:tabIcon[i]];
}
//----------------------------------------------------------------------------------------------------------------
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item 
{
	int segmentSelected = 0;
    segmentSelected = [tabBar.items indexOfObject:item];
    
	[tabIcon[segmentSelected] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab%d_sel.png", segmentSelected ]]];

	// Невыбранные табы возвращаем в обычное состояние
	for (int i = 0; i < NUM_TABS; ++i) 
    {
		if (i != segmentSelected)
			[tabIcon[i] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab%d.png", i ]]];
	}
}
//----------------------------------------------------------------------------------------------------------------

@end
