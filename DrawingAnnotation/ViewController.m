//
//  ViewController.m
//  DrawingAnnotation
//
//  Created by Rich Long on 28/06/2015.
//  Copyright (c) 2015 Rich Long. All rights reserved.
//

#import "ViewController.h"
#import "Annotation.h"

#import "drawLargeBrush.h"
#import "drawMediumBrush.h"
#import "drawSmallBrush.h"


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
    BOOL mainMenuActive;
    BOOL drawingMenuActive;
    float defaultOpacity;
    BOOL isRemovingAnnotation;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    mainMenuActive = YES;
    [self registerForKeyboardNotifications];
    
    self.addAnnotationTextField.hidden = YES;
    self.addAnnotationLabel.hidden = YES;
    self.addAnnotationButton.hidden = YES;
    
    self.annotationArray = [[NSMutableArray alloc] init];
    defaultOpacity = 0.9;
    [self setDefaultBrush];
    
    self.dataSource = [[DrawingAnnotationDataSource alloc] initWithDelegate:self];
    
    //Load existing
    
    self.imageForAnnotationImageView.image = self.dataSource.getBackgroundImage;
    
    if (self.dataSource.getDrawingLayer) {
        self.baseImageView.image = self.dataSource.getDrawingLayer;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if ([self.dataSource.getSavedAnnotations count] > 0) {
                
                //Collecting from delegate to prevent was mutated while being enumerated errors
                for (Annotation *savedAnnotation in self.dataSource.getSavedAnnotations) {
                    [self addAnnotationToView:savedAnnotation withPoint:savedAnnotation.point];
                }
            }
        
        });
    });
}

- (void)setDefaultBrush {
    
    red = 139.0/255.0;
    green = 197.0/255.0;
    blue = 62.0/255.0;
    brush = 10.0;
    opacity = defaultOpacity;
    
    //Set default active color button background
    for (UIButton *button in self.drawingMenuView.subviews) {
        if (button.tag == 1) {
            [self setActiveColorBackground:button];
        }
    }
}

#pragma mark Data Source

- (void)saveAnnotationsToWebservice {
    [self.dataSource saveAnnotationsToWebservice:self.annotationArray];
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
        }

    }
    
    [self.addAnnotationTextField endEditing:YES];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (isDrawing || isErasing) {
        
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:self.view];
        wasSwiped = YES;
        UIGraphicsBeginImageContext(self.view.frame.size);
        
        UIImageView *imageForEditing;
        CGBlendMode editingBlendMode;

        if (isDrawing) {
            
            imageForEditing = self.drawingImageView;
            editingBlendMode = kCGBlendModeNormal;
        }
        else if (isErasing) {
            
            imageForEditing = self.baseImageView;
            editingBlendMode = kCGBlendModeClear;
            opacity = 1.0;
        }
        
        [imageForEditing.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),editingBlendMode);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        imageForEditing.image = UIGraphicsGetImageFromCurrentImageContext();
        [imageForEditing setAlpha:opacity];
        UIGraphicsEndImageContext();
        lastPoint = currentPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (isDrawing || isErasing) {

        if(!wasSwiped && isDrawing) {
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

#pragma mark - Annotation Actions

- (void)detectAnnotationTouch:(Annotation *)annotation {
    if (isRemovingAnnotation) {
        self.selectedAnnotation = annotation;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Annotation?"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:@"Cancel",nil];
        [alert show];
    }
}

- (void)removeAnnotation:(Annotation *)annotation {
    
    [self.annotationArray removeObject:annotation];
    annotation.annotationBackgroundView.hidden = YES;
    isRemovingAnnotation = NO;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        [self removeAnnotation:self.selectedAnnotation];
    }
}
#pragma mark - Drawing Menu

- (void)toggleDrawingMenu {
    
    float position = 0.0f;
    if (!drawingMenuActive) {
        drawingMenuActive = YES;
        if (!mainMenuActive) {
            [self toggleMainMenu];
        }
    }
    else {
        drawingMenuActive = NO;
        position = -227;
    }
    
    [self.drawingMenuView layoutIfNeeded];
    
    [self.drawingMenuView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.5 animations:^{
        self.drawingMenuXPositionConstraint.constant = position;
        [self.drawingMenuView layoutIfNeeded];
    }];
}


#pragma mark - Drawing Button Actions

- (IBAction)brushWidthAction:(id)sender {

    UIButton *pressedButton = (UIButton*)sender;
    
    switch(pressedButton.tag) {
        case 0:
            brush = 30;
            break;
        case 1:
            brush = 20;
            break;
        case 2:
            brush = 10;
            break;
    }
}

- (IBAction)selectColourAction:(id)sender {
    
    isErasing = NO;
    isDrawing = YES;
    opacity = defaultOpacity;
    
    for (UIButton *inactiveButton in self.drawingMenuView.subviews) {
        [[inactiveButton layer] setBorderWidth:0.0f];
    }
    
    UIButton *pressedButton = (UIButton*)sender;
    
    [self setActiveColorBackground:pressedButton];

    switch(pressedButton.tag) {
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
            opacity = 0.5;
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

- (void)setActiveColorBackground:(UIButton*)button {
    [[button layer] setBorderWidth:4.0f];
    [[button layer] setBorderColor:[UIColor whiteColor].CGColor];
}

- (IBAction)eraserButtonAction:(id)sender {

    isErasing = YES;
    isDrawing = NO;

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
    
    [self animateAnnotationView: 0];
    isAnnotationViewActive = YES;
    self.addAnnotationInstructionLabel.hidden = NO;
    self.addAnnotationTextField.hidden = YES;
    self.addAnnotationButton.hidden = YES;
    self.addAnnotationLabel.hidden = YES;
}

- (void)hideAddAnnotation {
    
    self.addAnnotationTextField.text = @"";
    [self.addAnnotationTextField endEditing:YES];
    [self animateAnnotationView: -113];
    isAnnotationViewActive = NO;
}

- (void)animateAnnotationView:(float)position {
 
    self.addAnnotationViewYPositionConstraint.constant = position;

    [self.addAnnotationView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.5 animations:^{
        [self.addAnnotationView layoutIfNeeded];
    }];
}

- (IBAction)addAnnotationAction:(id)sender {
    
    Annotation *newAnnotation = [[Annotation alloc] initWithAnnotation:self.addAnnotationTextField.text FontSize:16 Date:nil Author:self.dataSource.getAuthor Delegate:self];
    
    [self addAnnotationToView:newAnnotation withPoint:annotationPoint];
    [self hideAddAnnotation];
}

- (void)addAnnotationToView:(Annotation*)annotation withPoint:(CGPoint)point {
    
    UIView *newAnnotationView = [annotation createAnnotationWithPoint:point];
    [self.annotationArray addObject:annotation];
    [self.annotationContainerView addSubview: newAnnotationView];
}


#pragma mark - Save image


- (void)saveDrawingImageToDevice {
    UIGraphicsBeginImageContextWithOptions(self.baseImageView.bounds.size, NO,0.0);
    [self.baseImageView.image drawInRect:CGRectMake(0, 0, self.baseImageView.frame.size.width, self.baseImageView.frame.size.height)];
    [self.dataSource saveImageToDevice:UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    
}

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

#pragma mark - Main menu actions

- (IBAction)mainMenuKizuAction:(id)sender {

    if (drawingMenuActive) {
        [self toggleKizuButton];
        [self toggleDrawingMenu];
    }
    else if (mainMenuActive) {
        [self toggleMainMenu];
    }
    
    [self saveAnnotationsToWebservice];
    [self saveDrawingImageToDevice];
}

- (IBAction)mainMenuBackAction:(id)sender {
}

- (IBAction)mainMenuAddAction:(id)sender {
    [self toggleOptionsMenu];
}

- (IBAction)mainMenuRemoveAction:(id)sender {
    isRemovingAnnotation = YES;
}

- (IBAction)mainMenuToggleAction:(id)sender {
    [self toggleMainMenu];
}

- (void)toggleMainMenu {
    
    float position = 0.0f;
    
    if (mainMenuActive) {
        position = -490;
        mainMenuActive = NO;
        self.mainMenuToggleButton.hidden = NO;
    }
    else {
        mainMenuActive = YES;
        self.mainMenuToggleButton.hidden = YES;
    }
    
    [self.mainMenuView layoutIfNeeded];

    [self.mainMenuView setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.5 animations:^{
        self.mainMenuTopConstraint.constant = position;
        [self.mainMenuView layoutIfNeeded];
    }];
}

- (void)toggleKizuButton {
    
    if (!drawingMenuActive) {
        [self.mainMenuKizuButton setImage:nil forState:UIControlStateNormal];
        [self.mainMenuKizuButton setTitle:@"Done?" forState:UIControlStateNormal];
    }
    else {
        [self.mainMenuKizuButton setImage:[UIImage imageNamed:@"kizu_logo_270px.png"] forState:UIControlStateNormal];
        isDrawing = NO;
    }    
}

#pragma mark - Options menu

- (void)toggleOptionsMenu {
    
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
    [self toggleKizuButton];
    [self toggleDrawingMenu];
    [self toggleOptionsMenu];
    isErasing = NO;
    isDrawing = YES;
}

- (IBAction)optionsMenuAddAnnotationAction:(id)sender {
    [self showAddAnnotation];
    [self toggleOptionsMenu];
    isSettingAnnotationPoint = YES;
}

#pragma mark - Hide status bar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Keyboard resizing

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    
}
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
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


@end
