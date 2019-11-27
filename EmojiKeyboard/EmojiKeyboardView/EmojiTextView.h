//
//  EmojiTextView.h
//  EmojiKeyboard
//
//  Created by zcf on 2019/11/23.
//  Copyright © 2019 zcf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiKeyboardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EmojiTextView : UITextView

// textView setting
/// default YES
@property (nonatomic, assign) BOOL isShowToolbar;
/// default [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]
@property (nonatomic, strong) UIColor *toolBarColor;
/// default [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]
@property (nonatomic, strong) UIColor *toolBarLineColor;
@property (nonatomic, strong) UIImage *emojiButtonNormalImage;
@property (nonatomic, strong) UIImage *emojiButtonSelectedImage;
// emoji keyboard setting
/// default 8
@property (nonatomic, assign) NSInteger rowCount;
/// default 3
@property (nonatomic, assign) NSInteger columnCount;

- (void)changeEmojiKeyboard:(BOOL)isEmoji;

@end

NS_ASSUME_NONNULL_END
