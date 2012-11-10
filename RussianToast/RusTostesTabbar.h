//
//  RusTostesTabbar.h
//  RussianToast
//
//  Created by Евгений Иванов on 10.11.12.
//
//

#import <UIKit/UIKit.h>

@interface RusTostesTabbar : UITabBar

{

}

// Массив содержит элементы UIControl, которые ответственны, за соответствующие табы
@property (nonatomic, readonly, retain) NSArray *tabBarControls;
@property (nonatomic,retain) NSArray *arrayImages;

-(void)setImageForItemWithIndex:(int)index ForSelectState:(BOOL)isState;

@end
