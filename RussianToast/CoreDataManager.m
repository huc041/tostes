//
//  CoreDataManager.m
//  Copyright 2011 iD EAST. All rights reserved.
//

#import "CoreDataManager.h"


static CoreDataManager *kCoreDataManager = nil;

void checkAndSet(id object, NSString *propertyKey, id newValue)
{
	// Если newValue является значением [NSNull null]
	if (newValue == [NSNull null])
		newValue = nil;
    @try
    {
        [object setValue:newValue forKey:propertyKey];
    }
    @catch(NSException *exception1)
    {
        NSLog(@"(!!!) [checkAndSet:] Exception \"%@\", reason: \"%@\"", [exception1 name], [exception1 reason]);
    }
    @catch(NSException *exception2)
    {
        NSLog(@"(!!!) [checkAndSet:] Exception (2) \"%@\", reason: \"%@\"", [exception2 name], [exception2 reason]);
    }
}


@implementation CoreDataManager

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectContextForParsing = __managedObjectContextForParsing;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

+ (CoreDataManager *)shared
{
	if (kCoreDataManager == nil)
	{
		kCoreDataManager = [[CoreDataManager alloc] init];
	}
	return kCoreDataManager;
}

- (id)init
{
    self = [super init];
    if (self)
	{
		[self persistentStoreCoordinator];
    }
    
    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	kCoreDataManager = nil;
	
	[__managedObjectContext release], __managedObjectContext = nil;
	[__managedObjectContextForParsing release], __managedObjectContextForParsing = nil;
	[__persistentStoreCoordinator release], __persistentStoreCoordinator = nil;
	[__managedObjectModel release], __managedObjectModel = nil;
	
	[super dealloc];
}

#pragma mark - Accessors

+ (id)newObject:(NSString *)entityName inMainContext:(BOOL)mainContext
{
	NSManagedObjectContext *context = mainContext ? [CoreDataManager shared].managedObjectContext : [CoreDataManager shared].managedObjectContextForParsing;

	Class EntityClass = NSClassFromString(entityName);
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	NSManagedObject *object = [[EntityClass alloc] initWithEntity:entity insertIntoManagedObjectContext:context];

	return (id)[object autorelease];
}

+ (id)anyObject:(NSString *)entityName inMainContext:(BOOL)mainContext
{
	NSManagedObjectContext *context = mainContext ? [CoreDataManager shared].managedObjectContext : [CoreDataManager shared].managedObjectContextForParsing;

	NSArray *result = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	request.predicate = nil;
	request.fetchLimit = 1;
	@try
	{
		result = [context executeFetchRequest:request error:nil];
	}
	@catch(NSException *exception)
	{
		DLog(@"(!!!) Exception \"%@\", reason: \"%@\"", [exception name], [exception reason]);
	}
	[request release];
	
	return [result objectAtIndex:0];
}

+ (id)object:(NSString *)entityName withIdentifier:(id)identifier inMainContext:(BOOL)mainContext
{
	NSManagedObjectContext *context = mainContext ? [CoreDataManager shared].managedObjectContext : [CoreDataManager shared].managedObjectContextForParsing;

	Class EntityClass = NSClassFromString(entityName);
	
	NSManagedObject *object = [[CoreDataManager object:entityName predicate:[NSPredicate predicateWithFormat:@"identifier == %@", identifier] inMainContext:mainContext] retain];
	if (object == nil)
	{
		NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
		object = [[EntityClass alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
		checkAndSet(object, @"identifier", identifier);
	}
	
	return [object autorelease];
}

+ (id)object:(NSString *)entityName predicate:(NSPredicate *)predicate inMainContext:(BOOL)mainContext
{
	NSArray *result = [CoreDataManager objects:entityName withPredicate:predicate inMainContext:mainContext];
	
	if ([result count] > 0)
	{
		return [result objectAtIndex:0];
	}
	return nil;
}
+(int)objectCount:(NSString *)entityName withPredicate:(NSPredicate *)predicate inMainContext:(BOOL)mainContext
{
	NSManagedObjectContext *context = mainContext ? [CoreDataManager shared].managedObjectContext : [CoreDataManager shared].managedObjectContextForParsing;
    
	NSArray *result = nil;
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	[request setPredicate:predicate];
	@try
	{
		result = [context executeFetchRequest:request error:nil];
	}
	@catch(NSException *exception)
	{
		DLog(@"(!!!) Exception \"%@\", reason: \"%@\"", [exception name], [exception reason]);
        DLog(@"Object: %@", entityName);
        DLog(@"Predicate: %@", predicate);
	}
	[request release];
	
	return [result count];
}

+ (NSArray *)objects:(NSString *)entityName withPredicate:(NSPredicate *)predicate inMainContext:(BOOL)mainContext
{
	NSManagedObjectContext *context = mainContext ? [CoreDataManager shared].managedObjectContext : [CoreDataManager shared].managedObjectContextForParsing;

	NSArray *result = nil;
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	[request setPredicate:predicate];
	@try
	{
		result = [context executeFetchRequest:request error:nil];
	}
	@catch(NSException *exception)
	{
		DLog(@"(!!!) Exception \"%@\", reason: \"%@\"", [exception name], [exception reason]);
//        DLog(@"Object: %@", entityName);
//        DLog(@"Predicate: %@", predicate);
	}
	[request release];
	
	return ([result count] == 0 ? nil : result);
}

+ (NSArray *)objectsSort:(NSString *)entityName withPredicate:(NSPredicate *)predicate WithSortKey:(NSString*)sortKey WithAscending:(BOOL)ascending inMainContext:(BOOL)mainContext
{
	NSArray *result = nil;
	
	NSManagedObjectContext *context = mainContext ? CoreDataManager.shared.managedObjectContext : CoreDataManager.shared.managedObjectContextForParsing;
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	[req setEntity:entity];
	[req setPredicate:predicate];
    [req setSortDescriptors:[NSArray arrayWithObjects:[[[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending] autorelease],nil]];
    
	@try
	{
		result = [context executeFetchRequest:req error:nil];
	}
	@catch(NSException *exception)
	{
        //		DLog(@"(!!!) Exception \"%@\", reason: \"%@\"", [exception name], [exception reason]);
	}
	[req release];
	
	return ([result count] == 0 ? nil : result);
}
+ (NSArray *)objects:(NSString *)entityName withPredicate:(NSPredicate *)predicate WithSortArray:(NSArray*)sortArray WithAscending:(BOOL)ascending inMainContext:(BOOL)mainContext
{
	NSArray *result = nil;
	
	NSManagedObjectContext *context = mainContext ? CoreDataManager.shared.managedObjectContext : CoreDataManager.shared.managedObjectContextForParsing;
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	[req setEntity:entity];
	[req setPredicate:predicate];
    [req setSortDescriptors:sortArray];
    
	@try
	{
		result = [context executeFetchRequest:req error:nil];
	}
	@catch(NSException *exception)
	{
        //		DLog(@"(!!!) Exception \"%@\", reason: \"%@\"", [exception name], [exception reason]);
	}
	[req release];
	
	return ([result count] == 0 ? nil : result);
}

#pragma mark - MainContext

+ (void)lockMainContext
{
	[[CoreDataManager shared].managedObjectContext lock];
}

+ (void)unlockMainContext
{
	[[CoreDataManager shared].managedObjectContext unlock];
}

+ (void)saveMainContext
{
	NSManagedObjectContext *context = [CoreDataManager shared].managedObjectContext;

    NSError *error = nil;
    if (context != nil)
    {
        if ([context hasChanges] && ![context save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)mainContextDidChanged:(NSNotification *)notification
{
    @synchronized(__managedObjectContextForParsing)
    {
        [__managedObjectContextForParsing lock];
        [__managedObjectContextForParsing mergeChangesFromContextDidSaveNotification:notification];
        [__managedObjectContextForParsing unlock];
    }
}

#pragma mark - ParsingContext

+ (void)lockParsingContext
{
	[[CoreDataManager shared].managedObjectContextForParsing lock];
}

+ (void)unlockParsingContext
{
	[[CoreDataManager shared].managedObjectContextForParsing unlock];
}

+ (void)saveParsingContext
{
	NSManagedObjectContext *context = [CoreDataManager shared].managedObjectContextForParsing;
	
    NSError *error = nil;
    if (context != nil)
    {
        if ([context hasChanges] && ![context save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)mergeOnMainThread:(NSNotification *)notification
{
	[__managedObjectContext lock];
	[__managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
	[__managedObjectContext unlock];
    
    if (YES) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kContextDidChange" object:nil userInfo:nil];
    }
}

- (void)parsingContextDidChanged:(NSNotification *)notification
{
	[self performSelectorOnMainThread:@selector(mergeOnMainThread:) withObject:notification waitUntilDone:NO];
}

#pragma mark - Actions

- (void)clean
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[__managedObjectContext release], __managedObjectContext = nil;
	[__managedObjectContextForParsing release], __managedObjectContextForParsing = nil;
	[__persistentStoreCoordinator release], __persistentStoreCoordinator = nil;
}


#pragma mark - Core Data Stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext == nil)
	{
		if (self.persistentStoreCoordinator != nil)
		{
			__managedObjectContext = [[NSManagedObjectContext alloc] init];
			[__managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
			
			// Откатывать изменения в случае конфликта
			__managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
			
			[[NSNotificationCenter defaultCenter] addObserver:self
													 selector:@selector(mainContextDidChanged:)
														 name:NSManagedObjectContextDidSaveNotification
													   object:__managedObjectContext];
		}
    }
    return __managedObjectContext;
}

- (NSManagedObjectContext *)managedObjectContextForParsing
{
    if (__managedObjectContextForParsing == nil)
	{
		if (self.persistentStoreCoordinator != nil)
		{
			__managedObjectContextForParsing = [[NSManagedObjectContext alloc] init];
			[__managedObjectContextForParsing setPersistentStoreCoordinator:self.persistentStoreCoordinator];

			// Перезаписывать изменения в случае конфликта
			__managedObjectContextForParsing.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
			
			[[NSNotificationCenter defaultCenter] addObserver:self
													 selector:@selector(parsingContextDidChanged:)
														 name:NSManagedObjectContextDidSaveNotification
													   object:__managedObjectContextForParsing];
		}
    }
    return __managedObjectContextForParsing;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel == nil)
	{
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RussianToast" withExtension:@"momd"];
		__managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
	}
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	if (__persistentStoreCoordinator == nil)
	{
		NSFileManager *fileManager = [NSFileManager defaultManager];
        
        
        NSString *pathSTR = (NSString*)[APP_DELEGATE applicationDocumentsDirectory];
        NSLog(@"pathSTR - %@",pathSTR);

		NSURL *storeUrl = [NSURL fileURLWithPath: [pathSTR stringByAppendingPathComponent: @"RussianToast.sqlite"]];
		
		NSError *error = nil;
		__persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
		
		BOOL isDBNotExistOrDBStructureChanged = ((![fileManager fileExistsAtPath:storeUrl.path]) || (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]));
		if (isDBNotExistOrDBStructureChanged)
		{
			DLog(@"(!) Error opening the database. Creating new one...");
			
			//delete the sqlite file and try again
			if ([fileManager fileExistsAtPath:storeUrl.path])
			{
				UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Структура БД изменилась.\nВся закешированная информация будет стерта." message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
				[alert show];
				
				[fileManager removeItemAtPath:storeUrl.path error:nil];
				
				[NSUserDefaults resetStandardUserDefaults];
			}
			
			if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error])
			{
				DLog(@"(!) Unresolved error %@", error);
				abort();
			}
		}
	}
	
	return __persistentStoreCoordinator;
}

@end
