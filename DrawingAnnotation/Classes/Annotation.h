//
//  Annotation.h
//  DrawingAnnotation
//
//  Created by Rich Long on 28/06/2015.
//  Copyright (c) 2015 Rich Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface Annotation : NSObject

@property (strong, nonatomic) NSString *annotationString;
@property (strong, nonatomic) NSString *annotationAuthorString;
@property (strong, nonatomic) NSString *annotationDateString;
@property (nonatomic, assign) float fontSize;
@property (strong, nonatomic) UIView *annotationBackgroundView;

- (instancetype)initWithAnnotation:(NSString*)annotation FontSize:(float)fontSize Date:(NSString*)date Author:(NSString*)author;
- (UIView*)createAnnotationWithPoint:(CGPoint)lastPoint;

@end
