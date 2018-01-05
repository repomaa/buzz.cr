@[Link("mosquitto")]

lib LibMosquitto
  alias Mosquitto = Void*

  enum Error
    CONN_PENDING = -1
    SUCCESS = 0
    NOMEM = 1
    PROTOCOL = 2
    INVAL = 3
    NO_CONN = 4
    CONN_REFUSED = 5
    NOT_FOUND = 6
    CONN_LOST = 7
    TLS = 8
    PAYLOAD_SIZE = 9
    NOT_SUPPORTED = 10
    AUTH = 11
    ACL_DENIED = 12
    UNKNOWN = 13
    ERRNO = 14
    EAI = 15
    PROXY = 16
  end

  struct Message
    mid : Int32
    topic : UInt8*
    payload : Void*
    payloadlen : Int32
    qos : Int32
    retain : Bool
  end

  enum Option
    PROTOCOL_VERSION = 1
  end

  fun lib_init = mosquitto_lib_init
  fun lib_cleanup = mosquitto_lib_cleanup
  fun new = mosquitto_new(id : UInt8*, clean_session : Bool, obj : Void*) : Mosquitto?
  fun destroy = mosquitto_destroy(mosq : Mosquitto)
  fun reinitialize = mosquitto_reinitialize(mosq : Mosquitto, id : UInt8*, clean_session : Bool, obj : Void*) : Mosquitto?
  fun will_set = mosquitto_will_set(mosq : Mosquitto, topic : UInt8*, payloadlen : Int32, payload : Void*, qos : Int32, retain : Bool) : Error
  fun will_clear = mosquitto_will_clear(mosq : Mosquitto) : Error
  fun username_pw_set = mosquitto_username_pw_set(mosq : Mosquitto, username : UInt8*, password : UInt8*) : Error
  fun connect = mosquitto_connect(mosq : Mosquitto, host : UInt8*, port : Int32, keepalive : Int32) : Error
  fun reconnect = mosquitto_reconnect(mosq : Mosquitto) : Error
  fun disconnect = mosquitto_disconnect(mosq : Mosquitto) : Error
  fun publish = mosquitto_publish(mosq : Mosquitto, mid : Int32*, topic : UInt8*, payloadlen : Int32, payload : Void*, qos : Int32, retain : Bool) : Error
  fun subscribe = mosquitto_subscribe(mosq : Mosquitto, mid : Int32*, sub : UInt8*, qos : Int32) : Error
  fun unsubscribe = mosquitto_unsubscribe(mosq : Mosquitto, mid : Int32*, sub : UInt8*) : Error
  fun message_copy = mosquitto_message_copy(dst : Message*, src : Message*) : Error
  fun message_free = mosquitto_message_free(message : Message**)
  fun loop = mosquitto_loop(mosq : Mosquitto, timeout : Int32, max_packets : Int32) : Error
  fun opts_set = mosquitto_opts_set(mosq : Mosquitto, option : Option, value : Void*) : Error
  fun tls_set = mosquitto_tls_set(mosq : Mosquitto, cafile : UInt8*, capath : UInt8*, certfile : UInt8*, keyfile : UInt8*, pw_callback : (UInt8*, Int32, Int32, Void*) -> Int32) : Error
  fun tls_insecure_set = mosquitto_tls_insecure_set(mosq : Mosquitto, value : Bool) : Error
  fun tls_opts_Set = mosquitto_tls_opts_set(mosq : Mosquitto, cert_reqs : Int32, tls_version : UInt8*, ciphers : UInt8*) : Error
  fun tls_psk_set = mosquitto_tls_psk_set(mosq : Mosquitto, psk : UInt8*, identity : UInt8*, ciphers : UInt8*) : Error
  fun message_callback_set = mosquitto_message_callback_set(mosq : Mosquitto, callback : (Mosquitto, Void*, Message*) -> Void)
  fun subscribe_callback_set = mosquitto_subscribe_callback_set(mosq : Mosquitto, callback : (Mosquitto, Void*, Int32, Int32*) -> Void)
  fun unsubscribe_callback_set = mosquitto_unsubscribe_callback_set(mosq : Mosquitto, callback : (Mosquitto, Void*, Int32) -> Void)
  fun log_callback_set = mosquitto_log_callback_set(mosq : Mosquitto, callback : (Mosquitto, Void*, Int32, UInt8*) -> Void)
  fun user_data_set = mosquitto_user_data_set(mosq : Mosquitto, data : Void*)
  fun strerror = mosquitto_strerror(error : Error) : UInt8*
end
