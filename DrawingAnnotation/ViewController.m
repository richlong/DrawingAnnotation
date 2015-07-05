//
//  ViewController.m
//  DrawingAnnotation
//
//  Created by Rich Long on 28/06/2015.
//  Copyright (c) 2015 Rich Long. All rights reserved.
//

#import "ViewController.h"
#import "Annotation.h"

@interface ViewController () {
    
    CGPoint lastPoint;
    CGPoint annotationPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL wasSwiped;
    BOOL isErasing;
    BOOL isDrawing;
    BOOL isAnnotation;
    BOOL isAnnotationViewActive;
    BOOL isSettingAnnotationPoint;
    int activeColor;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setDefaultBrush];
    [self registerForKeyboardNotifications];
    
    self.addAnnotationTextField.hidden = YES;
    self.addAnnotationLabel.hidden = YES;
    self.addAnnotationButton.hidden = YES;

}

- (void)setDefaultBrush {
    
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
    
    if (isAnnotationViewActive) {
        self.addAnnotationTextField.hidden = NO;
        self.addAnnotationLabel.hidden = NO;
        self.addAnnotationButton.hidden = NO;
        self.addAnnotationInstructionLabel.hidden = YES;
        
        if (isSettingAnnotationPoint) {
            annotationPoint = lastPoint;
            isSettingAnnotationPoint = NO;
            NSLog(@"annotationPoint: (%f,%f)", annotationPoint.x, annotationPoint.y);
        }

    }
    
    [self.addAnnotationTextField endEditing:YES];
    
    NSLog(@"Point in myView: (%f,%f)", lastPoint.x, lastPoint.y);

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (isDrawing) {
    
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
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (isDrawing) {

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
}


#pragma mark - Drawing Button Actions

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
    
    isErasing = NO;
    isDrawing = YES;

    activeColor++;
    
    if (activeColor > 7) {
        activeColor = 0;
    }
    
//    UIButton *pressedButton = (UIButton*)sender;
//    switch(pressedButton.tag) {

    switch(activeColor) {
        case 0:
            //Black
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 1:
            //Green
            red = 139.0/255.0;
            green = 197.0/255.0;
            blue = 62.0/255.0;
            break;
        case 2:
            //Grey
            red = 179.0/255.0;
            green = 179.0/255.0;
            blue = 179.0/255.0;
            break;
        case 3:
            //Yellow
            red = 251.0/255.0;
            green = 237.0/255.0;
            blue = 32.0/255.0;
            break;
        case 4:
            //Light blue
            red = 17.0/255.0;
            green = 169.0/255.0;
            blue = 224.0/255.0;
            break;
        case 5:
            //Purple
            red = 126.0/255.0;
            green = 80.0/255.0;
            blue = 126.0/255.0;
            break;
        case 6:
            //Red
            red = 180.0/255.0;
            green = 55.0/255.0;
            blue = 64.0/255.0;
            break;
        case 7:
            //Orange
            red = 250.0/255.0;
            green = 175.0/255.0;
            blue = 58.0/255.0;
            break;
    }
}

- (IBAction)eraserButtonAction:(id)sender {
    
    //TODO: going to be a pain
    //http://stackoverflow.com/questions/629409/how-to-draw-a-transparent-stroke-or-anyway-clear-part-of-an-image-on-the-iphon
    
    isErasing = YES;
    isDrawing = NO;

}

- (IBAction)saveButtonAction:(id)sender {
    
    UIGraphicsBeginImageContextWithOptions(self.baseImageView.bounds.size, NO,0.0);
    [self.baseImageView.image drawInRect:CGRectMake(0, 0, self.baseImageView.frame.size.width, self.baseImageView.frame.size.height)];
    UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (IBAction)resetButtonAction:(id)sender {
    self.baseImageView.image = nil;
}

- (IBAction)addTextAnnotationAction:(id)sender {
    
    isDrawing = NO;
    isAnnotation = YES;
    
    if (!isAnnotationViewActive) {
        [self showAddAnnotation];
    }
    else {
        [self hideAddAnnotation];
    }
}

- (void)showAddAnnotation {
    
    [self animateAnnotationView: 200];
    isAnnotationViewActive = YES;
    self.addAnnotationInstructionLabel.hidden = NO;
    self.addAnnotationTextField.hidden = YES;
    self.addAnnotationButton.hidden = YES;
    self.addAnnotationLabel.hidden = YES;
}

- (void)hideAddAnnotation {
    
    [self animateAnnotationView: -200];
    isAnnotationViewActive = NO;
}

- (void)animateAnnotationView:(float)position {
 
    self.addAnnotationViewYPositionConstraint.constant = position;

    [self.addAnnotationView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.5 animations:^{
        [self.addAnnotationView layoutIfNeeded];
    }];
}

#pragma mark - Save image

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved.Please try again"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image was successfully saved in photoalbum"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

- (IBAction)addAnnotationAction:(id)sender {
    
    [self.annotationContainerView addSubview:[Annotation createLabelWithAnnotation:self.addAnnotationTextField.text Point:lastPoint]];
    
    self.addAnnotationTextField.text = @"";
    [self.addAnnotationTextField endEditing:YES];
    [self hideAddAnnotation];
}

#pragma mark - Keyboard resizing

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [self animateAnnotationView: kbSize.height];

}
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{

    //TODO: need correct position
    [self animateAnnotationView: 200];

}

#pragma mark - Notifications

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardDidShowNotification];

    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
}

#pragma mark - Main menu actions

- (IBAction)mainMenuBackAction:(id)sender {
}

- (IBAction)mainMenuAddAction:(id)sender {
    [self optionsMenuToggle];
}

- (IBAction)mainMenuRemoveAction:(id)sender {
}

#pragma mark - Options menu

- (void)optionsMenuToggle {
    
    if (self.optionsMenuView.hidden) {
        self.optionsMenuBackgroundView.hidden = NO;
        self.optionsMenuView.hidden = NO;
    }
    else {
        self.optionsMenuBackgroundView.hidden = YES;
        self.optionsMenuView.hidden = YES;
    }
}

- (IBAction)optionsMenuAddSketchAction:(id)sender {
}

- (IBAction)optionsMenuAddAnnotationAction:(id)sender {
    [self showAddAnnotation];
    [self optionsMenuToggle];
    isSettingAnnotationPoint = YES;
}
@end
