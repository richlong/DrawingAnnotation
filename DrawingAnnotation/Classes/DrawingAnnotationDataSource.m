//
//  DrawingAnnotationDataSource.m
//  DrawingAnnotation
//
//  Created by Rich Long on 11/07/2015.
//  Copyright (c) 2015 Rich Long. All rights reserved.
//

#import "DrawingAnnotationDataSource.h"
#import "Annotation.h"

#define IMAGE_SAVE_PATH @"Documents/"
#define SAVED_IMAGE_NAME @"image1.png"

@implementation DrawingAnnotationDataSource

- (instancetype)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

#pragma mark Images

- (UIImage*)getBackgroundImage {
    
    return [UIImage imageNamed:@"Yosemite 2.jpg"];
}

- (UIImage*)getDrawingLayer {
    UIImage *image = [self loadFileFromDocumentFolder:SAVED_IMAGE_NAME];
    return image;
}

- (void)saveImageToDevice:(UIImage*)image {
    
    //TODO: Need file name and Directory, using documents for now.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
//        NSString *fileName = [NSString stringWithFormat:@"%@.png",@"file1"];
        
        [UIImagePNGRepresentation(image) writeToFile:[[self fileDirectory] stringByAppendingPathComponent:SAVED_IMAGE_NAME] atomically:YES];

        });
}

- (UIImage*)loadFileFromDocumentFolder:(NSString *)filename {

    NSString *outputPath = [[self fileDirectory] stringByAppendingPathComponent:filename];
    return [UIImage imageWithContentsOfFile:outputPath];
}

- (NSString*)fileDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (BOOL)checkFileExists:(NSString*)fileName {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]){
        return YES;
    }
    
    return NO;
}

#pragma mark Annotations

- (NSArray*)getSavedAnnotations {
    
    Annotation *newAnnotation = [[Annotation alloc] initWithAnnotation:@"annotation" FontSize:16 Date:nil Author:self.getAuthor Delegate:self.delegate];
    newAnnotation.point = CGPointMake(300, 100);
    
    
    Annotation *newAnnotation2 = [[Annotation alloc] initWithAnnotation:@"annotation" FontSize:16 Date:nil Author:self.getAuthor Delegate:self.delegate];
    newAnnotation2.point = CGPointMake(500, 200);

    return @[ newAnnotation, newAnnotation2,];
}

- (void)saveAnnotationsToWebservice:(NSMutableArray*)arrayOfAnnotations {
    
    NSLog(@"%@",arrayOfAnnotations);
}

- (NSString*)getAuthor {
    return @"Author 123";
}

@end
