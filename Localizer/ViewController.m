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
}

- (NSString*)formattedTextForLocale:(NSString*)locale
{
    NSDateFormatter *formatter = formatters[locale];
    
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:_textField.text options:0 locale:formatter.locale];

    return [formatter stringFromDate:[NSDate date]];
}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
