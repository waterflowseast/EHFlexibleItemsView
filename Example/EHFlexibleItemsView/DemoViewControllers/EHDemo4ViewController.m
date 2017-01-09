//
//  EHDemo4ViewController.m
//  EHItemsView
//
//  Created by Eric Huang on 17/1/9.
//  Copyright © 2017年 Eric Huang. All rights reserved.
//

#import "EHDemo4ViewController.h"
#import <Masonry/Masonry.h>
#import <EHFlexibleItemsView/EHFlexibleItemsSelectionView.h>
#import "WFELabel.h"

static CGFloat const kLabelHeight = 30.0f;
static CGFloat const kInteritemSpacing = 20.0f;
static CGFloat const kLineSpacing = 12.0f;

@interface EHDemo4ViewController () <EHFlexibleItemsViewDelegate, EHItemViewSelectionDelegate>

@property (nonatomic, strong) NSArray *words;
@property (nonatomic, strong) NSArray *widths;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) EHFlexibleItemsSelectionView *itemsView;

@end

@implementation EHDemo4ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configureForNavigationBar];
    [self configureForViews];
    
    [self.view addSubview:self.itemsView];
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.view);
        make.height.mas_equalTo([self.itemsView totalHeight]);
    }];
}
    
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
    
#pragma mark - EHFlexibleItemsViewDelegate
    
- (void)didTapItemAtIndex:(NSInteger)index rowIndex:(NSInteger)rowIndex columnIndex:(NSInteger)columnIndex inView:(EHFlexibleItemsView *)view {
    NSLog(@"===> index: %ld, rowIndex: %ld, columnIndex: %ld, word: %@", index, rowIndex, columnIndex, self.words[index]);
}
    
#pragma mark - EHItemViewSelectionDelegate
    
- (void)didTapExceedingLimitInView:(UIView *)view maxSelectionsAllowed:(NSUInteger)maxSelectionsAllowed {
    NSLog(@"===> exceeding max: %ld", (long)maxSelectionsAllowed);
}
    
#pragma mark - private methods
    
- (void)configureForNavigationBar {
    self.navigationItem.title = @"EHFlexibleItemsSelectionView Multiple Selections No Animation";
}
    
- (void)configureForViews {
    self.view.backgroundColor = [UIColor whiteColor];
}
    
#pragma mark - getters & setters
    
- (NSArray *)words {
    if (!_words) {
        _words = @[
                   @"照片", @"拍摄", @"小视频", @"视频聊天",
                   @"红包", @"转账", @"位置", @"收藏",
                   @"个人名片", @"语音输入", @"卡券"
                   ];
    }
    
    return _words;
}
    
- (NSArray *)widths {
    if (!_widths) {
        NSMutableArray *mutableArray = [NSMutableArray array];
        
        for (int i = 0; i < self.words.count; i++) {
            CGSize size = [self.words[i] sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]}];
            [mutableArray addObject:@(size.width * 3)];
        }
        
        _widths = [mutableArray copy];
    }
    
    return _widths;
}
    
- (NSArray *)labels {
    if (!_labels) {
        NSMutableArray *mutableArray = [NSMutableArray array];
        
        for (int i = 0; i < self.words.count; i++) {
            WFELabel *label = [[WFELabel alloc] initWithText:self.words[i]];
            
            [mutableArray addObject:label];
        }
        
        _labels = [mutableArray copy];
    }
    
    return _labels;
}
    
- (EHFlexibleItemsSelectionView *)itemsView {
    if (!_itemsView) {
        _itemsView = [[EHFlexibleItemsSelectionView alloc] initWithItems:self.labels itemWidths:self.widths itemHeight:kLabelHeight totalWidth:[UIScreen mainScreen].bounds.size.width insets:UIEdgeInsetsMake(15, 15, 15, 15) interitemSpacing:kInteritemSpacing lineSpacing:kLineSpacing];
        _itemsView.allowsMultipleSelection = YES;
        _itemsView.delegate = self;
        _itemsView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0f];
    }
    
    return _itemsView;
}
    
@end
