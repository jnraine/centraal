Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cas, host: 'cas.sfu.ca', login_url: '/cgi-bin/WebObjects/cas.woa/wa/login/', service_validate_url: "/cgi-bin/WebObjects/cas.woa/wa/serviceValidate"
end

OmniAuth.config.logger = Rails.logger

USER_FACTORIES = {"cas" => CasUserFactory}