//
//  ViewController.m
//  Localizer
//
//  Created by Agustin De Cabrera on 2/5/13.
//  Copyright (c) 2013 Agustin De Cabrera. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableDictionary *formatters;
    NSArray *locales;
    NSDateFormatter *currentFormatter;
    
    IBOutlet UITextField *_textField;
    IBOutlet UITableView *_tableView;
} 

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    formatters = [NSMutableDictionary dictionary];
    
//    NSArray *availableLocales = [NSLocale availableLocaleIdentifiers];
    NSArray *availableLocales = @[@"en_US", @"en_GB", @"fr_CA", @"fr_FR"];
    
    for (NSString *locale in availableLocales) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:locale];
        formatters[locale] = formatter;
    }
    
    locales = [[formatters allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    currentFormatter = [[NSDateFormatter alloc] init];
    currentFormatter.locale = [NSLocale currentLocale];
}

- (NSString*)formattedTextForLocale:(NSString*)locale
{
    NSDateFormatter *formatter = formatters[locale];
    
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:_textField.text options:0 locale:formatter.locale];

    return [formatter stringFromDate:[NSDate date]];
}
- (NSString*)formattedTextForCurrentLocale
{
    currentFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:_textField.text options:0 locale:currentFormatter.locale];
    
    return [currentFormatter stringFromDate:[NSDate date]];
}

-(IBAction)buttonTapped:(id)sender
{
    [self.view endEditing:YES];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0? 1 : [locales count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const CellIdentifier = @"localeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"current: %@", currentFormatter.locale.localeIdentifier];
        cell.textLabel.text = [self formattedTextForCurrentLocale];
    }
    else {
        cell.detailTextLabel.text = locales[indexPath.row];
        cell.textLabel.text = [self formattedTextForLocale:locales[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end
