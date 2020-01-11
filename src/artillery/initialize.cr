module Artillery

  #de Precedence for constants:
  #de 1. Command-line
  #de 2. artillery.yml
  #de 3. Defaults

  ENVIRONMENT = ENV["ARTILLERY_ENVIRONMENT"] ||= "development"
  CALLSITE = (ENV["ARTILLERY_CALLSITE"] ||= `pwd`).chomp

  #de Defaults:
  @@version = uninitialized String
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

  FILE_CONFIGURATION = (ENV["ARTILLERY_CONFIGURATION"]? && File.exists?(ENV["ARTILLERY_CONFIGURATION"])) ? ENV["ARTILLERY_CONFIGURATION"] : "artillery.yml"
  FILE_SECRETS = ENV["ARTILLERY_SECRETS"] ||= "secrets.yml"

  @@disposition = "bazooka"
  @@public_directory = "./public"

  @@launcher_threads = 2
  @@mountpoint_threads = 4
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

  if File.exists?("#{__FILE__}shard.yml".gsub("src/artillery/initialize.cr", ""))
    @@version = File.open("#{__FILE__}shard.yml".gsub("src/artillery/initialize.cr", "")) do |file|
      YAML.parse(file)["version"].as_s
    end
  else
    abort("Artillery version unknown.")
  end

  VERSION = @@version
  Artillery.log("Version: #{VERSION}", "Artillery")

  if File.exists?(@@path_configuration)
    @@yaml = File.open(@@path_configuration) do |file|
      YAML.parse(file)
    end

    @@presence = if @@yaml["presence"]?
      @@yaml["presence"]
    else
      YAML.parse("")
    end

    if @@yaml["disposition"]?
      @@disposition = @@yaml["disposition"].as_s
    end

    #de TODO: Implement outside Crystal...
    #de launchers: Set number of containers to use.

    #de Allow keys to be set at the top level, or in environments.
    #de The environment value ought to override the top level if both are present.

    if @@yaml[ENVIRONMENT]?
      environment_configurations @@yaml[ENVIRONMENT]
    elsif !@@yaml[ENVIRONMENT]? && @@yaml["environments"]?
      @@yaml["environments"].as_h.each { |name,values|
        if ( values["path_includes"]? && Process.executable_path.try &.includes?("#{values["path_includes"]}") ) ||
           ( values["host"]? && System.try &.hostname == "#{values["host"]}" )
          environment_configurations(values)
          next
        end
      }
    else
      environment_configurations( @@yaml )
    end

    if @@yaml["public"]?
      @@public_directory = @@yaml["public"].to_s
    end
  end

  #de TODO: Validate these values!

  #de Command-line Environment Variables:
  PUBLIC_DIRECTORY = ENV["ARTILLERY_PUBLIC"] ||= @@public_directory

  PRESENCE = @@presence
  begin
    @@presence_code = PRESENCE["code"]?
  rescue
    Artillery.log "No presence code set. [#{@@path_configuration}]", "Artillery"
    abort
  end
  PRESENCE_CODE = if @@presence_code
    Artillery::Logger.log("Presence: #{@@presence_code.to_s.colorize(:yellow)}", "Artillery")
    @@presence_code.to_s
  else
    nil
  end

  def self.environment_configurations(env)
    if env["ports"]?
      if env["ports"]["http"]?
        @@mountpoint_port_http = "#{env["ports"]["http"]}"
      end
    end

    if env["ports"]?
      if env["ports"]["zeromq"]?
        @@mountpoint_port_zeromq = "#{env["ports"]["zeromq"]}"
      end
    end

    if env["interface"]?
      @@mountpoint_interface = "#{env["interface"]}"
    end

    if env["threads"]? && env["threads"].as_h.any?
      if env["threads"]["mountpoint"]?
        @@mountpoint_threads = "#{env["threads"]["mountpoint"]}".to_i
      end
      if env["threads"]["launcher"]?
        @@launcher_threads = "#{env["threads"]["launcher"]}".to_i
      end
    end
  end

  SOCKET_TIMEOUT = 1500
  DISPOSITION = @@disposition

  LAUNCHER_THREADS = (ENV["ARTILLERY_LAUNCHER_THREADS"]?) ? "#{ENV["ARTILLERY_LAUNCHER_THREADS"]}".to_i : @@launcher_threads
  MOUNTPOINT_THREADS = (ENV["ARTILLERY_MOUNTPOINT_THREADS"]?) ? "#{ENV["ARTILLERY_MOUNTPOINT_THREADS"]}".to_i : @@mountpoint_threads
  MOUNTPOINT_INTERFACE = ENV["ARTILLERY_EXPOSED_INTERFACE"] ||= @@mountpoint_interface
  MOUNTPOINT_PORT_ZEROMQ = ENV["ARTILLERY_PORT_ZEROMQ"] ||= @@mountpoint_port_zeromq
  MOUNTPOINT_PORT_HTTP = ENV["ARTILLERY_PORT_HTTP"] ||= @@mountpoint_port_http
  MOUNTPOINT_LOCATION = ENV["ARTILLERY_ZEROMQ_URL"] ||= "tcp://#{MOUNTPOINT_INTERFACE}:#{MOUNTPOINT_PORT_ZEROMQ}"

  HTTP_METHODS = %w(get post put patch delete options)
  USE_SHELL_HEADERS = ENV["ARTILLERY_SHELL_HEADERS"] ||= nil
  USE_SHOTS = ENV["ARTILLERY_SHOTS"] ||= nil

end
