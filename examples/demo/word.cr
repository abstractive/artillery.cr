class Word < Artillery::Shot

  vector :post, "/word"

  def post
    success({ hello: "World" }.to_json)
  end

end