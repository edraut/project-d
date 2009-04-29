module FormatsErrors
  def first_error_on(attr)
    if attr == :base
      these_errors = self.errors.on_base
    else
      these_errors = self.errors.on attr
    end
    if these_errors.class.name == 'Array'
      return '<div class="error_text">' + these_errors.first + '</div>'
    elsif !these_errors.blank?
      return '<div class="error_text">' + these_errors + '</div>'
    else
      return ''
    end
  end
end