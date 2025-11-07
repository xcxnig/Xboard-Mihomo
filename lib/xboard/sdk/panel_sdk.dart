/// 面板 SDK 统一导出
/// 
/// 提供 XBoard 和 V2Board 的统一访问接口
library panel_sdk;

// ========== 核心接口 ==========
export 'interfaces/panel_sdk_interface.dart';

// ========== Provider 实现 ==========
export 'providers/xboard_sdk_provider.dart';
export 'providers/v2board_sdk_provider.dart';

// ========== 工厂和管理器 ==========
export 'panel_sdk_factory.dart';
export 'panel_sdk_manager.dart';

