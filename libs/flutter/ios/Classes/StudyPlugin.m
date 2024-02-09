#import "StudyPlugin.h"
#import "bridge_generated.h"
#if __has_include(<study/study-Swift.h>)
#import <study/study-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "StudyPlugin.h"
#endif

@implementation StudyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {  
  dummy_method_to_enforce_bundling();
}
@end
