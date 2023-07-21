Pod::Spec.new do |spec|
spec.name             = 'SandboxBrowser'
spec.version          = '0.0.5'
spec.license          = { :type => 'MIT' }
spec.homepage         = 'https://github.com/aidevjoe/SandboxBrowser'
spec.authors          = { 'Joe' => 'aidevjoe@gmail.com' }
spec.summary          = "A simple iOS sandbox file browser."
spec.source           = { :git => "https://github.com/aidevjoe/SandboxBrowser.git", :tag => spec.version }
spec.platform         = :ios, "11.0"
spec.source_files     = 'SandboxBrowserExample/SandboxBrowser/*.{swift}'
spec.resources        = 'SandboxBrowserExample/SandboxBrowser/Resources/*.{bundle}'
spec.requires_arc     = true
end
