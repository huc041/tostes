//
//  CustomTabbarController.h
//  Vedomosti
//
//  Created by Yuri Tsapkov on 06.02.10.
//  Copyright 2010 iD EAST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomTabbarController : UITabBarController 
{
	UIImageView *tabIcon[5];
}

- (void)hideNativeTabbarImages;

@end
