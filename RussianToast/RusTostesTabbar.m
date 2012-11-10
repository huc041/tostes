//
//  RusTostesTabbar.m
//  RussianToast
//
//  Created by Евгений Иванов on 10.11.12.
//
//

#import "RusTostesTabbar.h"

#define SELECT_OFFSET_INDEX 2

@interface RusTostesTabbar ()

@property (nonatomic, retain) NSArray *tabBarControls;

@end

@implementation RusTostesTabbar

// Переопределил метод, чтобы таббар был прозрачным
- (void)drawRect:(CGRect)rect {
    
}

// Переопределил метод, чтобы размер таббара был 320x48. Сделано для того, чтобы нормально легла подлложка на таббар. Если это не сделать, то останется проем в 1 пиксель между таббаром и подложкой.
- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(320.0f, 48.0f);
}

-(NSArray*)arrayImages
{
    NSArray *arrayIm = [NSArray arrayWithObjects:
                        @"tab_main_unsel_160.png",
                        @"tab_fav_unsel_160.png",
                        @"tab_main_sel_160.png",
                        @"tab_fav_sel_160.png",nil];
    return arrayIm;
}

#pragma mark Getters
- (NSArray *)tabBarControls {
    
    if (!_tabBarControls) {
        
        // Получаем NSIndexSet всех subview, который наследуются от UIControl (кнопки на таббаре)
        NSIndexSet *tabBarControlsIndexes = [self.subviews indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [obj isKindOfClass:[UIControl class]];
        }];
        
        // Получаем массив этих subview (см. коммент выше)
        NSArray *controls = [self.subviews objectsAtIndexes:tabBarControlsIndexes];
        
        // Сортируем массив(на всякий случай) в порядке расположения элементов массива на tabbar
        controls = [controls sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *firstOriginX = [NSNumber numberWithFloat:[obj1 frame].origin.x];
            NSNumber *secondOriginX = [NSNumber numberWithFloat:[obj2 frame].origin.x];
            
            return [firstOriginX compare:secondOriginX];
        }];
        self.tabBarControls = controls;
    }
    
    // Возвращаем полученный массив
    return _tabBarControls;
}

- (void)setItems:(NSArray *)items animated:(BOOL)animated
{
    // Удаляем св-во image у UITabBarItem, чтобы не создавались лишние элементы
    [items makeObjectsPerformSelector:@selector(setImage:) withObject:nil];
    [super setItems:items animated:animated];
    
    // Поскольку элементы изменились, сбрасываем _tabBarControls
    self.tabBarControls = nil;
    
    for (UIControl *tabControl in self.tabBarControls) {
        
        // Забираем индекс текущего контрола
        NSUInteger index = [self.tabBarControls indexOfObject:tabControl];        
        // Проверяем индекс, ну так, чисто для мазы
        if (index != NSNotFound) {
            
            // Вводим имя картинки и ее сдвиг относительно центра
            NSString *imageName = [self.arrayImages objectAtIndex:index];
            CGFloat indent = 2.0f;
            
            // Кладем картинку на tabControl
            UIImageView *tabImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            tabImage.center = CGPointMake(tabControl.frame.size.width / 2, tabControl.frame.size.height / 2 - indent);
            [tabControl addSubview:tabImage];
            [tabImage release];
        }
    }

}

-(void)setImageForItemWithIndex:(int)index ForSelectState:(BOOL)isState
{
    UIControl *tabControl = [self.tabBarControls objectAtIndex:index];
    for (UIView*subView in tabControl.subviews) {
        if([subView isKindOfClass:[UIImageView class]])
        {
            int indexArrayImage = isState ? (index +SELECT_OFFSET_INDEX) : index;
            NSString *imageName = [self.arrayImages objectAtIndex:indexArrayImage];
            CGFloat indent = 2.0f;
            
            UIImageView *tabImage = (UIImageView*)subView;
            tabImage.center = CGPointMake(tabControl.frame.size.width / 2, tabControl.frame.size.height / 2 - indent);
            tabImage.image = [UIImage imageNamed:imageName];
        }
    }
}

@end
