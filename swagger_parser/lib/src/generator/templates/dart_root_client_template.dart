import '../../utils/case_utils.dart';
import '../../utils/utils.dart';
import '../models/open_api_info.dart';

String dartRootClientTemplate({
  required OpenApiInfo openApiInfo,
  required String name,
  required Set<String> clientsNames,
  required String postfix,
  required bool putClientsInFolder,
  required bool markFileAsGenerated,
}) {
  if (clientsNames.isEmpty) {
    return '';
  }

  final className = name.toPascal;

  final title = openApiInfo.title;
  final version = openApiInfo.version;

  final comment =
      '${title ?? ''}${version != null ? ' `v$version`' : ''}';

  return '''
${generatedFileComment(
    markFileAsGenerated: markFileAsGenerated,
  )}import 'package:injectable/injectable.dart';
import 'package:rider/core/injector.dart';
import 'package:rider/api/api.dart';
import 'package:rider/core/config/app_config.dart';

${descriptionComment(comment)}
@Singleton(order: -50)
class $className {
  $className({
    NetRequest? dio,
    String? baseUrl,
  })  : _dio = dio ?? locator<NetRequest>(),
        _baseUrl = baseUrl;

  final NetRequest _dio;
  final String? _baseUrl;

  @factoryMethod
  static $className create() => $className(dio: NetRequest(), baseUrl: AppConfig.apiUrl);

${_privateFields(clientsNames, postfix)}

${_getters(clientsNames, postfix)}
}
''';
}

String _clientsImport(
  Set<String> imports,
  String postfix, {
  required bool putClientsInFolder,
}) =>
    '\n${imports.map(
          (import) =>
              "import '${putClientsInFolder ? 'clients' : import.toSnake}/"
              "${'${import}_$postfix'.toSnake}.dart';",
        ).join('\n')}\n';

String _privateFields(Set<String> names, String postfix) => names
    .map((n) => '  ${n.toPascal + postfix.toPascal}? _${n.toCamel};')
    .join('\n');

String _getters(Set<String> names, String postfix) => names
    .map(
      (n) => '  ${n.toPascal + postfix.toPascal} get ${n.toCamel} => '
          '_${n.toCamel} ??= ${n.toPascal + postfix.toPascal}(_dio, baseUrl: _baseUrl);',
    )
    .join('\n\n');
