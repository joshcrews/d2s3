require 'rails'

module D2S3
  class Railtie < Rails::Railtie
    initializer :after_initialize do
      D2S3::S3Config.load_config
    end
  end
end
