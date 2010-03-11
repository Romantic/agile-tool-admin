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
        :add                 => true
      }.merge(options)

    show_edit = options.delete(:edit)
    show_add = options.delete(:add)
    width = options.delete(:width)
    width = fields.inject (100) {|sum, field| sum + field[:width]} unless width

    fields << { :field => "action_view", :label => "", :width => 20, :search => false }
    fields << { :field => "action_edit", :label => "", :width => 20, :search => false } if show_add

    output = jqgrid("", grid_name, url_for(:action => "grid_data"), fields, options)

    output << %Q(
      <script type="text/javascript">

        $(function() {
          $("##{grid_name}").jqGrid('setGridWidth', #{width});
        });

        function gridLoadHandler() {
          fixGridHeight('##{grid_name}', 400)
          #{add_row_buttons(grid_name, show_edit)}
          #{add_grid_buttons(grid_name, show_add)}
        }

      </script>
    )
  end

  def add_row_buttons(grid_name, show_edit)
    buttons = [{
      :path => url_for(:action => "show", :id => ":id"),
      :title => t("view_details", :scope => @controller.controller_path.split("/")),
      :icon => "ui-icon-comment",
      :column => "action_view"
    }]

    if show_edit
      buttons << {
        :path => url_for(:action => "edit", :id => ":id"),
        :title => t("edit_details", :scope => @controller.controller_path.split("/")),
        :icon => "ui-icon-pencil",
        :column => "action_edit"
      }
    end

    output = "addGridRowButtons('##{grid_name}',["
    buttons.each do |button|
      output << "#{button.to_json},"
    end
    output << "]);"
  end

  def add_grid_buttons(grid_name, show_add)
    output = ""
    if show_add
      output << %Q(
        addGridButton('##{grid_name}', '#pg_#{grid_name}_pager', {
            buttonicon: 'ui-icon-plus',
            caption: '',
            title: '#{t(".create_new")}',
            onClickButton: function(){ window.location = '#{url_for :action => "new"}'},
            position: 'first'
        });
      )
    end
    output
  end
end

