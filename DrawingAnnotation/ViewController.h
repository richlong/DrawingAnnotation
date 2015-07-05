//
//  ViewController.h
//  DrawingAnnotation
//
//  Created by Rich Long on 28/06/2015.
//  Copyright (c) 2015 Rich Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

#pragma mark - Main Menu
@property (weak, nonatomic) IBOutlet UIView *mainMenuView;

- (IBAction)mainMenuBackAction:(id)sender;
- (IBAction)mainMenuAddAction:(id)sender;
- (IBAction)mainMenuRemoveAction:(id)sender;
- (IBAction)mainMenuToggleAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainMenuTopConstraint;

#pragma mark - Options menu

@property (weak, nonatomic) IBOutlet UIView *optionsMenuBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *optionsMenuView;
- (IBAction)optionsMenuAddSketchAction:(id)sender;
- (IBAction)optionsMenuAddAnnotationAction:(id)sender;

#pragma mark - Drawing
@property (weak, nonatomic) IBOutlet UIImageView *imageForAnnotationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *baseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *drawingImageView;
@property (weak, nonatomic) IBOutlet UIButton *brushWitdhButton;
@property (weak, nonatomic) IBOutlet UIButton *selectColourButton;
@property (weak, nonatomic) IBOutlet UIButton *eraserButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *brushOpacityButton;

- (IBAction)brushOpacityAction:(id)sender;
- (IBAction)brushWidthAction:(id)sender;
- (IBAction)selectColourAction:(id)sender;
- (IBAction)eraserButtonAction:(id)sender;
- (IBAction)saveButtonAction:(id)sender;
- (IBAction)resetButtonAction:(id)sender;

#pragma mark - Annotating

@property (weak, nonatomic) IBOutlet UIView *annotationContainerView;
@property (weak, nonatomic) IBOutlet UIButton *addTextAnnotationButton;
@property (weak, nonatomic) IBOutlet UIView *addAnnotationView;
@property (weak, nonatomic) IBOutlet UILabel *addAnnotationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addAnnotationInstructionLabel;
@property (weak, nonatomic) IBOutlet UITextField *addAnnotationTextField;
@property (weak, nonatomic) IBOutlet UIButton *addAnnotationButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *addAnnotationViewYPositionConstraint;

- (IBAction)addTextAnnotationAction:(id)sender;
- (IBAction)addAnnotationAction:(id)sender;

@end

