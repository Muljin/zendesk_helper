#import "ZendeskHelper.h"
#if __has_include(<zendesk_helper/zendesk_helper-Swift.h>)
#import <zendesk_helper/zendesk_helper-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "zendesk_helper-Swift.h"
#endif

@implementation ZendeskHelper
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftZendeskHelper registerWithRegistrar:registrar];
}
@end
