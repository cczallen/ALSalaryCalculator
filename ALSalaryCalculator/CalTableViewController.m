//
//  CalTableViewController.m
//  ALSalaryCalculator
//
//  Created by ALLENMAC on 2014/6/29.
//  Copyright (c) 2014年 AllenLee. All rights reserved.
//
#define TAG_Offset 100

#import "CalTableViewController.h"

@interface CalTableViewController () <UITextFieldDelegate, UIScrollViewDelegate>
- (IBAction)resetAction:(id)sender;
- (IBAction)calAction:(id)sender;
- (void)reverseCalAction;
@end

@implementation CalTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	UITableView *tableView = (UITableView *)[self.view viewWithTag:99];
	[(UIScrollView *)tableView setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self calAction:nil];
}

- (IBAction)resetAction:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[sender currentTitle] message:@"Reset?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reset", nil];
	alert.tag = 9681;
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 9681 && buttonIndex != alertView.cancelButtonIndex) {
		int maximunTag = 8;
		for (int i=1; i<=maximunTag; i++) {
			[self _setNumber:0 byTag:i];
		}
	}
}


- (IBAction)calAction:(id)sender {
    CGFloat monthly                   = [self _getNumberByTag:1];
    CGFloat monthsOfYearEndBonus      = [self _getNumberByTag:2];
    CGFloat percentageOfAnotherBonus1 = [self _getNumberByTag:3];
    CGFloat moneyOfAnotherBonus2      = [self _getNumberByTag:4];
	
	//Without Bonus
	CGFloat total =	(monthly *(12.0 +monthsOfYearEndBonus) );
	CGFloat averageMonthly = total /12.0;
	
	[self _setNumber:total byTag:5];
	[self _setNumber:averageMonthly byTag:6];
	
	//With Bonus
	CGFloat totalWithbonus = total
	+ (monthly *12 *(percentageOfAnotherBonus1 *0.01))
	+ moneyOfAnotherBonus2;
	CGFloat averageMonthlyWithBouns = totalWithbonus /12.0;
	
	[self _setNumber:totalWithbonus byTag:7];
	[self _setNumber:averageMonthlyWithBouns byTag:8];
}

- (void)reverseCalAction {
	//cal monthly wage by total...
    CGFloat total                = [self _getNumberByTag:5];
    CGFloat monthsOfYearEndBonus = [self _getNumberByTag:2];
	CGFloat monthly = total /(12.0 +monthsOfYearEndBonus);
	
	[self _setNumber:monthly byTag:1];
//	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//		[self calAction:nil];
//	});
}

- (CGFloat)_getNumberByTag:(NSUInteger)tag	{
	CGFloat num = 0;
	tag += TAG_Offset;
	UIView *view = [self.view viewWithTag:tag];
	if ([view respondsToSelector:@selector(text)]) {
		NSString *text = [(id)view text];
		num = [text floatValue];
	}
	return num;
}

- (void)_setNumber:(CGFloat)number byTag:(NSUInteger)tag	{
	
	UITextField *tfTotal = (UITextField *)[self.view viewWithTag:tag+TAG_Offset];
	if ([tfTotal isKindOfClass:[UITextField class]]) {
		NSString *str;
		BOOL useCurrencyStyle = NO;
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		formatter.allowsFloats = NO;
		formatter.maximumFractionDigits = 0;
		if (useCurrencyStyle) {
			[formatter setNumberStyle:(NSNumberFormatterCurrencyStyle)];
		}
		str = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:@(number)]];
		[tfTotal setText:str];
	}

}

- (BOOL)_shouldReCalculate:(UITextField *)textField {
	BOOL should = NO;
	NSUInteger tag = textField.tag;
	if ((tag-TAG_Offset) <= 4) {
		should = YES;
	}
	return should;
}

- (void)_recalculate:(UITextField *)textField {
	if ([self _shouldReCalculate:textField]) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self calAction:nil];
		});
	} else {
		//
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self reverseCalAction];
		});
	}
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
	[self _recalculate:textField];
	return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	[self _recalculate:textField];
	return YES;
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	CGFloat yOffset = scrollView.contentOffset.y;
	if (yOffset < -30) {
//		|| scrollView.contentOffset.y > (scrollView.contentSize.height -scrollView.bounds.size.height)) {
		[self.view endEditing:YES];
	}
}

@end
