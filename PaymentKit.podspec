Pod::Spec.new do |s|
  s.name                  = "PaymentKit"
  s.version               = "1.2"
  s.summary               = "Utility library for creating credit card payment forms."
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage              = "https://stripe.com"
  s.author                = { "Stripe Support" => "support@stripe.com" }
  s.source                = { :git => "https://github.com/stripe/PaymentKit.git", :tag => "v1.2"}
  s.source_files          = 'PaymentKit/*.{h,m}'
  s.public_header_files   = 'PaymentKit/*.h'
  s.resources             = 'PaymentKit/Resources/Cards/*.png', 'PaymentKit/Resources/*.png'
  s.platform              = :ios
  s.requires_arc          = true
  s.ios.deployment_target = '5.0'
  s.deprecated = true
  s.deprecated_in_favor_of = 'Stripe'
end
