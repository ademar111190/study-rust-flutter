import 'dart:async';
import 'dart:typed_data';

class Study {
  final _lnToolkit = getNativeToolkit();

  Study();

  Future<string> hello(
    string world,
  ) async {
    final result = await _lnToolkit.hello(request: HelloRequest(world: world));
    return result.result;
  }

  Future<int> sum(
    int lhs,
    int rhs,
  ) async {
    final result = await _lnToolkit.sum(request: SumRequest(lhs: lhs, rhs: rhs));
    return result.result;
  }
}
