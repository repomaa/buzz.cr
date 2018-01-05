require "./lib_mosquitto"
require "./util"
require "./message"

module Buzz
  class Client
    @mosquitto : LibMosquitto::Mosquitto
    @message_callback : Proc(Message, Void)?

    def self.global_message_callback(mosquitto, box, message_ptr)
      instance = Box(Client).unbox(box)
      message = Message.new(message_ptr)
      instance.handle_message(message)
    end

    def initialize(client_id = nil, clean_session = true)
      LibMosquitto.lib_init

      mosquitto = LibMosquitto.new(client_id, clean_session, nil)
      raise Errno.new("Failed initializing mosquitto") unless mosquitto
      @mosquitto = mosquitto
      setup_user_data
      setup_callback
    end

    def subscribe(pattern, qos = 0)
      Util.handle_error do
        LibMosquitto.subscribe(@mosquitto, nil, pattern, qos)
      end
    end

    def publish(topic, payload : Bytes, qos = 0, retain = false)
      Util.handle_error do
        LibMosquitto.publish(
          @mosquitto, nil, topic, payload.size, payload.to_unsafe, qos, retain
        )
      end
    end

    def publish(topic, payload : String, qos = 0, retain = false)
      publish(topic, payload.to_slice, qos, retain)
    end

    def on_message(&block : Message -> _)
      @message_callback = block
    end

    def handle_message(message)
      @message_callback.try { |callback| callback.call(message) }
    end

    def connect(host, port = 1883, keepalive = 60)
      Util.handle_error do
        LibMosquitto.connect(@mosquitto, host, port, keepalive)
      end
    end

    def finalize
      LibMosquitto.destroy(@mosquitto)
      LibMosquitto.lib_cleanup
    end

    def listen
      loop do
        Util.handle_error { LibMosquitto.loop(@mosquitto, -1, 1) }
      end
    end

    def authorize(username, password)
      LibMosquitto.username_pw_set(@mosquitto, username, password)
    end

    private def setup_callback
      klass = self.class
      LibMosquitto.message_callback_set(
        @mosquitto, ->klass.global_message_callback
      )
    end

    private def setup_user_data
      LibMosquitto.user_data_set(@mosquitto, Box.box(self))
    end
  end
end
