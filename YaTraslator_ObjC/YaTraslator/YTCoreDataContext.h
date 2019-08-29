//
//  YTCoreDataContext.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 07/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTCoreDataContext : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
