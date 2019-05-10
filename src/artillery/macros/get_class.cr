def get_class(klass)
  {% begin %}
    case klass
    {% for obj in Artillery::Shot.all_subclasses %}
      when {{obj.stringify}}
        return {{obj}}
    {% end %}
    else
      raise "Mismatch!"
    end
  {% end %}
end