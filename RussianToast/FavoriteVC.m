//
//  FavoriteVC.m
//  RussianToast
//
//  Created by Евгений Иванов on 22.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoriteVC.h"

@interface FavoriteVC ()

@end

@implementation FavoriteVC

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    
    self.navigationController.navigationBar.topItem.title = @"Избранное";

	// Do any additional setup after loading the view.
}

@end
