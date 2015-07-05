//
//  Annotation.m
//  DrawingAnnotation
//
//  Created by Rich Long on 28/06/2015.
//  Copyright (c) 2015 Rich Long. All rights reserved.
//

#import "Annotation.h"
#import <UIKit/UIKit.h>

@implementation Annotation

+ (UILabel*)createLabelWithAnnotation:(NSString*)annotation Point:(CGPoint)lastPoint {
 
    UILabel *annotationLabel = [[UILabel alloc] init];
    annotationLabel.text = annotation;
    annotationLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    annotationLabel.numberOfLines = 0;
    annotationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maximumLabelSize = CGSizeMake(200, 9999);
    CGSize expectSize = [annotationLabel sizeThatFits:maximumLabelSize];
    annotationLabel.frame = CGRectMake(lastPoint.x, lastPoint.y, expectSize.width, expectSize.height);
    annotationLabel.backgroundColor = [UIColor redColor];

    return annotationLabel;
}

@end
