# Provides helper methods for jquery ajax grid integration.
module JqueryGridHelper

	# TODO: Move to config
	GRID_CONFIG_PATH = Rails.root.join('config', 'grids')
	
	# Generates default id for grid (using controller name).
	def grid_name
		return "#{controller_name}_grid"
	end
	
	# Generates default id for pager (using controller name).
	def pager_name
		return "#{controller_name}_pager"
	end
	
	# Generates delete selected items script.
	def delete_selected_items
		"javascript:deleteSelectedItems('##{grid_name}', '#{url_for :action => "destroy_multiple"}', '#{t "messages.are_you_shure"}', '#{t "messages.at_least_one_record"}');"
	end
	
	# Gets dictionary with parsed grid configurations. 
	# In this key - name of grid, value - configuration dictionary for grid.
	def grid_configs_cache
		@@grid_configs_cache = {} unless defined? @@grid_configs_cache
		@@grid_configs_cache
	end

	# Loads grid configuration from yml. It used default values (default.yml) 
	# and merges all configs with default config.
	def load_grid_config(name)
		config = grid_config(:default) if name != :default
		config ||= {}
		path = "#{GRID_CONFIG_PATH}/#{name}.yml"
		if File.exists?(path)
			config.merge!(YAML.load_file(path))
		end
		return config
	end

	# Prepares grid columns after configuration reading.
	def prepare_grid_columns(config)
		recalculate_grid_columns(config) if config["columns"]
		translate_grid_columns_names(config) if config["columnNames"]
		append_special_grid_columns(config) if config["columns"]
		config
	end

	# Recalculates grid columns width to normilize grid width
	#  (total width of all columns and special columns should be equal to value specified in config).
	def recalculate_grid_columns(config)
		total_width = config["width"] - 20
		total_width -= config["index_column"]["width"] if config["show_index_column"]
		total_width -= config["view_column"]["width"] if config["show_view_column"]
		total_width -= config["edit_column"]["width"] if config["show_edit_column"]
		total_initial_width = config["columns"].inject(0) {|sum, column| sum + column["width"]}
		config["columns"].each do |column|
			column["width"] = (column["width"] / total_initial_width.to_f * total_width).to_i
		end
		config
	end

	# Appends special columns (index, view, edit) if it specified in configuration
	#  (show_index_column, show_view_column, show_edit_column).
	def append_special_grid_columns(config)
		if config["show_index_column"]
			config["columns"].insert(0, config["index_column"]) 
			config["columnNames"].insert(0, config["index_column_title"])
		end
		if config["show_view_column"]
			config["columns"].push(config["view_column"])
			config["columnNames"].push(config["view_column_title"])
		end
		if config["show_edit_column"]
			config["columns"].push(config["edit_column"])
			config["columnNames"].push(config["edit_column_title"])
		end
		config
	end
	
	def translate_grid_columns_names(config)
		translated_names = []
		config["columnNames"].each do |column|
			translated_names.push(t(column))
		end	
		config["columnNames"] = translated_names
		config
	end

	# Gets grid configuration for specified grid name (controller name by default).
	def grid_config(name = controller_name)
		if RAILS_ENV == "production"
			config = grid_configs_cache[name]
			if !config
				config = load_config(name)
				grid_configs_cache[name] = config
			end
		else
			config = load_grid_config(name)
		end
		prepare_grid_columns(config) if config["columns"]
		config
	end

	# Gets grid columns names for specified grid name (controller name by default).
	def grid_columns_names(name = controller_name)
		config = grid_config(name)
		config["columnNames"].collect{|column| "'#{column}'"}.join(",")
	end

	# Gets grid columns descriptors for specified grid name (controller name by default).
	def grid_columns(name = controller_name)
		config = grid_config(name)
		config["columns"].collect{|column| grid_column(column)}.join(",\r\n")
	end

	# Generates grid column json representation for specified descriptor.
	def grid_column(column_info)
		columns = []
		column_info.each do |key, value|
			columns.push(data_to_js(key, value))
		end
		columns = columns.join(",")
		"{#{columns}}"
	end

	# Generates json representation for specified key-value pair.
	def data_to_js(key, value)
		if (value.is_a? String) && (key.to_s != "formatter")
			"#{key}: '#{value}'"
		else
			"#{key}: #{value}"
		end
	end
end