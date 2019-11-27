Pod::Spec.new do |spec|
  spec.name         = "EmojiKeyboard"
  spec.version      = "0.0.1"
  spec.license      = "MIT"
  spec.summary      = "emoji keyboard"
  spec.homepage     = "https://github.com/dusmit/EmojiKeyboard"
  # spec.social_media_url   = "https://twitter.com/陈洪强"
  spec.author             = { "陈洪强" => "dusmit@qq.com" }
  spec.source       = { :git => "http://dusmit/EmojiKeyboard.git", :tag => "#{spec.version}" }

  spec.requires_arc = true
  # spec.public_header_files = 'AFNetworking/AFNetworking.h'
  spec.source_files = 'EmojiKeyboard/EmojiKeyboardView/*.{h,m}'
  spec.ios.deployment_target = '8.0'


end
