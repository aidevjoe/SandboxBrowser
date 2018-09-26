### SandboxBrowser

[![Version](https://img.shields.io/cocoapods/v/SandboxBrowser.svg?style=flat)](http://cocoapods.org/pods/SandboxBrowser)
[![License](https://img.shields.io/cocoapods/l/SandboxBrowser.svg?style=flat)](http://cocoapods.org/pods/SandboxBrowser)
[![Platform](https://img.shields.io/cocoapods/p/SandboxBrowser.svg?style=flat)](http://cocoapods.org/pods/SandboxBrowser)

A simple iOS sandbox file browser, enable you to view sandbox file system on iOS device, share files via airdrop, super convenient when you want to send log files from iOS device to Mac. reference from  [AirSandbox](https://github.com/music4kid/AirSandbox), Thanks !

### Screenshots

<img src="https://github.com/Joe0708/SandboxBrowser/raw/master/Screenshot/SimulatorScreenShot1.png" width="280">   <img src="https://github.com/Joe0708/SandboxBrowser/raw/master/Screenshot/SimulatorScreenShot2.png" width="280"> <img src="https://github.com/Joe0708/SandboxBrowser/raw/master/Screenshot/SimulatorScreenShot3.png" width="280">
### Installation

To integrate SandboxBrowser into your Xcode project using CocoaPods, specify it in your Podfile:

```
pod 'SandboxBrowser'
```

Then, run pod install.


### Usage

```
import SandboxBrowser

```

```
let sandboxBrowser = SandboxBrowser()
present(sandboxBrowser, animated: true, completion: nil)

```
Open the sandbox directory by default, and you can specify the directory

```
let sandboxBrowser = SandboxBrowser(initialPath: customURL)

```

Use the didSelectFile closure to change FileBrowser's behaviour when a file is selected.

```
sandboxBrowser.didSelectFile = { file, vc in
    print(file.name, file.type)
}
```

Long press file share via AirDrop

### Other
A convenient log console ![Library](https://github.com/Joe0708/LogConsole)

### License
MIT


