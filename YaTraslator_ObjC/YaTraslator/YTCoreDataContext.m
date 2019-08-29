//
//  YTCoreDataContext.m
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 07/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import "YTCoreDataContext.h"
#import "YTCoreDataModel.h"

@implementation YTCoreDataContext
-(NSManagedObjectContext *)managedObjectContext {
    return [[YTCoreDataModel sharedManager] managedObjectContext];
}
@end
