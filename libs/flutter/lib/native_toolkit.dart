import 'dart:ffi';
import 'dart:io';
import 'bridge_generated.dart';

StudyCore? _bindings;

const _libName = "libbindings.so";

class UnsupportedPlatform implements Exception {
  UnsupportedPlatform(String s);
}

StudyCore getNativeToolkit() {
  if (_bindings == null) {
    if (Platform.isAndroid || Platform.isLinux) {
      // On Linux the lib needs to be in LD_LIBRARY_PATH or working directory
      _bindings = StudyCoreImpl(DynamicLibrary.open(_libName));
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and macOS are statically linked
      _bindings = StudyCoreImpl(DynamicLibrary.process());
    } else {
      throw UnsupportedPlatform('${Platform.operatingSystem} is not yet supported!');
    }
  }
  return _bindings!;
}
