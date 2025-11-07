import 'interfaces/panel_sdk_interface.dart';
import 'providers/xboard_sdk_provider.dart';
import 'providers/v2board_sdk_provider.dart';
import '../config/xboard_config.dart';

/// 面板 SDK 工厂类
/// 
/// 根据配置自动创建和切换 SDK Provider
class PanelSDKFactory {
  static PanelSDKInterface? _currentProvider;
  static String? _currentPanelType;
  
  /// 获取当前的 SDK Provider
  static PanelSDKInterface? get currentProvider => _currentProvider;
  
  /// 获取当前的面板类型
  static String? get currentPanelType => _currentPanelType;
  
  /// 创建或获取 SDK Provider
  /// 
  /// 根据 [panelType] 自动创建对应的 SDK Provider
  /// 如果已存在相同类型的 Provider，则直接返回
  /// 如果类型不同，则销毁旧的并创建新的
  static Future<PanelSDKInterface> createProvider({
    required String panelType,
    required String baseUrl,
    Map<String, dynamic>? config,
  }) async {
    // 如果已存在且类型相同，直接返回
    if (_currentProvider != null && _currentPanelType == panelType) {
      return _currentProvider!;
    }
    
    // 销毁旧的 Provider
    if (_currentProvider != null) {
      _currentProvider!.dispose();
      _currentProvider = null;
    }
    
    // 创建新的 Provider
    PanelSDKInterface provider;
    
    switch (panelType.toLowerCase()) {
      case 'xboard':
        provider = XBoardSDKProvider();
        break;
      case 'v2board':
        provider = V2BoardSDKProvider();
        break;
      default:
        throw Exception('Unsupported panel type: $panelType. Supported types: xboard, v2board');
    }
    
    // 初始化 SDK
    await provider.initialize(
      baseUrl: baseUrl,
      config: config,
    );
    
    _currentProvider = provider;
    _currentPanelType = panelType;
    
    return provider;
  }
  
  /// 从 XBoardConfig 自动创建 Provider
  /// 
  /// 读取配置文件中的 panelType 和 baseUrl
  /// 自动创建对应的 SDK Provider
  static Future<PanelSDKInterface> createFromConfig() async {
    // 获取配置
    final config = XBoardConfig.instance;
    final settings = config.settings;
    
    if (settings == null) {
      throw Exception('XBoardConfig not initialized. Call XBoardConfig.init() first.');
    }
    
    final panelType = settings.panelType;
    final baseUrl = config.currentPanelUrl;
    
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception('Panel URL not configured in XBoardConfig');
    }
    
    // 构建 SDK 配置
    final sdkConfig = <String, dynamic>{
      'userAgent': 'FlClash-XBoard-SDK/1.0',
      'timeout': const Duration(seconds: 30),
    };
    
    return await createProvider(
      panelType: panelType,
      baseUrl: baseUrl,
      config: sdkConfig,
    );
  }
  
  /// 切换到不同的面板类型
  /// 
  /// 销毁当前 Provider 并创建新的
  static Future<PanelSDKInterface> switchPanel({
    required String panelType,
    required String baseUrl,
    Map<String, dynamic>? config,
  }) async {
    // 强制销毁旧的
    if (_currentProvider != null) {
      _currentProvider!.dispose();
      _currentProvider = null;
      _currentPanelType = null;
    }
    
    return await createProvider(
      panelType: panelType,
      baseUrl: baseUrl,
      config: config,
    );
  }
  
  /// 释放当前 Provider
  static void dispose() {
    _currentProvider?.dispose();
    _currentProvider = null;
    _currentPanelType = null;
  }
  
  /// 检查是否已初始化
  static bool get isInitialized => _currentProvider != null;
  
  /// 检查是否已认证
  static bool get isAuthenticated => _currentProvider?.isAuthenticated ?? false;
}

