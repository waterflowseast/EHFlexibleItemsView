//
//  EHFlexibleLayout.m
//  WFEDemo
//
//  Created by Eric Huang on 16/12/6.
//  Copyright © 2016年 Eric Huang. All rights reserved.
//

#import "EHFlexibleLayout.h"

@interface EHFlexibleLayout ()

@property (nonatomic, strong, readwrite) NSArray <NSNumber *> *itemWidths;
@property (nonatomic, assign, readwrite) CGFloat itemHeight;

@property (nonatomic, assign, readwrite) CGFloat totalWidth;
@property (nonatomic, assign, readwrite) UIEdgeInsets insets;

@property (nonatomic, assign, readwrite) CGFloat interitemSpacing;
@property (nonatomic, assign, readwrite) CGFloat lineSpacing;

@property (nonatomic, assign) BOOL maxWidthItemOutOfBounds;

@property (nonatomic, strong) NSMutableArray *columnIndexes;
@property (nonatomic, strong) NSMutableArray *rowIndexes;

@property (nonatomic, strong) NSMutableArray *xs;
@property (nonatomic, strong) NSMutableArray *ys;

@end

@implementation EHFlexibleLayout

- (instancetype)initWithItemWidths:(NSArray<NSNumber *> *)itemWidths itemHeight:(CGFloat)itemHeight totalWidth:(CGFloat)totalWidth insets:(UIEdgeInsets)insets interitemSpacing:(CGFloat)interitemSpacing lineSpacing:(CGFloat)lineSpacing {
    self = [super init];
    if (self) {
        _itemWidths = [itemWidths copy];
        _itemHeight = itemHeight;
        _totalWidth = totalWidth;
        _insets = insets;
        _interitemSpacing = interitemSpacing;
        _lineSpacing = lineSpacing;
        
        [self calculateValues];
    }
    
    return self;
}

- (CGFloat)totalHeight {
    if (self.maxWidthItemOutOfBounds) {
        return 0;
    }

    NSInteger numberOfRows = [self numberOfRows];
    return self.insets.top + self.insets.bottom + numberOfRows * self.itemHeight + (numberOfRows - 1) * self.lineSpacing;
}

- (NSInteger)itemsCountAtRow:(NSInteger)row {
    if (self.maxWidthItemOutOfBounds) {
        return 0;
    }
    
    NSInteger count = 0;
    for (int i = 0; i < self.rowIndexes.count; i++) {
        if (row == [self.rowIndexes[i] integerValue]) {
            count += 1;
        }
    }
    
    return count;
}

- (NSInteger)numberOfRows {
    if (self.maxWidthItemOutOfBounds) {
        return 0;
    }
    
    return [[self.rowIndexes lastObject] integerValue] + 1;
}

- (NSInteger)columnIndexForIndex:(NSInteger)index {
    if (index >= 0 && index < self.columnIndexes.count) {
        return [self.columnIndexes[index] integerValue];
    }
    
    return 0;
}

- (NSInteger)rowIndexForIndex:(NSInteger)index {
    if (index >= 0 && index < self.rowIndexes.count) {
        return [self.rowIndexes[index] integerValue];
    }

    return 0;
}

- (CGFloat)xForIndex:(NSInteger)index {
    if (index >= 0 && index < self.xs.count) {
        return [self.xs[index] floatValue];
    }

    return self.insets.left;
}

- (CGFloat)yForIndex:(NSInteger)index {
    if (index >= 0 && index < self.ys.count) {
        return [self.ys[index] floatValue];
    }

    return self.insets.top;
}

- (NSInteger)columnIndexForLocation:(CGPoint)location {
    NSInteger index = [self indexForLocation:location];
    if (index < 0) {
        return -1;
    }
    
    return [self columnIndexForIndex:index];
}

- (NSInteger)rowIndexForLocation:(CGPoint)location {
    if (location.y <= self.insets.top) {
        return -1; // 落在第一个item的上边界之内
    }
    
    NSInteger numberOfRows = [self numberOfRows];
    if (location.y >= self.insets.top + numberOfRows * self.itemHeight + (numberOfRows - 1) * self.lineSpacing) {
        return -1; // 落在最后一个item的下边界之外
    }
    
    CGFloat tempHeight = location.y - self.insets.top;
    NSInteger count = (int)floorf(tempHeight / (self.itemHeight + self.lineSpacing));
    CGFloat remainingHeight = tempHeight - count * (self.itemHeight + self.lineSpacing);
    
    if (remainingHeight >= self.itemHeight) {
        return -1; // 落在空隙之间
    }
    
    return count;
}

- (NSInteger)indexForLocation:(CGPoint)location {
    NSInteger rowIndex = [self rowIndexForLocation:location];
    if (rowIndex < 0) {
        return -1;
    }
    
    for (int i = 0; i < self.rowIndexes.count; i++) {
        if (rowIndex == [self.rowIndexes[i] integerValue] &&
            location.x >= [self.xs[i] floatValue] &&
            location.x <= [self.xs[i] floatValue] + [self.itemWidths[i] floatValue] &&
            location.y >= [self.ys[i] floatValue] &&
            location.y <= [self.ys[i] floatValue] + self.itemHeight) {
            
            return i;
        }
    }
    
    return -1;
}

#pragma mark - private methods

- (void)calculateValues {
    CGFloat actualTotalWidth = _totalWidth - _insets.left - _insets.right;
    NSArray *sortedItemWidths = [_itemWidths sortedArrayUsingSelector:@selector(compare:)];
    CGFloat maxItemWidth = [[sortedItemWidths lastObject] floatValue];
    
    if (maxItemWidth > actualTotalWidth) {
        _maxWidthItemOutOfBounds = YES;

        for (int i = 0; i < _itemWidths.count; i++) {
            [self.columnIndexes addObject:@0];
            [self.rowIndexes addObject:@0];
            [self.xs addObject:@(_insets.left)];
            [self.ys addObject:@(_insets.top)];
        }
        
        return;
    }
    
    NSInteger currentColumnIndex = 0;
    NSInteger currentRowIndex = 0;
    CGFloat currentX = _insets.left;
    CGFloat currentY = _insets.top;
    
    for (int i = 0; i < _itemWidths.count; i++) {
        if (currentX + [_itemWidths[i] floatValue] > _totalWidth - _insets.right) {
            // place this item at next row
            currentColumnIndex = 0;
            currentRowIndex += 1;
            currentX = _insets.left;
            currentY += _itemHeight + _lineSpacing;
        }

        [self.columnIndexes addObject:@(currentColumnIndex)];
        [self.rowIndexes addObject:@(currentRowIndex)];
        [self.xs addObject:@(currentX)];
        [self.ys addObject:@(currentY)];

        currentColumnIndex += 1;
        currentX += [_itemWidths[i] floatValue] + _interitemSpacing;
    }
}

#pragma mark - getters & setters

- (NSMutableArray *)columnIndexes {
    if (!_columnIndexes) {
        _columnIndexes = [NSMutableArray arrayWithCapacity:10];
    }
    
    return _columnIndexes;
}

- (NSMutableArray *)rowIndexes {
    if (!_rowIndexes) {
        _rowIndexes = [NSMutableArray arrayWithCapacity:10];
    }
    
    return _rowIndexes;
}

- (NSMutableArray *)xs {
    if (!_xs) {
        _xs = [NSMutableArray arrayWithCapacity:10];
    }
    
    return _xs;
}

- (NSMutableArray *)ys {
    if (!_ys) {
        _ys = [NSMutableArray arrayWithCapacity:10];
    }
    
    return _ys;
}

@end
