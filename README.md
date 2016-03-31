# Sample AWS SDK FOR OSX SQS
This sample app demonstrates how to integrate a fork of the official AWS
SDK (v2) ported to OSX. It's very minimal just to show you how to start.

This sample demonstrates the AWS SDK found at https://github.com/mipmip/aws-sdk-ios

## Usage
Replace these constants in AppDelegate:

create a file in the root of the project named cognitopoolid.txt with the CognitoPoolId you want
to use.

```bash
echo "region:string" > cognitopoolid.txt
```

I use region EU-West1. You propably want to replace all region codes to
some other region. Search and replace ```AWSRegionEUWest1```

Building:

* run ```Pod install```
* open de workspace to build

That's it. Read the official AWSiOS SDK Reference for all information.

## Links
- [Official AWS iOS-only SDK](https://github.com/aws/aws-sdk-ios)
- [AWS SDK fork for OSX](https://github.com/mipmip/aws-sdk-ios)

## Credits
- Sponsored by [Lingewoud](http://www.lingewoud.com)
- Sponsored by [MunsterMade](http://www.munstermade.com)
- Sponsored by [Kaftmeister](http://www.kaftmeister.com)
