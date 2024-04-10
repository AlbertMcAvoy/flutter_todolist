import 'package:alfred/alfred.dart';
import 'package:api_todo/services/services.dart';
import 'package:corsac_jwt/corsac_jwt.dart';

class Authenthication {

  static login(HttpRequest req, HttpResponse res) async {
    final body = await req.bodyAsJsonMap;
    final email = body['email'];
    final password = body['password'];

    if (email == null || email == '' || 
        password == null || password == ''
      ) {
        throw AlfredException(401, {'message': 'Invalid credentials'});
    }

    if (email == services.EMAIL && password == services.PASSWORD) {
       var token = JWTBuilder()
        ..issuer = 'http://localhost'
        ..expiresAt = DateTime.now().add(Duration(hours: 3))
        ..setClaim('data', {'email': services.EMAIL})
        ..getToken();

      var signedToken = token.getSignedToken(services.jwtSigner);

      return {'token': signedToken.toString()};
    } else {
      throw AlfredException(401, {'message': 'Invalid credentials'});
    }
  }
}