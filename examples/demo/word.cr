class Word < Artillery::Shot

  vector "/word"

  def get
    success({ hello: "World" }.to_json)
  end

end