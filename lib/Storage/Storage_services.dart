import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:debtsettler_v4/Storage/StorageItem_model.dart';


class StorageService {
  final _secureStorage = const FlutterSecureStorage();

  // ACCESSIBILITY ZA IOs IN Android
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  IOSOptions _getIOSOptions() => const IOSOptions(
    accessibility: IOSAccessibility.first_unlock,
  );



  Future<void> writeSecureData(StorageItem newItem) async {
    debugPrint("Writing new data having key ${newItem.key}");
    await _secureStorage.write(
        key: newItem.key, value: newItem.value, aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
  }

  Future<String?> readSecureData(String key) async {
    debugPrint("Reading data having key $key");
    var readData =
    await _secureStorage.read(key: key, aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
    return readData;
  }

  Future<void> deleteSecureData(String key) async {
    debugPrint("Deleting data having key key");
    await _secureStorage.delete(key: key, aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
  }

  Future<List<StorageItem>> readAllSecureData() async {
    debugPrint("Reading all secured data");
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
    List<StorageItem> list =
    allData.entries.map((e) => StorageItem(e.key, e.value)).toList();
    return list;
  }

  Future<void> deleteAllSecureData() async {
    debugPrint("Deleting all secured data");
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
  }

  Future<bool> containsKeyInSecureData(String key) async {
    debugPrint("Checking data for the key $key");
    var containsKey = await _secureStorage.containsKey(
        key: key, aOptions: _getAndroidOptions(), iOptions: _getIOSOptions());
    return containsKey;
  }
}