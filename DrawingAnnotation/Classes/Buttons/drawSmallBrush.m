//
//  drawSmallBrush.m
//  DrawingAnnotation
//
//  Created by Rich Long on 10/07/2015.
//  Copyright (c) 2015 Rich Long. All rights reserved.
//

#import "drawSmallBrush.h"

@implementation drawSmallBrush

- (void)drawRect:(CGRect)frame {
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Brush Icon Drawing
    UIBezierPath* brushIconPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + 38.31, CGRectGetMinY(frame) + 28.3, 20.38, 20.38)];
    [fillColor setFill];
    [brushIconPath fill];
}

@end
