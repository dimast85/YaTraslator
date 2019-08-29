//
//  YTHistoryTableViewCell.h
//  YaTraslator
//
//  Created by Мартынов Дмитрий on 19/05/17.
//  Copyright © 2017 Мартынов Дмитрий. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTTranslator;
@interface YTHistoryTableViewCell : UITableViewCell

- (void) setTranslator:(YTTranslator*)translator;

+ (CGFloat) heightCellWithScreenWidth:(CGFloat)widthCell andTranslator:(YTTranslator*)translator;
@end
