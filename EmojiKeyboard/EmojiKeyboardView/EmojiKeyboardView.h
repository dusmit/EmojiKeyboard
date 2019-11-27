//
//  EmojiKeyboardView.h
//  EmojiKeyboard
//
//  Created by zcf on 2019/11/22.
//  Copyright © 2019 zcf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EmojiKeyboardDelegate <NSObject>

/// select emoji from keyboard
- (void)clickKeyboard:(NSString *)emoji;
/// delete
- (void)deleteKeyboard;

@end

@interface EmojiKeyboardView : UIView {
    
    NSArray *_emojiArray;
}

@property (nonatomic, weak) id<EmojiKeyboardDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger rowCount;  // default 8
@property (nonatomic, assign) NSInteger columnCount;  // default 3
@property (nonatomic, assign) CGFloat emoji_x;

- (void)setEmojiArray:(NSArray *)emojiArray;

@end

NS_ASSUME_NONNULL_END
