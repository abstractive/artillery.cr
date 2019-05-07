module ZMQ::Util
  extend self

  def curve_keypair
    public_key = FFI::MemoryPointer.from_string(" " * 41)
    private_key = FFI::MemoryPointer.from_string(" " * 41)
    rc = LibZMQ.curve_keypair public_key, private_key

    if rc < 0
      raise NotSupportedError.new "zmq_curve_keypair", rc, ZMQ::Util.errno,
        "Rebuild zeromq with libsodium to enable CURVE security options."
    end

    [public_key.read_string, private_key.read_string]
  end

  # Returns true when +rc+ is greater than or equal to 0, false otherwise.
  #
  # We use the >= test because zmq_poll() returns the number of sockets
  # that had a read or write event triggered. So, a >= 0 result means
  # it succeeded.
  #
  def resultcode_ok?(rc)
    rc >= 0
  end

  # Returns the +errno+ as set by the libzmq library.
  #
  def errno
    LibZMQ.errno
  end

  # Returns a string corresponding to the currently set #errno. These
  # error strings are defined by libzmq.
  #
  def error_string
    String.new(LibZMQ.strerror(errno))
  end

  # Attempts to bind to a random tcp port on +host+ up to +max_tries+
  # times. Returns the port number upon success or nil upon failure.
  #
  def bind_to_random_tcp_port(host = "127.0.0.1", max_tries = 500)
    tries = 0
    rc = -1

    while !resultcode_ok?(rc) && tries < max_tries
      tries += 1
      random = random_port
      rc = socket.bind "tcp://#{host}:#{random}"
    end

    resultcode_ok?(rc) ? random : nil
  end

  # :doc:
  # Called to verify whether there were any errors during
  # operation. If any are found, raise the appropriate #ZeroMQError.
  #
  # When no error is found, this method returns +true+ which is behavior
  # used internally by #send and #recv.
  #
  def error_check(source, result_code)
    if -1 == result_code
      raise_error source, result_code
    end

    # used by Socket::send/recv, ignored by others
    true
  end

  # generate a random port between 10_000 and 65534
  private def random_port
    rand(55534) + 10_000
  end

  private def raise_error(source, result_code)
    if context_error?(source)
      raise ContextError.new source, result_code, ZMQ::Util.errno, ZMQ::Util.error_string
    elsif message_error?(source)
      raise MessageError.new source, result_code, ZMQ::Util.errno, ZMQ::Util.error_string
    else
      raise ZeroMQError.new source, result_code, -1,
        "Source [#{source}] does not match any zmq_* strings, rc [#{result_code}], errno [#{ZMQ::Util.errno}], error_string [#{ZMQ::Util.error_string}]"
    end
  end

  private def eagain?
    EAGAIN == ZMQ::Util.errno
  end

  private def context_error?(source)
      "zmq_ctx_new" == source ||
      "zmq_ctx_set" == source ||
      "zmq_ctx_get" == source ||
      "zmq_ctx_destory" == source ||
      "zmq_ctx_set_monitor" == source
  end

  MSG_ERRORS = {"zmq_msg_init",
                "zmq_msg_init_data",
                "zmq_msg_copy",
                "zmq_msg_move",
                "zmq_msg_close",
                "zmq_msg_get",
                "zmq_msg_more",
                "zmq_msg_recv",
                "zmq_msg_send",
                "zmq_msg_set"}
  private def message_error?(source)
    MSG_ERRORS.includes?(source)
  end
end
