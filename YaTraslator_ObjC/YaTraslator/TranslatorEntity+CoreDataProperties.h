//
//  TranslatorEntity+CoreDataProperties.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 25/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TranslatorEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface TranslatorEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) InputLanguageEntity *inputLanguage;
@property (nullable, nonatomic, retain) OutputLanguageEntity *outputLanguage;

@end

NS_ASSUME_NONNULL_END
