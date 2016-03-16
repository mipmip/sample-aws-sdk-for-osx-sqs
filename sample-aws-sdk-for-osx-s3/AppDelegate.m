//
//  AppDelegate.m
//  sample-aws-sdk-for-osx-s3
//
//  Created by Pim Snel on 16-03-16.
//  Copyright © 2016 Lingewoud. All rights reserved.
//

#import "AppDelegate.h"
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>

NSString *const S3BucketName = @"MyBucketName";
NSString *const CognitoPoolId = @"CongnitoPoolId";

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionEUWest1
                                                          identityPoolId:CognitoPoolId];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUWest1 credentialsProvider:credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    [self listObjects:self];

}

- (void)listObjects:(id)sender {
    AWSS3 *s3 = [AWSS3 defaultS3];
    
    AWSS3ListObjectsRequest *listObjectsRequest = [AWSS3ListObjectsRequest new];
    listObjectsRequest.bucket = S3BucketName;
    [[s3 listObjects:listObjectsRequest] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"listObjects failed: [%@]", task.error);
        } else {
            AWSS3ListObjectsOutput *listObjectsOutput = task.result;
            for (AWSS3Object *s3Object in listObjectsOutput.contents) {
                NSString *downloadingFilePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"download"] stringByAppendingPathComponent:s3Object.key];
                NSURL *downloadingFileURL = [NSURL fileURLWithPath:downloadingFilePath];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:downloadingFilePath]) {
                    NSLog(@"downloadingURL: %@", downloadingFileURL);
                } else {
                    AWSS3TransferManagerDownloadRequest *downloadRequest = [AWSS3TransferManagerDownloadRequest new];
                    downloadRequest.bucket = S3BucketName;
                    downloadRequest.key = s3Object.key;
                    downloadRequest.downloadingFileURL = downloadingFileURL;
                    NSLog(@"downloadingReq: %@", downloadRequest);
                }
            }

        }
        return nil;
    }];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
