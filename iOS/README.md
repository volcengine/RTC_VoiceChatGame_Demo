游戏房是火山引擎实时音视频提供的一个开源示例项目。本文介绍如何快速跑通该示例项目，体验 RTC 游戏房效果。

## 应用使用说明

使用该工程文件构建应用后，即可使用构建的应用进行游戏房 demo 代码的编译。
你和你的同事必须加入同一个房间，才能进行游戏房 demo 体验。

## 前置条件

- [Xcode](https://developer.apple.com/download/all/?q=Xcode) 12.0+
	

- iOS 12.0+ 真机
	

- 有效的 [AppleID](http://appleid.apple.com/)
	

- 有效的 [火山引擎开发者账号](https://console.volcengine.com/auth/login)
	

- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started) 1.10.0+
	

## 操作步骤

### **步骤 1：获取 AppID 和 AppKey**

在火山引擎控制台->[应用管理](https://console.volcengine.com/rtc/listRTC)页面创建应用或使用已创建应用获取 AppID 和 AppAppKey

### **步骤 2：获取 AccessKeyID 和 SecretAccessKey**

在火山引擎控制台-> [密钥管理](https://console.volcengine.com/iam/keymanage/)页面获取 AccessKeyID 和 SecretAccessKey

### **步骤 3：请联系火山引擎技术支持（yinchang.ian@bytedance.com)获取游戏AppId和游戏 AppKey、SerectKey、Loginurl、Bundle ID**

### **步骤 4：搭建服务端配置相关接口**

1. 联系火山技术支持申请 sud_app_id
	

2. 联系火山技术支持配置 sud_app_id 对应的测试环境，配置四个回调接口路由：get_ss_token，update_ss_token，get_user_info，report_game_info。
	

3. 联系火山技术支持开通 服务端 sdk 仓库权限，获取生成和反解析 sud_code , ss_token 源代码。
	

4. 使用sdk 代码填入游戏 AppId 和 SerectKey，构建 get_sud_code 接口。
	

get_sud_code 入参和出参如下：<br>
入参：

| 参数名 | 描述 |
| --- | --- |
| login_token | 会控 token |
| user_id | 用户唯一标识 |

出参：

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| sud_code | String | 获取的 sud_code |
| expire_time | Int64 | 超时时间 |

### **步骤 5：构建工程**

1. 打开终端窗口，进入 `RTC_GameRoom_Demo-master/iOS/veRTC_Demo_iOS` 根目录。
	

![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_f5e214bd1a0e4c81d08b3845ad5c7a40.png)

2. 执行 `pod install` 命令构建工程。
	

![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_39898cd714c39e6208da8eec45b58bce.png)

3. 进入 `RTC_GameRoom_Demo-master/iOS/veRTC_Demo_iOS` 根目录，使用 Xcode 打开 `veRTC_Demo.xcworkspace`。
	

![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_d5eb15f14ff507c6659c500abade95d5.png)

4. 填写 **LoginUrl**。
	

进入 `Pods/Development Pods/Core/BuildConfig.h` 文件，填写 LoginUrl

当前你可以使用 https://common.rtc.volcvideo.com/rtc\_demo\_special/login 作为测试服务器域名，仅提供跑通测试服务，无法保障正式需求。

![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_27172dd3144eff55bf684dcddb0b296a.png)

5. 填写 **APPID、APPKey、AccessKeyID 和 SecretAccessKey**。
	

进入 `Pods/Development Pods/JoinRTSParams/RTCBuildConfig.h` 文件，使用获取的火山 APPID、APPKey、AccessKeyID 和 SecretAccessKey** 填写到 `RTCBuildConfig.h`文件的对应位置
![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_09ddbf0544bb7ba315712cf5f57a9ef0.png)

6. 填写游戏AppID、游戏AppKey 和 游戏 Login_url。
	

进入`Pods/Development Pods/GameRoomParams/GameRoomBuildConfig.h`文件，使用获取的游戏 AppID、游戏 AppKey 和 游戏 Login_url 填写到文件的对应位置。
![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_e44314db0a1261e8cf80ba076a9ff84d.png)

### **步骤 6：配置开发者证书**

1. 将手机连接到电脑，在 `iOS Device` 选项中勾选您的 iOS 设备。
	

![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_8aed3aefac9ac8f56031a108fa6aa343.png)

2. 登录 Apple ID。
	

2.1 选择 Xcode 页面左上角 Xcode >Preferences，或通过快捷键 Command +,打开 Preferences。
2.2 选择 Accounts，点击左下部 +，选择 Apple ID 进行账号登录。
![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_21b6e24f8a6b9bceb235bc8c8e6fc807.png)

3. 单击 Xcode 左侧导航栏中的 `VeRTC_Demo` 项目，单击 `TARGETS` 下的 `MeetingScreenShare` 项目，右键选择 `delete`。
	

![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_5587cfb1fc40cc4b13298a0528bf75cc.png)

4. 单击 `TARGETS` 下的 `VeRTC_Demo` 项目，单击 `Build Setting`,删除`Signing`下 `Code Signing Entitlements` 的值。
	

![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_bbe1b0b40efed884301bea2190a2a697.png)

5. 配置开发者证书。
	

3.1 单击 Xcode 左侧导航栏中的 `VeRTC_Demo` 项目，单击 `TARGETS` 下的 `VeRTC_Demo` 项目，选择 **Signing & Capabilities** > **Automatically manage signing** 自动生成证书
![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_20442bfc4c59ff3caee5324eb9385121.png)
3.2 在 **Team** 中选择 Personal Team。
![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_d6f1254a434b9e9163285d0f41dc401a.png)
3.3 **修改 Bundle** **Identifier**。
填入获取的 BundleID。
![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_b51c1dea8236317813070a36622cfbdd.png)

### **步骤 7：编译运行**

选择 **Product** > **Run**， 开始编译。编译成功后你的 iOS 设备上会出现新应用。若为免费苹果账号，需先在`设置->通用-> VPN与设备管理 -> 描述文件与设备管理`中信任开发者 APP。
![](https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_85893961038a5b9b35c09815f71394ef.png)

运行开始界面如下：

<img src="https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_3e01c96c1285c906ac15aad58b96dcbd.jpg" width="200px" > 