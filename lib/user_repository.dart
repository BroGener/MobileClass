import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  // 单例模式：确保整个 App 使用的是同一个数据仓库实例
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;
  UserRepository._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // 定义所有需要存储的变量
  String loginName = "";
  String firstName = "";
  String lastName = "";
  String phoneNumber = "";
  String emailAddress = "";

  // 评分标准：loadData 函数 (从安全存储读取)
  Future<void> loadData() async {
    firstName = await _storage.read(key: 'fName') ?? "";
    lastName = await _storage.read(key: 'lName') ?? "";
    phoneNumber = await _storage.read(key: 'phone') ?? "";
    emailAddress = await _storage.read(key: 'email') ?? "";
  }

  // 评分标准：saveData 函数 (保存到安全存储)
  Future<void> saveData() async {
    await _storage.write(key: 'fName', value: firstName);
    await _storage.write(key: 'lName', value: lastName);
    await _storage.write(key: 'phone', value: phoneNumber);
    await _storage.write(key: 'email', value: emailAddress);
  }
}