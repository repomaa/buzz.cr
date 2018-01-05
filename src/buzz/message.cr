require "./lib_mosquitto"

module Buzz
  class Message
    def initialize(message_ptr : LibMosquitto::Message*)
      @message = LibMosquitto::Message.new
      Util.handle_error do
        LibMosquitto.message_copy(pointerof(@message), message_ptr)
      end
    end

    def finalize
      message_pointer = pointerof(@message)
      LibMosquitto.message_free(pointerof(message_pointer))
    end

    def payload
      payload_pointer = @message.payload
      Bytes.new(payload_pointer.as(Pointer(UInt8)), @message.payloadlen)
    end

    def payload_string
      String.new(payload)
    end

    forward_missing_to(@message)
  end
end
