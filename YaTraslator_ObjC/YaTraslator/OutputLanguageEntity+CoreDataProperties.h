//
//  OutputLanguageEntity+CoreDataProperties.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 10/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "OutputLanguageEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface OutputLanguageEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSManagedObject *translator;

@end

NS_ASSUME_NONNULL_END
