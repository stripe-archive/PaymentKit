Pod::Spec.new do |s|
  s.name                = "SKPayment"
  s.version             = "1.0.0"
  s.summary             = "Utility library for creating credit card payment forms."
  s.license             = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage            = "https://stripe.com"
  s.author              = { "Alex MacCaw" => "alex@stripe.com" }
  s.source              = { :git => "https://github.com/stripe/SKPayment.git", :tag => "v1.0.0"}
  s.source_files        = 'SKPayment/*.{h,m}'
  s.public_header_files = 'SKPayment/*.h'
  s.resources           = 'SKPayment/Resources'
  s.platform            = :ios
  s.requires_arc        = true
end