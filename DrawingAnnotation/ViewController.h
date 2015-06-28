//
//  ViewController.h
//  DrawingAnnotation
//
//  Created by Rich Long on 28/06/2015.
//  Copyright (c) 2015 Rich Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

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

@end

