import 'dart:io';

void main(List<String> args) {
  if (args.length != 2) {
    stderr.writeln('Usage: dart run tool/check_coverage.dart <lcov> <minimum>');
    exitCode = 64;
    return;
  }

  final lines = File(args[0]).readAsLinesSync();
  var found = 0;
  var hit = 0;
  for (final line in lines) {
    if (line.startsWith('LF:')) {
      found += int.parse(line.substring(3));
    } else if (line.startsWith('LH:')) {
      hit += int.parse(line.substring(3));
    }
  }

  final coverage = found == 0 ? 0 : hit * 100 / found;
  final minimum = double.parse(args[1]);
  stdout.writeln(
    'Dart line coverage: ${coverage.toStringAsFixed(1)}% ($hit/$found)',
  );
  if (coverage < minimum) {
    stderr.writeln(
      'Coverage is below the required ${minimum.toStringAsFixed(1)}%.',
    );
    exitCode = 1;
  }
}
