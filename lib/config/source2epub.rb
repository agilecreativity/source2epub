module Source2Epub
  class << self
    def update_config
      Source2Epub.configure do |config|
        config.creator        = "Burin C"
        config.publisher      = "Burin C"
        config.published_date = "2014-06-23" # TODO: get the current date
        config.identifier     = "https://agilecreativity.com/"
      end
    end
  end
end
