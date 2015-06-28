//
//  ViewController.m
//  DrawingAnnotation
//
//  Created by Rich Long on 28/06/2015.
//  Copyright (c) 2015 Rich Long. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    
        CGPoint lastPoint;
        CGFloat red;
        CGFloat green;
        CGFloat blue;
        CGFloat brush;
        CGFloat opacity;
        BOOL wasSwiped;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;

}

#pragma mark Touch Handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    wasSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    wasSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.drawingImageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.drawingImageView setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!wasSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.drawingImageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.baseImageView.frame.size);
    [self.baseImageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.drawingImageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.baseImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    self.drawingImageView.image = nil;
    UIGraphicsEndImageContext();
}

#pragma mark - Button Actions

- (IBAction)brushOpacityAction:(id)sender {
    
    opacity = opacity - 0.1;
    
    if (opacity < 0.1) {
        opacity = 1.0 ;
    }
    
}

- (IBAction)brushWidthAction:(id)sender {
    
    //TODO: use set widths?
    brush++;
}

- (IBAction)selectColourAction:(id)sender {
    
    UIButton *pressedButton = (UIButton*)sender;
    switch(pressedButton.tag) {
        case 0:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 1:
            red = 105.0/255.0;
            green = 105.0/255.0;
            blue = 105.0/255.0;
            break;
        case 2:
            red = 255.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 3:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 255.0/255.0;
            break;
        case 4:
            red = 102.0/255.0;
            green = 204.0/255.0;
            blue = 0.0/255.0;
            break;
        case 5:
            red = 102.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            break;
        case 6:
            red = 51.0/255.0;
            green = 204.0/255.0;
            blue = 255.0/255.0;
            break;
        case 7:
            red = 160.0/255.0;
            green = 82.0/255.0;
            blue = 45.0/255.0;
            break;
        case 8:
            red = 255.0/255.0;
            green = 102.0/255.0;
            blue = 0.0/255.0;
            break;
        case 9:
            red = 255.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            break;
    }
}

- (IBAction)eraserButtonAction:(id)sender {
}

- (IBAction)saveButtonAction:(id)sender {
}

- (IBAction)resetButtonAction:(id)sender {
    self.baseImageView.image = nil;
}

#pragma mark - Styling

- (NSArray*)brushColorsArray {
    
    
    UIColor *redColor = [UIColor colorWithRed:255.0/255.0
                                        green:0.0/255.0
                                         blue:140.0/255.0
                                        alpha:1.0];
    
    UIColor *greenColor = [UIColor colorWithRed:0.0/255.0
                                          green:255.0/255.0
                                           blue:0.0/255.0
                                          alpha:1.0];
    
    UIColor *blueColor = [UIColor colorWithRed:0/255.0
                                         green:0/255.0
                                          blue:255.0/255.0
                                         alpha:1.0];

    return @[ redColor, greenColor, blueColor ];
}




@end
