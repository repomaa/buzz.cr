require "./lib_mosquitto"
require "./error"

module Buzz
  module Util
    def self.handle_error
      result = yield
      return if result == LibMosquitto::Error::SUCCESS
      raise Error.new(String.new(LibMosquitto.strerror(result)))
    end
  end
end
