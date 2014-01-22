//
// Created by Mikkel Gravgaard on 21/01/14.
// Copyright (c) 2014 Betafunk. All rights reserved.
//

#import "CSSSelectorViewController.h"
#import "ReactiveCocoa.h"
#import "HTMLReader.h"
#import "PlaylistReader.h"

@interface CSSSelectorViewController ()
@property(nonatomic, copy) NSString *html;
@end

@implementation CSSSelectorViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error;
    NSString *url = [PlaylistReader urlForChannel:kP6Beat date:[NSDate date]];
    self.html = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:kCFStringEncodingUTF8 error:&error];
    NSCAssert(!error, @"error: %@",error);

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 50)];
    textField.backgroundColor = [UIColor yellowColor] ;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:textField];

    HTMLDocument *document = [HTMLDocument documentWithString:self.html];
    [textField.rac_textSignal subscribeNext:^(id x) {
        @try {
            NSArray *array = [document nodesMatchingSelector:textField.text];
            NSLog(@"%@ returned %d nodes:",textField.text, array.count);
            [array enumerateObjectsUsingBlock:^(HTMLElementNode *node, NSUInteger idx, BOOL *stop) {
                NSLog(@"%@",node.innerHTML);
            }];

        } @catch(NSException *e) {
            NSLog(@"error: %@",e);
        }

    }];

}




@end