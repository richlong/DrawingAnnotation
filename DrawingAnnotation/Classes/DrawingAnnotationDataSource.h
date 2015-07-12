//
//  DrawingAnnotationDataSource.h
//  DrawingAnnotation
//
//  Created by Rich Long on 11/07/2015.
//  Copyright (c) 2015 Rich Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Annotation.h"
@class DrawingAnnotationDataSource;

@protocol DrawingAnnotationDataSourceDelegate


@end

@interface DrawingAnnotationDataSource : NSObject

@property (nonatomic, assign) id<AnnotationDelegate> delegate;

- (instancetype)initWithDelegate:(id)delegate;

- (UIImage*)getBackgroundImage;
- (UIImage*)getDrawingLayer;
- (void)saveImageToDevice:(UIImage*)image;

- (NSArray*)getSavedAnnotations;
- (void)saveAnnotationsToWebservice:(NSMutableArray*)arrayOfAnnotations;
- (NSString*)getAuthor;

@end
