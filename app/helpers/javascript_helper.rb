module JavascriptHelper
	def js_void
		"javascript:void(0);"
	end
	
	def submit_form(name = nil)
		if (name)
			'javascript:document.#{name}.submit();'
		else
			'javascript:document.forms[0].submit();'
		end
	end
	
	def jquery_on_ready(script)
		on_ready_script = "$(function() {"
		on_ready_script << script
		on_ready_script << "});"
		javascript_tag(on_ready_script)
	end
	
	def init_datepicker(input_id, options = {})
		jquery_on_ready("$('##{input_id}').datepicker(#{options.to_json});")
	end
end