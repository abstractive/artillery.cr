class FooBar < Artillery::Shot
  
  vector "/foo/:bar"

  def get
    success "Foo Bar: #{@request.path}"
  end

end