import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Se ejecuta en un "isolate" APARTE cuando llega un mensaje con la app en segundo plano
/// o cerrada. Reglas de oro:
/// - DEBE ser una función de nivel superior (no un método ni una lambda).
/// - DEBE llevar @pragma('vm:entry-point') o el compilador puede eliminarla (release).
/// - No comparte memoria con la app: NO toca la interfaz ni tu controlador.
/// - Debe ser breve: al volver a abrir la app, el controlador pregunta al servidor.
@pragma('vm:entry-point')
Future<void> manejadorSegundoPlano(RemoteMessage mensaje) async {
  // Con google-services.json en android/app, initializeApp() toma la configuración de ahí.
  await Firebase.initializeApp();
}
