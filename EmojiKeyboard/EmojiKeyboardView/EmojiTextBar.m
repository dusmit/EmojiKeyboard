//
//  EmojiTextBar.m
//  EmojiKeyboard
//
//  Created by dusmit on 2019/11/27.
//  Copyright © 2019 zcf. All rights reserved.
//

#import "EmojiTextBar.h"
#import "EmojiKeyboardView.h"
#import "EmojiHeader.h"

@interface EmojiTextBar () <EmojiKeyboardDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *emojiButton;
@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, strong) EmojiKeyboardView *emojiView;

@end

@implementation EmojiTextBar

- (EmojiKeyboardView *)emojiView {
    if (!_emojiView) {
        
        _emojiView = [[EmojiKeyboardView alloc]init];
        _emojiView.delegate = self;
    }
    return _emojiView;
}

- (UITextView *)textView {
    if (!_textView) {
        
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(8, 5, KProjectScreenWidth-30-8*3, self.frame.size.height-5*2)];
        _textView.layer.cornerRadius = 6;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _textView.layer.masksToBounds = true;
        [self addSubview:_textView];
    }
    return _textView;
}

- (UIButton *)emojiButton {
    if (!_emojiButton) {
        
        UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [emojiButton setFrame:CGRectMake(KProjectScreenWidth-30-8, 7.5, 30, 30)];
        [emojiButton setImage:[UIImage imageNamed:@"emoji_toggle"] forState:UIControlStateNormal];
        [emojiButton setImage:[UIImage imageNamed:@"emoji_keyboard"] forState:UIControlStateSelected];
        [emojiButton addTarget:self action:@selector(changeKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        _emojiButton = emojiButton;
    }
    return _emojiButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.originalFrame = frame;
        self.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
        [self addSubview:self.emojiButton];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)changeKeyboard:(UIButton *)button {
    
    button.selected = !button.isSelected;
    [self changeEmojiKeyboard:button.isSelected];
}

- (void)changeEmojiKeyboard:(BOOL)isEmoji {
    
    if (isEmoji) {
        self.textView.inputView = self.emojiView;
    }else {
        self.textView.inputView = nil;
    }
    [self.textView reloadInputViews];
}

- (void)show {
    
    [self.textView becomeFirstResponder];
}


#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    
    if (!self.superview) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect inputViewFrame = self.frame;
    inputViewFrame.origin.y = CGRectGetHeight(self.superview.bounds) - CGRectGetHeight(keyboardFrame) - self.frame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        self.frame = inputViewFrame;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (!self.superview) {
        return;
    }
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.frame = self.originalFrame;
    }];
}

#pragma mark -EmojiKeyboardDelegate
- (void)clickKeyboard:(NSString *)emoji {
    
    if (!emoji) return;
    self.textView.text = [self.textView.text stringByReplacingCharactersInRange:self.textView.selectedRange withString:emoji];
    self.textView.selectedRange = NSMakeRange(self.textView.selectedRange.location+emoji.length, 0);
}

- (void)deleteKeyboard {
    
    NSRange selectedRange = self.textView.selectedRange;
    if (selectedRange.location == 0 && selectedRange.length == 0) {
        return;
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    if (selectedRange.length > 0) {
        [attributedText deleteCharactersInRange:selectedRange];
        self.textView.attributedText = attributedText;
        self.textView.selectedRange = NSMakeRange(selectedRange.location, 0);
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
        self.textView.attributedText = attributedText;
        self.textView.selectedRange = NSMakeRange(selectedRange.location - deleteCharactersCount, 0);
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
