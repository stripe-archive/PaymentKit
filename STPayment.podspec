Pod::Spec.new do |s|
  s.name                = "STPayment"
  s.version             = "1.0.0"
  s.summary             = "Utility library for creating credit card payment forms"
  s.license             = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage            = "https://stripe.com"
  s.author              = { "Alex MacCaw" => "alex@stripe.com" }
  s.source              = { :git => "https://github.com/stripe/STPayment.git", :tag => "v1.0.0"}
  s.source_files        = 'STPayment/*.{h,m}'
  s.public_header_files = 'STPayment/*.h'
  s.resources           = 'STPayment/Resources'
  s.framework           = 'Foundation'
  s.requires_arc        = true
end