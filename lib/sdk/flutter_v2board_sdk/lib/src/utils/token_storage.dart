/// Token 存储管理
/// 
/// 负责 token 的持久化存储
class TokenStorage {
  static const String _tokenKey = 'v2board_auth_token';
  String? _token;
  
  /// 保存 Token
  Future<void> saveToken(String token) async {
    _token = token;
    // TODO: 使用 shared_preferences 或其他方式持久化存储
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString(_tokenKey, token);
  }
  
  /// 获取 Token
  Future<String?> getToken() async {
    if (_token != null) {
      return _token;
    }
    // TODO: 从持久化存储读取
    // final prefs = await SharedPreferences.getInstance();
    // _token = prefs.getString(_tokenKey);
    return _token;
  }
  
  /// 清除 Token
  Future<void> clearToken() async {
    _token = null;
    // TODO: 从持久化存储清除
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove(_tokenKey);
  }
}

