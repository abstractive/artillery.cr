class Error404 < Artillery::Shot
  {% for method in Artillery::HTTP_METHODS %}
    def {{method.downcase.id}}
      error 404, "Not Found"
    end
  {% end %}
end
