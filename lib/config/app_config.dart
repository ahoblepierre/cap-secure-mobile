// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:get_storage/get_storage.dart';

final box = GetStorage();

const BASE_URL = "https://shapchange.com/api/";

// const BASE_URL = "http://127.0.0.1:8000/api/";

enum Statut {
  SUCCESS,
  ERROR,
  WARNING,
}

Uri getUrl(String url) {
  log("✅ ENDPOINT : $BASE_URL$url");
  return Uri.parse("$BASE_URL$url");
}

Map<String, String> get headersWithToken => {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": 'Bearer ${box.read('token')}'
    };

Map<String, String> get headers => {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
