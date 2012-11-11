//
//  CustomNabBar.h
//  RussianToast
//
//  Created by Евгений Иванов on 10.11.12.
//
//

#import <UIKit/UIKit.h>

@interface CustomNabBar : UINavigationBar 

@end

@interface UINavigationBar (Utility)
-(void)setTitleLableWithTitle:(NSString*)title;
@end
