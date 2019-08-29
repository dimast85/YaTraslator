//
//  SupportEntity+CoreDataProperties.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 16/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SupportEntity.h"
#import "CountryEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface SupportEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *inputCountryCode;
@property (nullable, nonatomic, retain) NSString *inputCountryName;
@property (nullable, nonatomic, retain) NSSet<CountryEntity *> *countries;

@end

@interface SupportEntity (CoreDataGeneratedAccessors)

- (void)addCountriesObject:(CountryEntity *)value;
- (void)removeCountriesObject:(CountryEntity *)value;
- (void)addCountries:(NSSet<CountryEntity *> *)values;
- (void)removeCountries:(NSSet<CountryEntity *> *)values;

@end

NS_ASSUME_NONNULL_END
