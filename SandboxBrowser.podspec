Pod::Spec.new do |spec|
spec.name             = 'SandboxBrowser'
spec.version          = '0.0.1'
spec.license          = { :type => "MIT" }
spec.homepage         = 'https://github.com/Joe0708/SandboxBrowser'
spec.authors          = { 'Joe' => 'joesir7@foxmail.com' }
spec.summary          = "view iOS app sandbox file system on real device, share files via airdrop."
spec.source           = { :git => "https://github.com/Joe0708/SandboxBrowser.git", :tag => spec.version }
#spec.platform         = :ios, "8.0"
spec.source_files     = 'SandboxBrowserExample/SandboxBrowser/*.swift'
spec.resources        = 'SandboxBrowserExample/SandboxBrowser/Resources/*.bundle'
spec.requires_arc     = true
end
