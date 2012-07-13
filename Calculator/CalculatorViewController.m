//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Liu Zhijin on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *historyDisplay;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize historyDisplay = _historyDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (_brain == nil) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([digit isEqualToString:@"."]
            && [self.display.text rangeOfString:@"."].location != NSNotFound) {
            NSLog(@"Already has one '.' entered, ignore it");
            return;
        }

        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed
{
    NSString *operand = self.display.text;
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:@" %@", operand];
    [self.brain pushOperand:[operand doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (void)clearOperation
{
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.display.text = @"0";
    self.historyDisplay.text = @"";
    [self.brain clear];
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    NSString *operation = sender.currentTitle;
    if ([operation isEqualToString:@"C"]) {
        [self clearOperation];
        return;
    }

    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:@" %@", operation];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

@end
