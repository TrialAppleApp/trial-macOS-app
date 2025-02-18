<img src="./TrialMacAppGUI/Assets.xcassets/AppIcon.appiconset/icon_1024X1024 1.png" width="160" alt="App icon" align="left"/>

<div>
<h3>TrialMacAppGUI</h3>
<p>Change the software logic to achieve the purpose of extending the trial time of many apps</p>
<a href="https://github.com/TrialAppleApp/trial-macOS-app/releases">Download for macOS</a>
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

## Supported Apps

<a href="app.md">Click me to view</a>

## Special app activation

<a href="special_app.md">Click me to view</a>

## Major features

- Swift native application
- SwiftUI writes interactive interface and rejects Appkit
- Passwords are encrypted using keychains
- Native code writing injection plug-ins
- **The code is open source and free**
- **No need to turn off SIP to crack all apps**

### Advantages over other cracking software

- Download the original software from the official website or Mac App Store to ensure the source is safe
- The supported versions in the support list are any version of this program. When a new version is released, it can be immediately upgraded to use the new version (generally applicable to larger versions, such as 1. xx applicable, 2. xx may not be applicable)

## Tutorial

1. Download the software from the official website or Mac App Store (Whether it is Mac App Store can be checked from the list of <a href="app.md">all supported apps</a>)
2. Open TrialMacAppGUI to use it (see the video below)

### Demo video

https://github.com/user-attachments/assets/5c7e4ae3-f8b4-45db-be5d-094ebabb2a42

## macOS compatibility

macOS 13 or newer

## How to build

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
> Q: Why do I need to enter the administrator password?
>
> A: You can view the code of `Utils.swift` and `AppDetailView.swift`. The administrator password is required mainly to execute `xattr` and `codesign` commands. MAS applications must add sudo, and non-MAS applications do not need to add sudo. I added sudo for convenience. You can change the code and compile it yourself.
>
> Q: Why is it prompted to access the keychain?
>
> A: You can view the code of the `PasswordManager.swift` file, and you can switch the password saving method in the GUI settings.

> Q: After executing the injection, the software cannot install the helper
>
> A: I haven't processed the helper yet. I first install the helper in the uninjected state and then inject it

> Q: Nothing happens after clicking the injection
>
> A: Settings -> Privacy -> APP Management Allow TrialMacAppGUI

> Q: What do the icons on the interface mean?
>
> A: Right-click the icon to select the display mode
> ![](images/1.png)

> Q: The window that supports APPs cannot see all the remarks
>
> A: You can drag and widen the width of the remark column. Press and hold the vertical line in the figure below and drag it to the right. The name and remark can be copied by right-clicking
> ![](images/2.png) ![](images/3.png)

> Q: Quickly filter all APPs on the computer that support injection
>
> A: ![](images/4.png)

## About the repository itself

> Q: Why did you create this repository?
>
> A: I started out to learn about macOS security and learned about reverse engineering. In the process of continuous learning, I started to reverse analyze software, some of which were to study its security logic, and some for my own use. When I dealt with more software, I had this repository, which was more used to manage my achievements. Also, learn about swiftUI

> Q: Why is the injection library not open source?
>
> A: It is common to resell cracked software, and it is also very common to plagiarize others' achievements and re-package them or re-publish them under a different name. The repository was originally for my own use. I will definitely not collect my own money, nor do I want others to re-name it and sell it, so I manage it to ensure safety and free of charge. (If you are skeptical about the word "safety", please provide actual evidence to question it)

> Q: Why is the GUI open source?
>
> A: The GUI program is a graphical packaging of the execution library. Only a graphical program cannot activate other programs, so the code is only of reference value and cannot be resold by copying a copy. Therefore, the GUI is open source and the injection library is closed source.

## Acknowledgements

- chatgpt - [chatgpt](https://chatgpt.com)
- jmpews - [Dobby](https://github.com/jmpews/Dobby)
- alexzielenski - [optool](https://github.com/alexzielenski/optool)
