//
//  AppDelegate.m
//  sample-aws-sdk-for-osx-sqs
//
//  Created by Pim Snel on 16-03-16.
//  Copyright © 2016 Lingewoud. All rights reserved.
//

#import "AppDelegate.h"
#import <AWSCore/AWSCore.h>
#import <AWSsqs/AWSsqs.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *cognitoPoolId;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
   
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cognitopoolid" ofType:@"txt"];
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray* allLinedStrings = [fileContents componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    self.cognitoPoolId = [allLinedStrings objectAtIndex:0];
}

-(IBAction) fill:(id) sender {

    NSLog(@"filling");
    
    NSString *key = @"testCreateQueue";
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionEUWest1
                                                          identityPoolId:self.cognitoPoolId];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc]
                                              initWithRegion:AWSRegionEUWest1 credentialsProvider:credentialsProvider];

    [AWSSQS registerSQSWithConfiguration:configuration forKey:key];
    
    AWSSQSCreateQueueRequest *queueRequest = [[AWSSQSCreateQueueRequest alloc] init];
    [queueRequest setQueueName:@"TEST_Q2_NEW_4"];
    
    id sqs =[AWSSQS SQSForKey:key];
    [[[sqs createQueue:queueRequest] continueWithBlock:^id(AWSTask *task) {
        NSLog(@"createq error: %@", task.error);
        NSLog(@"createq result: %@", [task.result class]);
        
        if([task.result isKindOfClass:[AWSSQSCreateQueueResult class]]){

            AWSSQSSendMessageRequest *sendMessageRequest = [[AWSSQSSendMessageRequest alloc] init];
            [sendMessageRequest setMessageBody:@"hallo"];
            [sendMessageRequest setQueueUrl:[task.result queueUrl]];
            
            [[[sqs sendMessage:sendMessageRequest] continueWithBlock:^id(AWSTask *task) {
                NSLog(@"send error: %@", task.error);
                NSLog(@"send result: %@", task.result);
                if(task.result){
                    self.messageId = [task.result messageId];
                }
                    
                return nil;
            }] waitUntilFinished];
        }
        
        return nil;
    }] waitUntilFinished];
}

-(IBAction) poll:(id) sender {
    NSLog(@"polling: %@",self.messageId);
    
    NSString *key = @"testCreateQueue";
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionEUWest1
                                                          identityPoolId:self.cognitoPoolId];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc]
                                              initWithRegion:AWSRegionEUWest1 credentialsProvider:credentialsProvider];
    
    [AWSSQS registerSQSWithConfiguration:configuration forKey:key];
    
    AWSSQSCreateQueueRequest *queueRequest = [[AWSSQSCreateQueueRequest alloc] init];
    [queueRequest setQueueName:@"TEST_Q2_NEW_4"];
    
    id sqs =[AWSSQS SQSForKey:key];
    [[[sqs createQueue:queueRequest] continueWithBlock:^id(AWSTask *task) {
        NSLog(@"createq error: %@", task.error);
        NSLog(@"createq result: %@", [task.result class]);
        
        if([task.result isKindOfClass:[AWSSQSCreateQueueResult class]]){
            
            AWSSQSReceiveMessageRequest *receiveMessageRequest = [[AWSSQSReceiveMessageRequest alloc] init];

            [receiveMessageRequest setQueueUrl:[task.result queueUrl]];
            
            [[[sqs receiveMessage:receiveMessageRequest] continueWithBlock:^id(AWSTask *task) {
                NSLog(@"send error: %@", task.error);
                NSLog(@"send result: %@", task.result);
                
                return nil;
            }] waitUntilFinished];
        }
        
        return nil;
    }] waitUntilFinished];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
