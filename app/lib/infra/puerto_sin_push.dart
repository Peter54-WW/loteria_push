import '../dominio/api_juego.dart';
import '../dominio/puerto_push.dart';

/// Se usa cuando Firebase NO está configurado (no hay google-services.json).
/// La app sigue funcionando: consulta al cantor cada 5 s (degradación elegante).
class PuertoSinPush implements PuertoPush {
  @override
  Future<PermisoPush> estadoPermiso() async => PermisoPush.denegado;

  @override
  Future<PermisoPush> pedirPermiso() async => PermisoPush.denegado;

  @override
  Future<DestinoPush?> obtenerDestino() async => null;

  @override
  Stream<DestinoPush> get destinoCambiado => const Stream.empty();

  @override
  Stream<MensajePush> get enPrimerPlano => const Stream.empty();

  @override
  Stream<MensajePush> get alAbrirDesdeNotificacion => const Stream.empty();

  @override
  Future<MensajePush?> mensajeInicial() async => null;

  @override
  Future<void> suscribirTema(String tema) async {}

  @override
  Future<void> desuscribirTema(String tema) async {}
}
