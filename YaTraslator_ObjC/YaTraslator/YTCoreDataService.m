//
//  YTCoreDataService.m
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 07/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import "YTCoreDataService.h"

#import "YTSupportLanguage.h"
#import "YTCountry.h"
#import "YTLanguage.h"

#import "SupportEntity.h"
#import "SupportEntity+CoreDataProperties.h"

#import "CountryEntity.h"
#import "CountryEntity+CoreDataProperties.h"

#import "TranslatorEntity+CoreDataProperties.h"
#import "LanguageEntity+CoreDataProperties.h"
#import "InputLanguageEntity+CoreDataProperties.h"
#import "OutputLanguageEntity+CoreDataProperties.h"
#import "LanguageEntity+CoreDataProperties.h"


static NSString *const Support_Entity = @"SupportEntity";
static NSString *const Country_Entity = @"CountryEntity";
static NSString *const Translator_Entity = @"TranslatorEntity";
static NSString *const InputLanguage_Entity = @"InputLanguageEntity";
static NSString *const OutputLanguage_Entity = @"OutputLanguageEntity";



@implementation YTCoreDataService
#pragma mark - Save
-(void)saveSupportLanguage:(YTSupportLanguage *)support {
    SupportEntity *supportEntity = [NSEntityDescription insertNewObjectForEntityForName:Support_Entity inManagedObjectContext:self.managedObjectContext];
    [supportEntity setInputCountryCode:support.inputCountry.code];
    [supportEntity setInputCountryName:support.inputCountry.name];
    
    for (YTCountry *country in support.outputCountries) {
        CountryEntity *countryEntity = [NSEntityDescription insertNewObjectForEntityForName:Country_Entity inManagedObjectContext:self.managedObjectContext];
        [countryEntity setCode:country.code];
        [countryEntity setName:country.name];
        [supportEntity addCountriesObject:countryEntity];
    }
}



- (void)saveSupportLanguages:(NSArray<YTSupportLanguage *> *)supports {
    [self removeAllSupportLanguges];
    
    for (YTSupportLanguage *support in supports) {
        [self saveSupportLanguage:support];
    }
    
    [self.managedObjectContext save:nil];
}



-(void)saveTranslator:(YTTranslator *)translator {
    if ([translator.inputLanguage.text isEqualToString:translator.outputLanguage.text]) {
        return;
    }
    
    if (translator.status == YTTranslatorStatusHistory) {
         TranslatorEntity *historyTranslatorEntity = [self searchTranslator:translator];
        if (historyTranslatorEntity) {
            return;
        }
    }
    
    
    // Remove All Active
    if (translator.status == YTTranslatorStatusActive) {
        NSArray *result = [self searchTranslateEntityWithStatus:translator.status];
        for (TranslatorEntity *trEntity in result) {
            [self.managedObjectContext deleteObject:trEntity];
        }
    }
    
    
    // Значения нет, Создаем Translator
    TranslatorEntity *translatorEntity = [NSEntityDescription insertNewObjectForEntityForName:Translator_Entity inManagedObjectContext:self.managedObjectContext];
    [translatorEntity setStatus:@(translator.status)];
    
    
    
    // Input
    InputLanguageEntity *inputEntity = [NSEntityDescription insertNewObjectForEntityForName:InputLanguage_Entity inManagedObjectContext:self.managedObjectContext];
    [inputEntity setText:translator.inputLanguage.text];
    
    CountryEntity *countryEntity = [NSEntityDescription insertNewObjectForEntityForName:Country_Entity inManagedObjectContext:self.managedObjectContext];
    [countryEntity setCode:translator.inputLanguage.code];
    [countryEntity setName:translator.inputLanguage.name];
    
    [inputEntity setCountry:countryEntity];
    [translatorEntity setInputLanguage:inputEntity];
    
    
    
    // Output
    OutputLanguageEntity *outputEntity = [NSEntityDescription insertNewObjectForEntityForName:OutputLanguage_Entity inManagedObjectContext:self.managedObjectContext];
    [outputEntity setText:translator.outputLanguage.text];
    
    CountryEntity *countryOutEntity = [NSEntityDescription insertNewObjectForEntityForName:Country_Entity inManagedObjectContext:self.managedObjectContext];
    [countryOutEntity setCode:translator.outputLanguage.code];
    [countryOutEntity setName:translator.outputLanguage.name];
    [outputEntity setCountry:countryOutEntity];
    [translatorEntity setOutputLanguage:outputEntity];
    
    
    [translatorEntity.managedObjectContext save:nil];
}


#pragma mark - Getter
-(NSArray<YTCountry *> *)getInputCountries {
    NSEntityDescription *description = [NSEntityDescription entityForName:Support_Entity inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:description];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error || result.count == 0) {
        return @[];
    }
    
    
    NSMutableArray *mutableCountries = [NSMutableArray array];
    for (SupportEntity *supportEntity in result) {
        YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:supportEntity.inputCountryCode andCountryName:supportEntity.inputCountryName];
        [mutableCountries addObject: inputCountry];
    }
    
    
    return [mutableCountries copy];
}



-(NSArray<YTCountry *> *)getOutputCountriesWithInputCountryCode:(NSString *)inputCountryCode {
    NSEntityDescription *description = [NSEntityDescription entityForName:Support_Entity inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inputCountryCode == %@", inputCountryCode];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray<SupportEntity*> *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error || result.count == 0) {
        return @[];
    }
    
    
    NSMutableArray *mutableCountries = [NSMutableArray array];
    SupportEntity *supportEntity = result.firstObject;
    for (CountryEntity *countryEntity in supportEntity.countries) {
        YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:countryEntity.code andCountryName:countryEntity.name];
        [mutableCountries addObject: outputCountry];
    }

    return [mutableCountries copy];
}


-(NSArray<YTTranslator *> *)translatorsWithStatus:(YTTranslatorStatus)status {
    NSArray *result = [self searchTranslateEntityWithStatus:status];
    
    NSMutableArray *mutable = [NSMutableArray array];
    for (TranslatorEntity *translatorEntity in result) {
        YTTranslator *translator = [self translatorWithTranslatorEntity:translatorEntity];
        [mutable addObject:translator];
    }

    return [mutable copy];
}

-(YTTranslator *)translatorDefault {
    NSArray *inputCountries = [self getInputCountries];
    if(inputCountries.count == 0) {
        return nil;
    }
    NSString *inputCode = @"ru";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code == %@", inputCode];
    YTCountry *inputCountry = [[inputCountries filteredArrayUsingPredicate:predicate] firstObject];
    
    NSArray *outputCountries = [self getOutputCountriesWithInputCountryCode:inputCountry.code];
    NSString *outputCode = @"en";
    predicate = [NSPredicate predicateWithFormat:@"code == %@", outputCode];
    YTCountry *outputCountry = [[outputCountries filteredArrayUsingPredicate:predicate] firstObject];
    
    
    YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
    [translator setInputText:@"Привет"];
    return translator;
}



#pragma mark - Entity -> Object
- (YTTranslator*)translatorWithTranslatorEntity:(TranslatorEntity*)translatorEntity {
    YTCountry *inputCountry = [[YTCountry alloc] initCountryCode:translatorEntity.inputLanguage.country.code andCountryName:translatorEntity.inputLanguage.country.name];
    YTCountry *outputCountry = [[YTCountry alloc] initCountryCode:translatorEntity.outputLanguage.country.code andCountryName:translatorEntity.outputLanguage.country.name];
    YTTranslator *translator = [[YTTranslator alloc] initInputCountry:inputCountry andOutputCountry:outputCountry];
    [translator updateStatus:[translatorEntity.status integerValue]];
    
    [translator.inputLanguage setText:translatorEntity.inputLanguage.text];
    [translator.outputLanguage setText:translatorEntity.outputLanguage.text];
    
    return translator;
}



#pragma mark - Search
-(TranslatorEntity*)searchTranslator:(YTTranslator*)translator {
    NSEntityDescription *description = [NSEntityDescription entityForName:Translator_Entity inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"inputLanguage.text == %@ AND inputLanguage.country.code == %@ AND status == %i", translator.inputLanguage.text, translator.inputLanguage.code, translator.status];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        return nil;
    }
    
    return result.count > 0 ? result.firstObject : nil;
}

- (NSArray <TranslatorEntity*>*)searchTranslateEntityWithStatus:(YTTranslatorStatus)status {
    NSEntityDescription *description = [NSEntityDescription entityForName:Translator_Entity inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == %i", status];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        return @[];
    }
    
    return result;
}


#pragma mark - Remove
- (void) removeAll {
    NSEntityDescription *description = [NSEntityDescription entityForName:Translator_Entity inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:description];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (NSManagedObject *obj in result) {
        [self.managedObjectContext deleteObject:obj];
    }
    
    
    [self removeAllSupportLanguges];
}

- (void)removeAllHistory {
    NSEntityDescription *description = [NSEntityDescription entityForName:Translator_Entity inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:description];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == %i", YTTranslatorStatusHistory];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (NSManagedObject *obj in result) {
        [self.managedObjectContext deleteObject:obj];
    }

}

- (void) removeAllSupportLanguges {
    NSEntityDescription *description = [NSEntityDescription entityForName:Support_Entity inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:description];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    for (NSManagedObject *obj in result) {
        [self.managedObjectContext deleteObject:obj];
    }
}


@end
