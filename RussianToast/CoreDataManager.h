//
//  CoreDataManager.h
//  Copyright 2011 iD EAST. All rights reserved.
//

#import <Foundation/Foundation.h>

void checkAndSet(id object, NSString *propertyKey, id newValue);

@interface CoreDataManager : NSObject
{
	NSManagedObjectContext *__managedObjectContext;
	NSManagedObjectContext *__managedObjectContextForParsing;
	NSManagedObjectModel *__managedObjectModel;
	NSPersistentStoreCoordinator *__persistentStoreCoordinator;
}

@property(nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContextForParsing;
@property(nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataManager *)shared;

+ (id)newObject:(NSString *)entityName inMainContext:(BOOL)mainContext;
+ (id)anyObject:(NSString *)entityName inMainContext:(BOOL)mainContext;
+ (id)object:(NSString *)entityName withIdentifier:(id)identifier inMainContext:(BOOL)mainContext;
+ (id)object:(NSString *)entityName predicate:(NSPredicate *)predicate inMainContext:(BOOL)mainContext;
+(int)objectCount:(NSString *)entityName withPredicate:(NSPredicate *)predicate inMainContext:(BOOL)mainContext;
+ (NSArray *)objects:(NSString *)entityName withPredicate:(NSPredicate *)predicate inMainContext:(BOOL)mainContext;
+ (NSArray *)objectsSort:(NSString *)entityName withPredicate:(NSPredicate *)predicate WithSortKey:(NSString*)sortKey WithAscending:(BOOL)ascending inMainContext:(BOOL)mainContext;
+ (NSArray *)objects:(NSString *)entityName withPredicate:(NSPredicate *)predicate WithSortArray:(NSArray*)sortArray WithAscending:(BOOL)ascending inMainContext:(BOOL)mainContext;

// Main context
+ (void)lockMainContext;
+ (void)unlockMainContext;
+ (void)saveMainContext;
- (void)mainContextDidChanged:(NSNotification *)notification;

// Parsing context
+ (void)lockParsingContext;
+ (void)unlockParsingContext;
+ (void)saveParsingContext;
- (void)parsingContextDidChanged:(NSNotification *)notification;

- (void)clean;

@end
