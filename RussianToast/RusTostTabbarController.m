//
//  RusTostTabbarController.m
//  RussianToast
//
//  Created by Евгений Иванов on 10.11.12.
//
//

#import "RusTostTabbarController.h"

@interface RusTostTabbarController ()

@end

@implementation RusTostTabbarController

#pragma mark Getters
- (RusTostesTabbar *)tabBar {
    return (RusTostesTabbar *)[super tabBar];
}

#pragma mark Setters
- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    // Переменная показывает, произошел ли повторный выбор текущего UIViewController
    BOOL selectedViewControllerIsCurrent = [selectedViewController isEqual:self.selectedViewController];
    if(!selectedViewControllerIsCurrent)
    {        
        if (self.selectedIndex != NSNotFound) {
            
            // Убираем выделение с предыдущего таба
            [self.tabBar setImageForItemWithIndex:self.selectedIndex ForSelectState:NO];

        }
        // снимаем выделение со старого таба
        
        // Назначаем новый selectedViewContrller
        [super setSelectedViewController:selectedViewController];
        
        // выделяем новый таб
        [self.tabBar setImageForItemWithIndex:self.selectedIndex ForSelectState:YES];
    }
}

@end
