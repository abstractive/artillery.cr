module Artillery

  #de Precedence for constants:
  #de 1. Command-line
  #de 2. artillery.yml
  #de 3. Defaults

  ENVIRONMENT = ENV["ARTILLERY_ENVIRONMENT"] ||= "development"
  CALLSITE = (ENV["ARTILLERY_CALLSITE"] ||= `pwd`).chomp

  MOUNTPOINT_THREADS = 4
  LAUNCHER_THREADS = 2

  #de Defaults:
  @@yaml = uninitialized YAML::Any
  @@presence = uninitialized YAML::Any
  @@presence_code = uninitialized YAML::Any?
  @@public_directory = uninitialized String

  @@mountpoint_interface = uninitialized String
  @@mountpoint_port_zeromq = uninitialized String
  @@mountpoint_port_http = uninitialized String

  def self.configuration
    @@yaml
  end

  FILE_CONFIGURATION = ENV["ARTILLERY_CONFIGURATION"] ||= "artillery.yml"
  FILE_SECRETS = ENV["ARTILLERY_SECRETS"] ||= "secrets.yml"

  @@public_directory = "./public"

  @@mountpoint_interface = "0.0.0.0"
  @@mountpoint_port_zeromq = "4000"
  @@mountpoint_port_http = "3000"

  @@path_configuration = "#{CALLSITE}/#{FILE_CONFIGURATION}"
  @@path_secrets = "#{CALLSITE}/#{FILE_SECRETS}"

  @@yaml = uninitialized YAML::Any
  @@env = uninitialized YAML::Any
  @@secrets = uninitialized YAML::Any

  #de YAML if available:  if File.exists?(@@path_configuration)
  SECRETS = if File.exists?(@@path_secrets)
    @@secrets = File.open(@@path_secrets) do |file|
      YAML.parse(file)
    end
  else
    YAML.parse("")
  end

  if File.exists?(@@path_configuration)
    @@yaml = File.open(@@path_configuration) do |file|
      YAML.parse(file)
    end

    @@presence = if @@yaml["presence"]?
      @@yaml["presence"]
    else
      YAML.parse("")
    end

    #de TODO: Implement outside Crystal...
    #de launchers: Set number of containers to use.
    #de public: Set public root directory to use.

    #de Allow keys to be set at the top level, or in environments.
    #de The environment value ought to override the top level if both are present.
    
    if @@yaml["interface"]?
      @@mountpoint_interface = @@yaml["interface"].to_s
    end

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

    if @@yaml["public"]?
      @@public_directory = @@yaml["public"].to_s
    end
  end

  #de TODO: Validate these values!

  #de Command-line Environment Variables:
  PUBLIC_DIRECTORY = ENV["ARTILLERY_PUBLIC"] ||= @@public_directory

  PRESENCE = @@presence
  @@presence_code = PRESENCE["code"]?
  PRESENCE_CODE = if @@presence_code
    Artillery::Logger.log("Presence: #{@@presence_code.to_s.colorize(:yellow)}", "Artillery")
    @@presence_code.to_s
  else
    nil
  end

  SOCKET_TIMEOUT = 1500

  MOUNTPOINT_INTERFACE = ENV["ARTILLERY_EXPOSED_INTERFACE"] ||= @@mountpoint_interface
  MOUNTPOINT_PORT_ZEROMQ = ENV["ARTILLERY_PORT_ZEROMQ"] ||= @@mountpoint_port_zeromq
  MOUNTPOINT_PORT_HTTP = ENV["ARTILLERY_PORT_HTTP"] ||= @@mountpoint_port_http
  MOUNTPOINT_LOCATION = ENV["ARTILLERY_ZEROMQ_URL"] ||= "tcp://#{MOUNTPOINT_INTERFACE}:#{MOUNTPOINT_PORT_ZEROMQ}"

  HTTP_METHODS = %w(get post put patch delete options)
  USE_SHELL_HEADERS = ENV["ARTILLERY_SHELL_HEADERS"] ||= nil
  USE_SHOTS = ENV["ARTILLERY_SHOTS"] ||= nil

end
