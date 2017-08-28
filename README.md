### SandboxBrowser

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
let sanboxBrowser = SandboxBrowser()
present(sanboxBrowser, animated: true, completion: nil)

```
Open the sandbox directory by default, and you can specify the directory

```
let sanboxBrowser = SandboxBrowser(initialPath: customURL)

```

Use the didSelectFile closure to change FileBrowser's behaviour when a file is selected.

```
sanboxBrowser.didSelectFile = { file, vc in
    print(file.name, file.type)
}
```

Long press file share via AirDrop

### License
MIT


