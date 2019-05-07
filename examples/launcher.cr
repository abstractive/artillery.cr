require "../src/artillery/launcher"

class TestMissile < Artillery::Projectile

  path "/"

  def initialize
    "Hello World"
  end

end

Artillery::Launcher.run
