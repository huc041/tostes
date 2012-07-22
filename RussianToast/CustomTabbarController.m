//
//  CustomTabbarController.m
//  Vedomosti
//
//  Created by Yuri Tsapkov on 06.02.10.
//  Copyright 2010 iD EAST. All rights reserved.
//

#import "CustomTabbarController.h"
#import <UIKit/UIKit.h>


@implementation CustomTabbarController

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
		
		// Закрываем его белым фоном.		
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tabBar.frame.size.width, tabBar.frame.size.height)];
		[lbl setTag:111];
		[tabBar addSubview:lbl];
		[lbl release];
		
		// Загружаем картинки
		for (int i = 0; i < 5; ++i) 
        {
			tabIcon[i] = [[UIImageView alloc] initWithFrame:CGRectMake(64.0f * i, 0.0f, 64.0f, 49.0f)];
			[tabIcon[i] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab%d.png", i + 1]]];
            [tabIcon[i] setContentMode:UIViewContentModeScaleAspectFit];
			[tabBar addSubview:tabIcon[i]];
		}
		[tabIcon[0] setImage:[UIImage imageNamed:@"tab1_.png"]];
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait)
	{
		return YES;
	}
	return NO;
}

- (void)hideNativeTabbarImages 
{
	// Выводим Custom контент на "поверхность".
	
	// Ищем таббар.
	UITabBar *tabBar = nil;
	for (UIView *view in self.view.subviews) {
		if ([view isKindOfClass:[UITabBar class]])
			tabBar = (UITabBar *)view;
	}
	
	// Подложку и градиент.
	[tabBar bringSubviewToFront:[tabBar viewWithTag:111]];
		
	// Картинки и надписи.
	for (int i = 0; i < 5; ++i) 
    {
        [tabBar bringSubviewToFront:tabIcon[i]];
	}
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item 
{
	int segmentSelected = 0;
    
    segmentSelected = [tabBar.items indexOfObject:item];  
    
    if(segmentSelected == 0)
    {
        UINavigationController *navVC = (UINavigationController*)[self.viewControllers objectAtIndex:0];
        
        if(navVC)
            [navVC popToRootViewControllerAnimated:YES];
    }

	[tabIcon[segmentSelected] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab%d_.png", segmentSelected + 1]]];

	// Невыбранные табы возвращаем в обычное состояние
	for (int i = 0; i < 5; ++i) 
    {
		if (i != segmentSelected) 
        {
			[tabIcon[i] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tab%d.png", i + 1]]];
		}
	}	
}

- (void)dealloc 
{
	for (int i = 0; i < 5; ++i) 
    {
		[tabIcon[i] release];
	}
	[super dealloc];
}

@end
