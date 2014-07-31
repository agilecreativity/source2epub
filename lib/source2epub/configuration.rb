module Source2Epub
  class Configuration
    attr_accessor :creator,
                  :publisher,
                  :published_date,
                  :identifier
    def initialize
      @creator        = "https://github.com/agilecreativity/source2epub"
      @publisher      = "http://agilecreativity.com"
      @published_date = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      @identifier     = "https://agilecreativity.com/"
    end
  end

  class << self
    attr_accessor :configuration

    # Configure Source2Epub someplace sensible, like
    #
    # 'config/initializers/source2epub.rb'
    #
    # Source2Epub.configure do |config|
    #   config.creator = ".."
    # end
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
