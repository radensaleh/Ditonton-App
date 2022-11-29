import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class HttpSSLPinning {
  static Future<http.Client> get _instance async =>
      _clientInstance ??= await Shared.createLEClient();
  static http.Client? _clientInstance;
  static http.Client get client => _clientInstance ?? http.Client();
  static Future<void> init() async {
    _clientInstance = await _instance;
  }
}

class Shared {
  static Future<HttpClient> customHttpClient(bool isTestMode) async {
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    List<int> sslCertificate = [];
    if (isTestMode) {
      sslCertificate = utf8.encode(_certificatedString);
    } else {
      sslCertificate = (await rootBundle.load('certificates/certificate.crt'))
          .buffer
          .asUint8List();
    }
    try {
      securityContext.setTrustedCertificatesBytes(sslCertificate);
      log('createHttpClient() - cert added!');
    } on TlsException catch (e) {
      if (e.osError?.message != null &&
          e.osError!.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
        log('createHttpClient() - cert already trusted! Skipping.');
      } else {
        log('createHttpClient().setTrustedCertificateBytes EXCEPTION: $e');
        rethrow;
      }
    } catch (e) {
      log('unexpected error $e');
      rethrow;
    }
    HttpClient httpClient = HttpClient(context: securityContext);
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return httpClient;
  }

  static Future<http.Client> createLEClient({bool isTestMode = false}) async {
    IOClient client = IOClient(await Shared.customHttpClient(isTestMode));
    return client;
  }
}

const _certificatedString = """-----BEGIN CERTIFICATE-----
MIIF6TCCBNGgAwIBAgIQBffjbSRu81JTaCJ3Mmc5MDANBgkqhkiG9w0BAQsFADBG
MQswCQYDVQQGEwJVUzEPMA0GA1UEChMGQW1hem9uMRUwEwYDVQQLEwxTZXJ2ZXIg
Q0EgMUIxDzANBgNVBAMTBkFtYXpvbjAeFw0yMjA5MjAwMDAwMDBaFw0yMzEwMTgy
MzU5NTlaMBsxGTAXBgNVBAMMECoudGhlbW92aWVkYi5vcmcwggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQC7ibOskm1j0mxusryquCqEhTzj0lOjwmpCWTfk
jdmZzOkXqgucHtsm60jOTxwcG5TnLghajaluKnvPBl/EkbgcZMAhwZjCvQ3L/eWM
fcwv0xs/mP8joPNP9AL3wySTYlq/yP2L6DDO3RT6Itzpqk+XCDZC1ifh0eGjxZh+
vkgCm8VZeYyuBDMgOXmAW7UufDFXrJgCuUWtPn2mbofv5S6H5RpupRFtUa8Ef3Iw
P/tZl1qldiS/bP+b60jayiw1nhDfF0IpTrxtfU7DiYnnIbOZmWWx9bMAQYyg3WoE
VVTiJoIZ7OuCzZwSAOSIazfub0pq1QTOwXClypvNIsGPUxhnAgMBAAGjggL8MIIC
+DAfBgNVHSMEGDAWgBRZpGYGUqB7lZI8o5QHJ5Z0W/k90DAdBgNVHQ4EFgQUqhAn
tCBdy8MMZpB2sRBBKJFmK8EwKwYDVR0RBCQwIoIQKi50aGVtb3ZpZWRiLm9yZ4IO
dGhlbW92aWVkYi5vcmcwDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUF
BwMBBggrBgEFBQcDAjA9BgNVHR8ENjA0MDKgMKAuhixodHRwOi8vY3JsLnNjYTFi
LmFtYXpvbnRydXN0LmNvbS9zY2ExYi0xLmNybDATBgNVHSAEDDAKMAgGBmeBDAEC
ATB1BggrBgEFBQcBAQRpMGcwLQYIKwYBBQUHMAGGIWh0dHA6Ly9vY3NwLnNjYTFi
LmFtYXpvbnRydXN0LmNvbTA2BggrBgEFBQcwAoYqaHR0cDovL2NydC5zY2ExYi5h
bWF6b250cnVzdC5jb20vc2NhMWIuY3J0MAwGA1UdEwEB/wQCMAAwggF/BgorBgEE
AdZ5AgQCBIIBbwSCAWsBaQB3AOg+0No+9QY1MudXKLyJa8kD08vREWvs62nhd31t
Br1uAAABg1moMZEAAAQDAEgwRgIhAMVP5djOo7j7Ehc+AjNwJGkkEhlCWARLRwBp
fockK3x2AiEAq8uGTIoc/zq8yZY+7i02OU/QApY96omoR2jSkBwdkUYAdgA1zxkb
v7FsV78PrUxtQsu7ticgJlHqP+Eq76gDwzvWTAAAAYNZqDG/AAAEAwBHMEUCIQDR
RMgwOJIjcMpK+oA0dzfAZOWGejfBEDQNi84qNRv3AQIgOtOxh08xDU5AgB1a6L02
2q3RJKWCoBTrfW4nsgsu8egAdgCzc3cH4YRQ+GOG1gWp3BEJSnktsWcMC4fc8AMO
eTalmgAAAYNZqDIIAAAEAwBHMEUCICNRgi9EFLHNXntNisGG/3mgbEjuNi0dQ+zD
TL+mekizAiEAqUN0J8PCqS8OhNpFjnbblvYyjqAmnyXzpteXujcxNuIwDQYJKoZI
hvcNAQELBQADggEBABpzoRDnIsdErQcTPaQduN8IVH/QZJVKn4OtPEO4fTzxqhvJ
0WAJ8OZ6Qu3+WxE0bbso55zTaTgdGbxV1wSyRyoRvZslVSo1tYeunR3HabsZ4Z9s
54j2Ommyy/pURvcwl0N5kv/WridF9BybAYupvcXq+N/EQwwhet2USd+SCag44/2k
4MSCoTx2+EiyYOrqY60nAyeMHYtFiWsgDcpwdSeS3SoJsKAXFRMAzeHjnX+xZR8r
rFAzldB7viRdim3SimkGfZdRFJz3+Uzs+ewdaDkclhOyADMaDnJadgZHil/jZP3E
m/IyZOLJ6P1ZltyRhJ6ak/1xxoMTH7wk4FMZ47k=
-----END CERTIFICATE-----""";
