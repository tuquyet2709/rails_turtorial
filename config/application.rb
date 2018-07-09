require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Master
  class Application < Rails::Application
    config.i18n.default_locale = :en
  end
end

module SampleApp
  class Application < Rails::Application
    config.load_defaults 5.1
  end
end
