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

@class Annotation;

@protocol AnnotationDelegate

- (void)detectAnnotationTouch:(Annotation *)annotation;

@end

@interface Annotation : NSObject

@property (nonatomic, assign) id<AnnotationDelegate> delegate;
@property (strong, nonatomic) NSString *annotationString;
@property (strong, nonatomic) NSString *annotationAuthorString;
@property (strong, nonatomic) NSString *annotationDateString;
@property (nonatomic, assign) float fontSize;
@property (strong, nonatomic) UIView *annotationBackgroundView;
@property (nonatomic, assign) CGPoint point;


- (instancetype)initWithAnnotation:(NSString*)annotation FontSize:(float)fontSize Date:(NSString*)date Author:(NSString*)author Delegate:(id<AnnotationDelegate>)delegate;
- (UIView*)createAnnotationWithPoint:(CGPoint)lastPoint;

@end
