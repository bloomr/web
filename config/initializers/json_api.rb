JSONAPI.configure do |config|
  config.exception_class_whitelist = [Exceptions::NotAuthorizedError]
end
