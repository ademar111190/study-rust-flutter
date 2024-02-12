import 'dart:async';
import 'package:study/bridge_generated.dart';
import 'package:study/native_toolkit.dart';

class Study {
  final _lnToolkit = getNativeToolkit();

  Study();

  Future<String> hello(
    String world,
  ) async {
    final result = await _lnToolkit.hello(req: HelloRequest(world: world));
    return result.message;
  }

  Future<int> sum(
    int lhs,
    int rhs,
  ) async {
    final result = await _lnToolkit.sum(req: SumRequest(lhs: lhs, rhs: rhs));
    return result.result;
  }
}
