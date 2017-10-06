//
//  ViewController.m
//  JSONParsing
//
//  Created by Mac on 20/05/15.
//  Copyright (c) 2015 sri. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize responseData;

- (void)viewDidLoad {
    
    // 1. Create the Request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"Your URL"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: 30.0];
    
    // 2.  Create the connection and send the request
    NSURLConnection *connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // 3.  Make sure that the connection is good
    if (connection) {
        // Instantiate the responseData data structure to store to response
        self.responseData = [NSMutableData data];
        NSLog(@"connected");
    }
    else {
        NSLog (@"The connection failed");
    }
    
    namesArr=[[NSMutableArray alloc]init];

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//4. NSURLConnection Delegate methods

//4. Called when a redirect will cause the URL of the request to change
- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    
    NSLog (@"connection:willSendRequest:redirectResponse:");
    return request;
}


// Called when the server requires authentication
- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog (@"connection:didReceiveAuthenticationChallenge:");
    
}


// Called when the authentication challenge is cancelled on the connection
- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog (@"connection:didCancelAuthenticationChallenge:");
}


// 5. Called when the connection has enough data to create an NSURLResponse
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog (@"connection:didReceiveResponse:");
    NSLog(@"expectedContentLength: %qi", [response expectedContentLength] );
    NSLog(@"textEncodingName: %@", [response textEncodingName]);
    [self.responseData setLength:0];
    
}

// Called each time the connection receives a chunk of data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    NSLog (@"connection:didReceiveData:");
    // Append the received data to our responseData property
    [self.responseData appendData:data];
    NSLog(@"DATA IS %@",self.responseData);
};

// 6. Called when the connection has successfully received the complete response
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog (@"connectionDidFinishLoading:");
    // Convert the data to a string and log the response string
    NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Response String: \n%@", responseString);
    // this is our JSON
    
    // 7 parsing process
    [self parseJSON];
    
    _tableObj=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableObj.dataSource=self;
    _tableObj.delegate=self;
    [self.view addSubview:_tableObj];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

{
    NSLog(@"got error is ....%@",[error localizedDescription]);
}
// 7. parsing process

-(void)parseJSON
{
    NSError *error;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:self.responseData options: NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"dic is %@",dic);
    
    NSArray *imageArr=[dic objectForKey:@"Your Object Name"];
}

// Tableview implementation

//datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return namesArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: [namesArr objectAtIndex:indexPath.row]]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    cell.imageView.image =image;
    return cell;
}
//delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedVal=[NSString stringWithFormat:@"%@",[namesArr objectAtIndex:indexPath.row]];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:selectedVal delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"ok", nil];
    [alert show];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
