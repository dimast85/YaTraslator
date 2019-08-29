//
//  TranslatorEntity.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 11/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BaseEntity, InputLanguageEntity, OutputLanguageEntity;

NS_ASSUME_NONNULL_BEGIN

@interface TranslatorEntity : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "TranslatorEntity+CoreDataProperties.h"
