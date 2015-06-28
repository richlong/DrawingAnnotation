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

+ (UILabel*)createLabelWithAnnotation:(NSString*)annotation Point:(CGPoint)lastPoint;

@end
