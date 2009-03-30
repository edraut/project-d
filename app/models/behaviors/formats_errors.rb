module FormatsErrors
  def first_error_on(attr)
    these_errors = self.errors.on attr
    if these_errors.class.name == 'Array'
      return '<div class="error_text">' + these_errors.first + '</div>'
    elsif !these_errors.blank?
      return '<div class="error_text">' + these_errors + '</div>'
    else
      return ''
    end
  end
end