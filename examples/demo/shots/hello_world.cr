class HelloWorld < Artillery::Shot

  vector "/"

  def get
    success "Hello World"
  end

end