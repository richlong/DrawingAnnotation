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

- (instancetype)initWithAnnotation:(NSString*)annotation FontSize:(float)fontSize Date:(NSString*)date Author:(NSString*)author {
    self = [super init];
    if (self) {
        self.annotationString = annotation;
        self.fontSize = fontSize;
        self.annotationDateString = date;
        self.annotationAuthorString = author;
    }
    return self;
}

- (UIView*)createAnnotationWithPoint:(CGPoint)lastPoint {
    
    NSString *date = self.annotationDateString;

    //nil date will default to today's date
    if (!self.annotationDateString) {
        date = [self getTodayDate];
    }
    
    NSString *annotationWithAuthorAndDate = [NSString stringWithFormat:@"%@ %@ \n%@", self.annotationAuthorString, date, self.annotationString];
    UILabel *annotationLabel = [[UILabel alloc] init];
    annotationLabel.text = annotationWithAuthorAndDate;
    annotationLabel.font = [UIFont fontWithName:@"Helvetica" size:self.fontSize];
    annotationLabel.numberOfLines = 0;
    annotationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    annotationLabel.textColor = [UIColor whiteColor];
    annotationLabel.textAlignment = NSTextAlignmentCenter;

    CGSize maximumLabelSize = CGSizeMake(200, 9999);
    CGSize expectSize = [annotationLabel sizeThatFits:maximumLabelSize];
    
    int padding = 5;

    annotationLabel.frame = CGRectMake(padding, padding, expectSize.width, expectSize.height);
    
    self.annotationBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(lastPoint.x,
                                                                             lastPoint.y,
                                                                             expectSize.width + padding * 2,
                                                                             expectSize.height + padding * 2)];
    
    UIView *backgroundColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, expectSize.width + padding * 2, expectSize.height + padding * 2)];
    backgroundColorView.backgroundColor = [UIColor colorWithRed:17.0f/255 green:169.0f/255 blue:224.0f/255 alpha:0.8f];

    [self.annotationBackgroundView addSubview:backgroundColorView];
    [self.annotationBackgroundView addSubview:annotationLabel];
    return self.annotationBackgroundView;
}

- (NSString*)getTodayDate {
    
    NSDateFormatter *formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yy"];
    
    return [formatter stringFromDate:[NSDate date]];

}

@end
