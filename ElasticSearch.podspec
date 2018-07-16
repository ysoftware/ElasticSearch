Pod::Spec.new do |s|
  s.name         = "ElasticSearch"
  s.version      = "0.1"
  s.summary      = "Interface for ElasticSearch requests."
  s.homepage     = "http://ysoftware.ru"
  s.license      = { :type => 'MIT', :file => 'MIT-LICENSE.txt' }
  s.author       = { "Yaroslav Erohin" => "ysoftware@yandex.ru" }
  s.social_media_url   = "http://twitter.com/ysoftware"
  s.platform     = :ios, "8.0"
  s.source       = { :git => 'https://github.com/ysoftware/ElasticSearch.git', :tag => "v0.1" }
  s.swift_version = "4.1"
  s.source_files  = "ElasticSearch", "ElasticSearch/**/*.{h,m,swift}"
end
