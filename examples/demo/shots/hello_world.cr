class HelloWorld < Artillery::Shot

  vector "/hello"

  def get
    success "Hello World!"
  end

end