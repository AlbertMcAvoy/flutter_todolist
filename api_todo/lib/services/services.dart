import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:get_it/get_it.dart';

const jwtSecret = 'QDSFQ%\$WBTVQWEVTQ\$ TvqweRQWRQWEFQWCFQW RQ';

class Services {
  final String EMAIL = 'auvergne@aurillac.com'; 
  final String PASSWORD = 'azerty';

  final jwtSigner = JWTHmacSha256Signer(jwtSecret);

  Services();
}

Services get services => GetIt.instance.get<Services>();