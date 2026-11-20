import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'dominio/controlador.dart';
import 'dominio/puerto_push.dart';
import 'infra/almacen_prefs.dart';
import 'infra/api_http.dart';
import 'infra/canales_android.dart';
import 'infra/fondo.dart';
import 'infra/puerto_fcm.dart';
import 'infra/puerto_sin_push.dart';
import 'presentacion/vms.dart';

// 10.0.2.2 es el "localhost" de tu computadora visto desde el emulador de Android.
// En un teléfono real usa la IP de tu computadora (misma red wifi); se cambia desde la app.
const String urlServidor = String.fromEnvironment('SERVIDOR', defaultValue: 'http://10.0.2.2:8080');
const _claveServidor = 'url_servidor';

/// Firebase es OPCIONAL: sin google-services.json la app juega consultando al cantor.
Future<PuertoPush> _crearPuertoPush() async {
  try {
    await Firebase.initializeApp();
    // El manejador de fondo se registra ANTES de runApp.
    FirebaseMessaging.onBackgroundMessage(manejadorSegundoPlano);
    // En iOS, con la app al frente el sistema NO muestra el banner: la app lo pinta.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: false, badge: false, sound: false);
    return PuertoFcm();
  } on Object {
    return PuertoSinPush();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final push = await _crearPuertoPush();
  try {
    await crearCanalesAndroid();
  } on Object {
    // sin canales igual se puede jugar
  }

  final servidor = ValueNotifier<String>(prefs.getString(_claveServidor) ?? urlServidor);
  final api = ApiHttp(servidor.value);
  servidor.addListener(() {
    api.base = servidor.value;
    prefs.setString(_claveServidor, servidor.value);
  });

  final controlador = ControladorPartida(api: api, push: push, almacen: AlmacenPrefs(prefs));
  runApp(AppLoteria(vm: JuegoVm(controlador), crearCantor: () => CantorVm(api), servidor: servidor));
}
