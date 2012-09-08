//
//  GroupDB.h
//  RussianToast
//
//  Created by Евгений Иванов on 08.09.12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MediaDB;

@interface GroupDB : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * idParent;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *media;
@end

@interface GroupDB (CoreDataGeneratedAccessors)

- (void)addMediaObject:(MediaDB *)value;
- (void)removeMediaObject:(MediaDB *)value;
- (void)addMedia:(NSSet *)values;
- (void)removeMedia:(NSSet *)values;

@end
