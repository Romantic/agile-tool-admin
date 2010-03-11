# Provides helper methods for jquery ajax grid integration.
module JqueryGridHelper

  # Renders helper javascript method for grid with new, edit, view and delete buttons.
  def jquery_custom_grid(fields, options = {}, grid_name = controller_name)

    # Default options
    options =
      {
        :edit_url            => url_for(:action => "grid_edit"),
        :grid_loaded         => "gridLoadHandler",
        :error_handler       => "gridErrorHandler",
        :multi_selection     => true,
        :rownumbers          => true,
        :delete              => true,
        :edit                => true,
        :add                 => true,
        :view                => true
      }.merge(options)

    show_add = options.delete(:add)
    show_view = options.delete(:view)
    show_edit = options.delete(:edit)
    width = get_width(options, fields)
    row_buttons = options.delete(:row_buttons) || []
    grid_buttons = options.delete(:grid_buttons) || []
    row_buttons += get_row_buttons(show_view, show_edit)
    grid_buttons += get_grid_buttons(show_add)

    fields << { :field => "action_view", :label => "", :width => 20, :search => false } if show_view
    fields << { :field => "action_edit", :label => "", :width => 20, :search => false } if show_edit

    output = jqgrid("", grid_name, url_for(:action => "grid_data"), fields, options)

    output << %Q(
      <script type="text/javascript">

        $(function() {
          $("##{grid_name}").jqGrid('setGridWidth', #{width});
        });

        function gridLoadHandler() {
          fixGridHeight('##{grid_name}', 400)
          #{add_row_buttons(grid_name, row_buttons)}
          #{add_grid_buttons(grid_name, grid_buttons)}
        }

      </script>
    )
  end

  def add_row_buttons(grid_name, buttons)
    output = "addGridRowButtons('##{grid_name}',["
    buttons.each do |button|
      output << "#{button.to_json},"
    end
    output << "]);"
  end

  def add_grid_buttons(grid_name, buttons)
    output = "addGridButton('##{grid_name}', '#pg_#{grid_name}_pager', ["
    buttons.each do |button|
      output << "#{button.to_json},"
    end
    output << "]);"
  end

  def get_width(options, fields)
    width = options.delete(:width)
    width = fields.inject (100) {|sum, field| sum + field[:width]} unless width
  end

  def get_row_buttons(show_view, show_edit)
    buttons = []
    if show_view
      buttons << {
        :path => url_for(:action => "show", :id => ":id"),
        :title => t("view_details", :scope => @controller.controller_path.split("/")),
        :icon => "ui-icon-comment",
        :column => "action_view"
      }
    end

    if show_edit
      buttons << {
        :path   => url_for(:action => "edit", :id => ":id"),
        :title  => t("edit_details", :scope => @controller.controller_path.split("/")),
        :icon   => "ui-icon-pencil",
        :column => "action_edit"
      }
    end
    buttons
  end

  def get_grid_buttons(show_add)
    buttons = []
    if show_add
      buttons << {
        :buttonicon     => "ui-icon-plus",
        :caption        => "",
        :title          => t(".create_new"),
        :onClickButton  => "function(){ window.location = '#{url_for :action => "new"}'}",
        :position       => "first"
      }
    end
    buttons
  end
end

