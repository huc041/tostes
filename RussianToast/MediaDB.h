//
//  MediaDB.h
//  RussianToast
//
//  Created by Евгений Иванов on 21.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MediaDB : NSManagedObject

@property (nonatomic, retain) NSNumber * idGroup;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * idSubGroup;
@property (nonatomic, retain) NSString * nameSubGroup;
@property (nonatomic, retain) NSString * fullText;
@property (nonatomic, retain) NSNumber * isFavorite;

@end
