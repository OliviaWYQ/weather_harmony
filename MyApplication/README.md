# 鸿蒙天气查询应用

这是一个基于鸿蒙Next原生开发的天气查询应用，使用高德地图API获取天气信息。

## 功能特性

- 🌤️ 根据地址查询天气信息
- 📍 支持地理编码，将地址转换为城市信息
- 📊 显示未来几天的天气预报
- 🎨 现代化的UI设计
- 📱 适配手机和平板设备

## 技术栈

- **开发框架**: 鸿蒙Next (HarmonyOS NEXT)
- **开发语言**: ArkTS
- **UI框架**: ArkUI
- **网络请求**: @ohos.net.http
- **API服务**: 高德地图API

## 项目结构

```
WeatherApp/
├── AppScope/                    # 应用级配置
│   ├── app.json5               # 应用配置文件
│   └── resources/              # 应用级资源
├── entry/                      # 主模块
│   ├── src/main/
│   │   ├── ets/
│   │   │   ├── entryability/   # 入口Ability
│   │   │   ├── pages/          # 页面文件
│   │   │   └── common/         # 公共服务
│   │   ├── resources/          # 资源文件
│   │   └── module.json5        # 模块配置
└── build-profile.json5         # 构建配置
```

## 配置说明

### 1. MCP服务配置（推荐）

✅ **已集成真实MCP服务！**

应用已配置使用高德地图MCP服务，在 `.cursor/mcp.json` 中：

```json
{
  "mcpServers": {
    "amap-amap-sse": {
      "url": "https://mcp.amap.com/sse?key=c53a83e2d78a628c652726ba11e88630"
    }
  }
}
```

### 2. 传统API配置（备用）

在 `WeatherService.ets` 文件中，也可以直接使用高德地图API：

```typescript
private static readonly AMAP_KEY = 'your_amap_key_here';
```

### 3. 获取高德地图API Key

1. 访问 [高德开放平台](https://lbs.amap.com/)
2. 注册并登录账号
3. 创建应用，获取API Key
4. 确保开通以下服务：
   - 地理编码API
   - 天气查询API

### 3. 权限配置

应用已配置以下权限：
- `ohos.permission.INTERNET` - 网络访问权限
- `ohos.permission.LOCATION` - 位置权限（可选）

## 开发环境

- **DevEco Studio**: 4.0 或更高版本
- **HarmonyOS SDK**: API 9 或更高版本
- **Node.js**: 16.x 或更高版本

## 构建和运行

### 方式一：使用MCP服务（推荐）

1. **启动MCP桥接服务**：
   ```bash
   cd backend-example
   npm install
   npm start
   # 或者在Windows上双击 start.bat
   ```

2. **运行鸿蒙应用**：
   - 使用DevEco Studio打开项目
   - 连接鸿蒙设备或启动模拟器
   - 点击运行按钮构建并安装应用

### 方式二：直接使用API（备用）

1. 配置高德地图API Key
2. 使用DevEco Studio打开项目
3. 连接鸿蒙设备或启动模拟器
4. 点击运行按钮构建并安装应用

## 使用说明

1. 启动应用
2. 在输入框中输入地址（如：北京市朝阳区）
3. 点击"查询天气"按钮
4. 查看天气预报信息

## API接口

### 地理编码API
- **接口**: `https://restapi.amap.com/v3/geocode/geo`
- **功能**: 将地址转换为经纬度和城市信息

### 天气查询API
- **接口**: `https://restapi.amap.com/v3/weather/weatherInfo`
- **功能**: 根据城市编码获取天气预报

## 注意事项

1. 确保设备已连接网络
2. 高德地图API有调用频率限制
3. 建议在真机上测试网络功能
4. 图标文件需要替换为实际的PNG图片

## 许可证

MIT License

## 贡献

欢迎提交Issue和Pull Request来改进这个项目。 