import 'package:grpc/grpc.dart';

import 'package:dartminator/dartminator.dart';
import 'package:dartminator/constants.dart';
import 'package:dartminator/logger.dart';
import 'package:dartminator/cli.dart';

Future<void> main(List<String> args) async {
  var logger = getLogger();

  try {
    var options = handleCLI(args);

    final node =
        DartminatorNode(options.name, options.port, options.maxChildren);

    final server = Server([node], const <Interceptor>[],
        CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]));

    logger.i('Starting the node ${options.name}');

    await server.serve(port: grpcPort);
    node.init();
  } catch (err, stacktrace) {
    logger.e('The node has failed terribly!');
    logger.e(err);
    logger.e(stacktrace);
  }
}