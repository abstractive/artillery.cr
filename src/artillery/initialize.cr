module Artillery

  #de Precedence for constants:
  #de 1. Command-line
  #de 2. artillery.yml
  #de 3. Defaults

  @@environment = "development"
  ENVIRONMENT = ENV["ARTILLERY_ENVIRONMENT"] ||= @@environment
  CALLSITE = (ENV["ARTILLERY_CALLSITE"] ||= `pwd`).chomp

  #de Defaults:
  @@yaml = uninitialized YAML::Any
  @@public_directory = uninitialized String
  @@mountpoint_interface = uninitialized String
  @@mountpoint_port_zeromq = uninitialized String
  @@mountpoint_port_http = uninitialized String

  @@public_directory = "./public"
  @@mountpoint_interface = "0.0.0.0"
  @@mountpoint_port_zeromq = "4000"
  @@mountpoint_port_http = "3000"

  @@config = "#{CALLSITE}/artillery.yml"

  @@yaml = uninitialized YAML::Any
  @@env = uninitialized YAML::Any

  #de YAML if available:
  if File.exists?(@@config)
    @@yaml = File.open(@@config) do |file|
      YAML.parse(file)
    end

    #de TODO: Implement outside Crystal...
    #de launchers: Set number of containers to use.
    #de public: Set public root directory to use.

    #de Allow keys to be set at the top level, or in environments.
    #de The environment value ought to override the top level if both are present.

    if @@yaml["interface"]?
      @@mountpoint_interface = @@yaml["interface"].to_s
    end

    if @@yaml["port"]?
      if @@yaml["port"]["http"]?
        @@mountpoint_port_http = @@yaml["port"]["http"].to_s
      end
    end

    if @@yaml["port"]?
      if @@yaml["port"]["zeromq"]?
        @@mountpoint_port_zeromq = @@yaml["port"]["zeromq"].to_s
      end
    end

    if @@yaml[ENVIRONMENT]?
      @@env = @@yaml[ENVIRONMENT]
      if @@env["port"]?
        if @@env["port"]["http"]?
          @@mountpoint_port_http = @@env["port"]["http"].to_s
        end
      end
  
      if @@env["port"]?
        if @@env["port"]["zeromq"]?
          @@mountpoint_port_zeromq = @@env["port"]["zeromq"].to_s
        end
      end
    end

  end

  #de Command-line Environment Variables:
  PUBLIC_DIRECTORY = ENV["ARTILLERY_PUBLIC"] ||= @@public_directory

  MOUNTPOINT_INTERFACE = ENV["ARTILLERY_EXPOSED_INTERFACE"] ||= @@mountpoint_interface
  MOUNTPOINT_PORT_ZEROMQ = ENV["ARTILLERY_PORT_ZEROMQ"] ||= @@mountpoint_port_zeromq
  MOUNTPOINT_PORT_HTTP = ENV["ARTILLERY_PORT_HTTP"] ||= @@mountpoint_port_http

  MOUNTPOINT_LOCATION = ENV["ARTILLERY_ZEROMQ_URL"] ||= "tcp://#{MOUNTPOINT_INTERFACE}:#{MOUNTPOINT_PORT_ZEROMQ}"

  HTTP_METHODS = %w(get post put patch delete options)
  USE_SHELL_HEADERS = ENV["ARTILLERY_SHELL_HEADERS"] ||= nil
  USE_SHOTS = ENV["ARTILLERY_SHOTS"] ||= nil
end
