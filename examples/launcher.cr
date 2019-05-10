require "../src/artillery/launcher"
require "../src/artillery/shot"

class HelloWorld < Artillery::Shot

  vector "/"

  def initialize
    "Hello World"
  end

end

class FooBar < Artillery::Shot

  vector "/foo/bar"

  def initialize
    "Foo Bar"
  end

end

puts HelloWorld.vectors
puts FooBar.vectors

Artillery::Launcher.run
