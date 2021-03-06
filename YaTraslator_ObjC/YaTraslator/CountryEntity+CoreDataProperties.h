//
//  CountryEntity+CoreDataProperties.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 10/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CountryEntity.h"
#import "LanguageEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface CountryEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *code;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) SupportEntity *support;
@property (nullable, nonatomic, retain) LanguageEntity *language;

@end

NS_ASSUME_NONNULL_END
