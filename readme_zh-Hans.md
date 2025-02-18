<img src="./TrialMacAppGUI/Assets.xcassets/AppIcon.appiconset/icon_1024X1024 1.png" width="160" alt="App icon" align="left"/>

<div>
<h3>TrialMacAppGUI</h3>
<p>更改软件逻辑，以达到延长许多应用程序试用时间的目的</p>
<a href="https://github.com/TrialAppleApp/trial-macOS-app/releases/latest">Download for macOS</a>
</div>

<br/>
<br/>

<div align="center">

![](https://img.shields.io/github/downloads/TrialAppleApp/trial-macOS-app/total.svg?style=flat)
![](https://img.shields.io/github/release-pre/TrialAppleApp/trial-macOS-app.svg?style=flat)
![](https://img.shields.io/badge/platform-macOS-blue.svg?style=flat)
![](https://img.shields.io/github/license/TrialAppleApp/trial-macOS-app)
![](https://img.shields.io/github/stars/TrialAppleApp/trial-macOS-app)
![](https://img.shields.io/github/forks/TrialAppleApp/trial-macOS-app)

<br/>
<br/>

<a href="readme.md">English</a> | <a href="readme_zh-Hans.md">简体中文</a>

</div>

<hr>

## 支持的 app

<a href="app.md">点我查看</a>

## 特殊app激活方式

<a href="special_app.md">点我查看</a>

## 特点

- Swift 原生应用
- SwiftUI 编写交互界面 拒绝 Appkit
- 密码使用钥匙串加密
- 原生代码编写注入插件
- **代码开源且免费**
- **破解所有 APP 都不需要关闭 SIP**

### 比其他破解软件的优势

- 从官网或 Mac App Store 下载原版软件，保证来源安全
- 支持列表中的支持版本是任意版本的这一列程序，当他发布新版本后，可立即升级使用新版本（一般适用于大版本，例如 1.xx 适用，2.xx 可能不适用）

## 使用教程

1. 在官网或 Mac App Store 下载软件（是否是 Mac App Store 可以根据<a href="app.md">所有支持的 app</a>列表查看）
2. 打开 TrialMacAppGUI 进行使用（可以参考下方的视频）

### 演示视频

https://github.com/user-attachments/assets/5c7e4ae3-f8b4-45db-be5d-094ebabb2a42

## macOS compatibility

macOS 13 or newer

## 如何编译

### Required

- Xcode

### Build steps

- Clone the project via this Terminal command:

```sh
git clone git@github.com:TrialAppleApp/trial-macOS-app.git
```

### Third party dependencies

- [Sparkle](https://github.com/sparkle-project/Sparkle)

## FAQ

> [!IMPORTANT]
>
> Q: 为什么需要输入管理员密码？
>
> A: 可以查看 `Utils.swift` 和 `AppDetailView.swift` 的代码，需要管理员密码主要是为了执行 `xattr` 和 `codesign` 命令，MAS 应用必须加 sudo，非 MAS 不需要加 sudo，我为了方便都加了 sudo，你可以自行更改代码编译
>
> Q: 为什么提示访问钥匙串？
>
> A: 你可以查看 `PasswordManager.swift` 这个文件的代码，并且你可以在 GUI 的设置中切换密码保存方式

> Q: 执行注入后软件无法安装 helper
>
> A: 我还没有对 helper 做处理，先在未注入状态下安装 helper，然后再注入

> Q: 点击执行注入后没有任何反应
>
> A: 设置 -> 隐私 -> APP 管理 允许 TrialMacAppGUI

> Q: 界面上的图标都是什么意思？
>
> A: 右键图标可以选择展示模式
> ![](images/1.png)

> Q: 支持 APP 的窗口，备注看不全
>
> A: 可以自行拖动加宽备注这一列的宽度，下图的竖线按住往右边拖动。姓名和备注支持右键复制
> ![](images/2.png) ![](images/3.png)

> Q: 快速筛选电脑上所有支持注入的 APP
>
> A: ![](images/4.png)

## 关于储存库本身

> Q: 为什么创建这个仓库
>
> A: 最开始是为了学习 macOS 安全，接触了逆向相关知识，在不断学习的过程中，开始软件的逆向分析，有些是为了研究他的安全逻辑，有些是为了自己用。当处理的软件多了起来，就有了这个仓库，他更多是用来管理我的成果。还有，学习一下 swiftUI

> Q: 为什么注入库不开源代码
>
> A: 倒卖破解软件屡见不鲜，剽窃他人成果、自己包装一层或者改个名字重发布也非常常见，仓库本来就是给我自己用的，我肯定不会自己收自己的钱，也不想被别人改个名字就拿出去贩卖，所以我来管理能够保障安全和免费。（如果对于安全这个词抱有怀疑态度欢迎拿出实际的证据来质疑）

> Q: 为什么 GUI 开源
>
> A: GUI 程序是对执行库的一层图形化包装，仅仅有一个图形化程序无法做到激活其他程序，所以只有代码的参考价值，不能复制一份就去倒卖，所以 GUI 开源，注入库闭源。

## 感谢以下项目

- chatgpt - [chatgpt](https://chatgpt.com)
- jmpews - [Dobby](https://github.com/jmpews/Dobby)
- alexzielenski - [optool](https://github.com/alexzielenski/optool)
