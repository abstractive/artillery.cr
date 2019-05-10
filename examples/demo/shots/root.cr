class Root < Artillery::Shot

  vector "/"

  def get
    redirect "/index.html"
  end

end