//
//  ViewController.h
//  JSONParsing
//
//  Created by Mac on 20/05/15.
//  Copyright (c) 2015 sri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *namesArr;
}
@property(strong,nonatomic)  UITableView *tableObj;
@property (nonatomic,strong) NSMutableData *responseData;
@property (nonatomic, strong) NSArray<NSURL *> *imageURLs;
@end

