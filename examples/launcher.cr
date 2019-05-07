require "../src/artillery/launcher"
require "../src/artillery/projectile"

class HelloWorld < Artillery::Projectile

  vector "/"

  def initialize
    "Hello World"
  end

end

class FooBar < Artillery::Projectile

  vector "/foo/bar"

  def initialize
    "Foo Bar"
  end

end

puts HelloWorld.vectors
puts FooBar.vectors

Artillery::Launcher.run
