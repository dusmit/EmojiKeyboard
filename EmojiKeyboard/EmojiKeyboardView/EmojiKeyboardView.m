//
//  EmojiKeyboardView.m
//  EmojiKeyboard
//
//  Created by zcf on 2019/11/22.
//  Copyright © 2019 zcf. All rights reserved.
//

#import "EmojiKeyboardView.h"
#import "EmojiHeader.h"

@interface EmojiKeyboardView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *emojiArray;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIView *pageControlView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation EmojiKeyboardView

#pragma mark -init
- (instancetype)init {
    if (self = [super init]) {
        
        _rowCount = 8;
        _columnCount = 3;
        _emoji_x = 10;
        [self viewLayout];
    }
    return self;
}

#pragma mark -source data
- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSArray alloc]init];
    }
    return _dataSource;
}

- (NSArray *)emojiArray {
    if (!_emojiArray) {
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Emoji" ofType:@"plist"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        _emojiArray = [NSArray arrayWithArray:array];
        [self reSetEmojiArray:array];
    }
    return _emojiArray;
}

- (void)setEmojiArray:(NSArray *)emojiArray {
    
    [self reSetEmojiArray:emojiArray];
    _emojiArray = emojiArray;
}

- (void)reSetEmojiArray:(NSArray *)emojiArray {
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:emojiArray];
    for (int i = 0; i < array.count; i ++) {
        if (i % (self.rowCount * self.columnCount) == 0 && i > 0) {
            [array insertObject:@"删除" atIndex:i-1];
        }
    }
    if (![array[array.count-1] isEqualToString:@"删除"]) {
        [array addObject:@"删除"];
    }
    self.dataSource = [NSArray arrayWithArray:array];
}

#pragma mark -setting
- (void)setRowCount:(NSInteger)rowCount {
    
    _rowCount = rowCount;
    [self viewLayout];
}

- (void)setColumnCount:(NSInteger)columnCount {
    
    _columnCount = columnCount;
    [self viewLayout];
}

- (void)setEmoji_x:(CGFloat)emoji_x {
    
    _emoji_x = emoji_x;
    [self viewLayout];
}

- (void)viewLayout {
    
    if (self.emojiArray.count > self.rowCount*self.columnCount) {
        [self setFrame:CGRectMake(0, 0, KProjectScreenWidth, (KProjectScreenWidth-2*self.emoji_x)/(CGFloat)self.rowCount*self.columnCount+20)];
        self.collectionView.frame = CGRectMake(0, 0, KProjectScreenWidth, (KProjectScreenWidth-2*self.emoji_x)/(CGFloat)self.rowCount*self.columnCount);
        
        self.pageControlView.frame = CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20);
        self.pageControl.numberOfPages = (self.emojiArray.count + self.rowCount*self.columnCount-1)/(self.rowCount*self.columnCount);
    }else {
        [self setFrame:CGRectMake(0, 0, KProjectScreenWidth, (KProjectScreenWidth-2*self.emoji_x)/(CGFloat)self.rowCount*self.columnCount)];
        self.collectionView.frame = CGRectMake(0, 0, KProjectScreenWidth, (KProjectScreenWidth-2*self.emoji_x)/(CGFloat)self.rowCount*self.columnCount);
    }
    [self reSetEmojiArray:self.emojiArray];
    [self.collectionView reloadData];
}

#pragma mark -lazy
- (UIView *)pageControlView {
    if (!_pageControlView) {
        
        _pageControlView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
        _pageControlView.backgroundColor = self.collectionView.backgroundColor;
        [self addSubview:_pageControlView];

        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-100)/2.0, 0, 100, 20)];
        _pageControl.currentPage = 0;
        self.pageControl.numberOfPages = (self.emojiArray.count + self.rowCount*self.columnCount-1)/(self.rowCount*self.columnCount);
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:139/255.0 green:139/255.0 blue:139/255.0 alpha:1.0];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0];
        [_pageControlView addSubview:_pageControl];
    }
    return _pageControlView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = CGFLOAT_MIN;  //最小行距
        layout.minimumInteritemSpacing = CGFLOAT_MIN;  //最小列距
        layout.itemSize = CGSizeMake((self.frame.size.width-20)/(CGFloat)self.rowCount, (self.frame.size.width-20)/(CGFloat)self.rowCount);
        layout.headerReferenceSize = CGSizeZero;
        layout.footerReferenceSize = CGSizeZero;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, (self.frame.size.width-20)/(CGFloat)self.rowCount*self.columnCount) collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = true;
        _collectionView.pagingEnabled = YES;
        _collectionView.multipleTouchEnabled = NO;
        _collectionView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"EmojiCollectionViewCell"];
        
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark -UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return (self.dataSource.count + self.rowCount*self.columnCount-1)/(self.rowCount*self.columnCount);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.rowCount*self.columnCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiCollectionViewCell" forIndexPath:indexPath];
 
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    NSString *emoji = @"";

    NSInteger number = indexPath.item*self.rowCount-(indexPath.item/self.columnCount)*self.rowCount*self.columnCount+indexPath.item/self.columnCount+indexPath.section*self.rowCount*self.columnCount;
    if (number < self.dataSource.count) {
        emoji = self.dataSource[number];
    }
    if ([emoji isEqualToString:@"删除"]) {
        
        UIImageView *deleteButton = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"emoji_delete"]];
        deleteButton.contentMode = UIViewContentModeScaleToFill;
        [deleteButton setFrame:CGRectMake(((self.frame.size.width-20)/(CGFloat)self.rowCount-30)/2.0, (((self.frame.size.width-20)/(CGFloat)self.rowCount-23)/2.0), 30, 23)];
        [cell.contentView addSubview:deleteButton];
        
    }else {
        UILabel *emojiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (self.frame.size.width-20)/(CGFloat)self.rowCount, (self.frame.size.width-20)/(CGFloat)self.rowCount)];
        emojiLabel.text = emoji;
        emojiLabel.textAlignment = NSTextAlignmentCenter;
        emojiLabel.font = [UIFont systemFontOfSize:26];
        [cell.contentView addSubview:emojiLabel];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSInteger number = indexPath.item*self.rowCount-(indexPath.item/self.columnCount)*self.rowCount*self.columnCount+indexPath.item/self.columnCount+indexPath.section*self.rowCount*self.columnCount;
    if (number < self.dataSource.count) {
        NSString *emoji = self.dataSource[number];
        if ([emoji isEqualToString:@"删除"]) {
            if ([self.delegate respondsToSelector:@selector(deleteKeyboard)]) {
                [self.delegate deleteKeyboard];
            }
        }else {
            if ([self.delegate respondsToSelector:@selector(clickKeyboard:)]) {
                [self.delegate clickKeyboard:emoji];
            }
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake((self.frame.size.width-20)/(CGFloat)self.rowCount, (self.frame.size.width-20)/(CGFloat)self.rowCount);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, self.emoji_x, 0, self.emoji_x);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    offsetX = offsetX + scrollView.frame.size.width/2;
    int page = offsetX/scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}


@end
