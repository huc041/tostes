//
//  MediaDB.h
//  RussianToast
//
//  Created by Евгений Иванов on 16.11.12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GroupDB;

@interface MediaDB : NSManagedObject

@property (nonatomic, retain) NSString * fullText;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * idGroup;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nameGroup;
@property (nonatomic, retain) NSString * nameSubGroup;
@property (nonatomic, retain) NSString * firstLiteral;
@property (nonatomic, retain) NSSet *group;
@end

@interface MediaDB (CoreDataGeneratedAccessors)

- (void)addGroupObject:(GroupDB *)value;
- (void)removeGroupObject:(GroupDB *)value;
- (void)addGroup:(NSSet *)values;
- (void)removeGroup:(NSSet *)values;
@end
