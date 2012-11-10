//
//  RusTostTabbarController.h
//  RussianToast
//
//  Created by Евгений Иванов on 10.11.12.
//
//

#import <UIKit/UIKit.h>
#import "RusTostesTabbar.h"

@interface RusTostTabbarController : UITabBarController <UITabBarDelegate>

@property (nonatomic, readonly) RusTostesTabbar *tabBar;

@end
