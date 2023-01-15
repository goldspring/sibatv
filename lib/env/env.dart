import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
class Env {
  @EnviedField(obfuscate: true, varName: 'NIM_API_KEY')
  static String nimApiKey = _Env.nimApiKey;
  @EnviedField(obfuscate: true, varName: 'NIM_WEB_LINKADDR')
  static String nimWebLinkAddr = _Env.nimWebLinkAddr;
  @EnviedField(obfuscate: true, varName: 'NIM_LINKADDR')
  static String nimLinkAddr = _Env.nimLinkAddr;
}
