//
//  drawMediumBrush.m
//  DrawingAnnotation
//
//  Created by Rich Long on 10/07/2015.
//  Copyright (c) 2015 Rich Long. All rights reserved.
//

#import "drawMediumBrush.h"

@implementation drawMediumBrush

- (void)drawRect:(CGRect)frame {
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Brush Icon Drawing
    UIBezierPath* brushIconPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + 27.7, CGRectGetMinY(frame) + 17.7, 41.6, 41.6)];
    [fillColor setFill];
    [brushIconPath fill];
}

@end
