//
//  ViewController.m
//  EmojiKeyboard
//
//  Created by zcf on 2019/11/22.
//  Copyright © 2019 zcf. All rights reserved.
//

#import "ViewController.h"
#import "EmojiTextView.h"
#import "EmojiTextBar.h"

@interface ViewController () 

@property (nonatomic, strong) EmojiTextView *textView;
@property (nonatomic, strong) EmojiTextBar *textBar;
@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (EmojiTextView *)textView {
    if (!_textView) {
        
        _textView = [[EmojiTextView alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, 100)];
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0].CGColor;
        _textView.layer.cornerRadius = 5.0;
        _textView.layer.masksToBounds = true;
    }
    return _textView;
}

- (EmojiTextBar *)textBar {
    if (!_textBar) {
        
        _textBar = [[EmojiTextBar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
        [self.view addSubview:_textBar];
    }
    return _textBar;
}

- (UIButton *)button {
    if (!_button) {
        
        _button = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)/2.0, 150, 200, 30)];
        [_button setTitle:@"点我点我点我~" forState:UIControlStateNormal];
        [_button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonTouch) forControlEvents:UIControlEventTouchUpInside];
        
        _button.layer.borderWidth = 0.5;
        _button.layer.borderColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0].CGColor;
        _button.layer.cornerRadius = 5.0;
        _button.layer.masksToBounds = true;
    }
    return _button;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.textView];
    [self.view addSubview:self.button];
}

- (void)buttonTouch {
    
    [self.textBar show];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:true];
}



@end
