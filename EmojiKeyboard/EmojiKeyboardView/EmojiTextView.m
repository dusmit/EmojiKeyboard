//
//  EmojiTextView.m
//  EmojiKeyboard
//
//  Created by zcf on 2019/11/23.
//  Copyright © 2019 zcf. All rights reserved.
//

#import "EmojiTextView.h"
#import "EmojiHeader.h"

@interface EmojiTextView () <EmojiKeyboardDelegate>

@property (nonatomic, strong) UIView *toolbar;
@property (nonatomic, strong) UIView *toolbarLine;
@property (nonatomic, strong) UIButton *emojiButton;
@property (nonatomic, strong) EmojiKeyboardView *emojiView;

@end

@implementation EmojiTextView

#pragma mark -Lazy
- (EmojiKeyboardView *)emojiView {
    if (!_emojiView) {
        
        _emojiView = [[EmojiKeyboardView alloc]init];
        _emojiView.delegate = self;
    }
    return _emojiView;
}

#pragma mark -init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIView *toolbar = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, KProjectScreenWidth, 45)];
        toolbar.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
        self.toolbar = toolbar;

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, toolbar.frame.size.height-0.5, KProjectScreenWidth, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        self.toolbarLine = lineView;
        [toolbar addSubview:lineView];

        UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [emojiButton setFrame:CGRectMake(KProjectScreenWidth-50, 7.5, 30, 30)];
        [emojiButton setImage:[UIImage imageNamed:@"emoji_toggle"] forState:UIControlStateNormal];
        [emojiButton setImage:[UIImage imageNamed:@"emoji_keyboard"] forState:UIControlStateSelected];
        [emojiButton addTarget:self action:@selector(changeKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        self.emojiButton = emojiButton;
        [toolbar addSubview:emojiButton];
        self.inputAccessoryView = toolbar;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditing) name:UITextViewTextDidEndEditingNotification object:nil];
    }
    return self;
}

#pragma mark -setting
- (void)setIsShowToolbar:(BOOL)isShowToolbar {
    
    if (!isShowToolbar) {
        self.inputAccessoryView = [UIView new];
    }
    _isShowToolbar = isShowToolbar;
}

- (void)setToolBarColor:(UIColor *)toolBarColor {
    
    self.toolbar.backgroundColor = toolBarColor;
    _toolBarColor = toolBarColor;
}

- (void)setToolBarLineColor:(UIColor *)toolBarLineColor {
    
    self.toolbarLine.backgroundColor = toolBarLineColor;
    _toolBarColor = toolBarLineColor;
}

- (void)setEmojiButtonNormalImage:(UIImage *)emojiButtonNormalImage {
    
    [self.emojiButton setImage:emojiButtonNormalImage forState:UIControlStateNormal];
    _emojiButtonNormalImage = emojiButtonNormalImage;
}

- (void)setEmojiButtonSelectedImage:(UIImage *)emojiButtonSelectedImage {
    
    [self.emojiButton setImage:emojiButtonSelectedImage forState:UIControlStateSelected];
    _emojiButtonSelectedImage = emojiButtonSelectedImage;
}

- (void)setRowCount:(NSInteger)rowCount {
    
    self.emojiView.rowCount = rowCount;
    _rowCount = rowCount;
}

- (void)setColumnCount:(NSInteger)columnCount {
    
    self.emojiView.columnCount = columnCount;
    _columnCount = columnCount;
}

#pragma mark -action
- (void)changeKeyboard:(UIButton *)button {
    
    button.selected = !button.isSelected;
    [self changeEmojiKeyboard:button.isSelected];
}

- (void)changeEmojiKeyboard:(BOOL)isEmoji {
    
    if (isEmoji) {
        self.inputView = self.emojiView;
    }else {
        self.inputView = nil;
    }
    [self reloadInputViews];
}

#pragma mark -Notification
- (void)didEndEditing {
    
    self.emojiButton.selected = false;
    self.inputView = nil;
}

#pragma mark -EmojiKeyboardDelegate
- (void)clickKeyboard:(NSString *)emoji {
    
    if (!emoji) return;
    self.text = [self.text stringByReplacingCharactersInRange:self.selectedRange withString:emoji];
    self.selectedRange = NSMakeRange(self.selectedRange.location+emoji.length, 0);
}

- (void)deleteKeyboard {
    
    NSRange selectedRange = self.selectedRange;
    if (selectedRange.location == 0 && selectedRange.length == 0) {
        return;
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    if (selectedRange.length > 0) {
        [attributedText deleteCharactersInRange:selectedRange];
        self.attributedText = attributedText;
        self.selectedRange = NSMakeRange(selectedRange.location, 0);
    } else {
        NSUInteger deleteCharactersCount = 1;
        
        // 下面这段正则匹配是用来匹配文本中的所有系统自带的 emoji 表情，以确认删除按钮将要删除的是否是 emoji。这个正则匹配可以匹配绝大部分的 emoji，得到该 emoji 的正确的 length 值；不过会将某些 combined emoji（如 👨‍👩‍👧‍👦 👨‍👩‍👧‍👦 👨‍👨‍👧‍👧），这种几个 emoji 拼在一起的 combined emoji 则会被匹配成几个个体，删除时会把 combine emoji 拆成个体。瑕不掩瑜，大部分情况下表现正确，至少也不会出现删除 emoji 时崩溃的问题了。
        NSString *emojiPattern1 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900-\\U0001F9FF]";
        NSString *emojiPattern2 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900–\\U0001F9FF]\\uFE0F";
        NSString *emojiPattern3 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900–\\U0001F9FF][\\U0001F3FB-\\U0001F3FF]";
        NSString *emojiPattern4 = @"[\\rU0001F1E6-\\U0001F1FF][\\U0001F1E6-\\U0001F1FF]";
        NSString *pattern = [[NSString alloc] initWithFormat:@"%@|%@|%@|%@", emojiPattern4, emojiPattern3, emojiPattern2, emojiPattern1];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:NULL];
        NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:attributedText.string options:kNilOptions range:NSMakeRange(0, attributedText.string.length)];
        for (NSTextCheckingResult *match in matches) {
            if (match.range.location + match.range.length == selectedRange.location) {
                deleteCharactersCount = match.range.length;
                break;
            }
        }
        
        [attributedText deleteCharactersInRange:NSMakeRange(selectedRange.location - deleteCharactersCount, deleteCharactersCount)];
        self.attributedText = attributedText;
        self.selectedRange = NSMakeRange(selectedRange.location - deleteCharactersCount, 0);
    }
}

#pragma mark -dealloc
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
