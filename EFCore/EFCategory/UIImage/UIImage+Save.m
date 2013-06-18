//
// Created by yizhuolin on 12-9-29.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIImage+Save.h"


@implementation UIImage (Save)

- (BOOL)writeToPath:(NSString *)path
{
    @try {
        if ([path length]) {
            NSString *ext = [path pathExtension];

            NSData *imageData = [[ext lowercaseString] isEqualToString:@"png"] ?
                                UIImagePNGRepresentation(self) :
                                UIImageJPEGRepresentation(self, 0);

            if ([imageData length]) {
                NSString *dirPath = [path stringByDeletingLastPathComponent];
                if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                [imageData writeToFile:path atomically:YES];

                return YES;
            }
        }

        return NO;

    } @catch (NSException *exception) {
        return NO;
    }
}

@end