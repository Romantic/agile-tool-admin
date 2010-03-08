class CustomFormBuilder < ActionView::Helpers::FormBuilder
    
    DEFAULT_DATE_PICKER_OPTIONS = { :dateFormat => "dd/mm/yy" }.freeze unless const_defined?(:DEFAULT_DATE_PICKER_OPTIONS)
    
    def tag_id(method)
      "#{sanitized_object_name}_#{sanitized_method_name(method)}"
    end

    def sanitized_object_name
      @sanitized_object_name ||= @object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
    end

    def sanitized_method_name(method)
      method.sub(/\?$/,"")
    end
    
    def date_picker(method, options = {}, date_picker_options = {})
        date_picker_options = DEFAULT_DATE_PICKER_OPTIONS.merge(date_picker_options)
        out = @template.text_field(@object_name, method, options.merge(:object => @object))
        out << @template.init_datepicker(tag_id(method.to_s), date_picker_options)
    end
end