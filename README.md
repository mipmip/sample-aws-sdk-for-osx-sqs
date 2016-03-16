# Sample AWS SDK FOR OSX S3

This sample app demonstrates how to integrate a fork of the official AWS
SDK (v2) to OSX. It's minimal just to show you how to start.

## Usage

Replace these constants in AppDelegate:

```objective-c
NSString *const S3BucketName = @"MyBucketName";
NSString *const CognitoPoolId = @"CongnitoPoolId";
```
I use region EU-West1. You propably want to replace all region codes to
some other region. Search and replace ```AWSRegionEUWest1```

Building:

* run ```Pod install```
* open de workspace to build

That's it. Read the official AWSiOS SDK Reference for all information.

Sponsored by [Lingewoud](http://www.lingewoud.com)
Sponsored by [MunsterMade](http://www.munstermade.com)
Sponsored by [Kaftmeister](http://www.kaftmeister.com)
