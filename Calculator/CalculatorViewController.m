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
NSString * const ResultMark = @" =";

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

- (void)removeResultMark
{
    NSRange range = [self.historyDisplay.text rangeOfString:ResultMark];
    if (range.location != NSNotFound) {
        self.historyDisplay.text = [self.historyDisplay.text substringToIndex:range.location];
    }    
}

- (void)addResultMark
{
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:@"%@", ResultMark];
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
        [self removeResultMark];
    }
}

- (IBAction)enterPressed
{
    // when use enter to reenter operand in display
    [self removeResultMark];
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

- (void)backOperation
{
    NSString *operand = self.display.text;
    if ([operand length] > 0) {
        operand = [operand substringToIndex:[operand length] - 1];
    }
    if ([operand length] == 0) {
        self.userIsInTheMiddleOfEnteringANumber = NO;
        self.display.text = @"0";
    } else {
        self.display.text = operand;
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    // Remove ResultMark first, then add ResultMark
    [self removeResultMark];

    NSString *operation = sender.currentTitle;
    if ([operation isEqualToString:@"Back"]) {
        [self backOperation];
        return;
    }

    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    if ([operation isEqualToString:@"C"]) {
        [self clearOperation];
        return;
    }

    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:@" %@", operation];
    [self addResultMark];
}

@end
