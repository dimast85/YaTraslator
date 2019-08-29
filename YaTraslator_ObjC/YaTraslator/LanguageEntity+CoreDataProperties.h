//
//  LanguageEntity+CoreDataProperties.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 10/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LanguageEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface LanguageEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) CountryEntity *country;

@end

NS_ASSUME_NONNULL_END
