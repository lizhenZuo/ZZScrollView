
Pod::Spec.new do |spec|
spec.version='1.0.14'
  spec.summary      = "infinite scrollview."
  spec.name         = "ZZScrollView"
  spec.description  = <<-DESC
                   一个可以无限循环的scrollview，可以显示图片或者普通的view
                   DESC

  spec.homepage     = "https://github.com/lizhenZuo/ZZScrollView"

  spec.license      = "MIT"

  spec.author             = { "Zorro" => "1732096868@qq.com" }

  spec.platform     = :ios, '9.0'

  spec.source       = { :git => "https://github.com/lizhenZuo/ZZScrollView.git", :tag => "#{spec.version}" }

  spec.source_files  = "ZZScrollView", "ZZScrollView/**/*.{h,m}"

end
