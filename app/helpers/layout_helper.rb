# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def stylesheet_merged(*args)
    content_for(:head) { stylesheet_link_merged(*args) }
  end
    
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def javascript_merged(*args)
    content_for(:head) { javascript_include_merged(*args) }
  end
    
  def main_menu(items)
    render :partial => "/controls/main_menu", :locals => {:items => items}
  end
  
  def link_button(text, icon, url, options = {})
    if (icon)
      text = "<span class=\"ui-icon ui-icon-#{icon}\"></span>#{text}";
    end
    options[:class] = "link_button ui-state-default ui-corner-all"
    link_to(text, url, options)
  end
  
  def crumbs
    if @crumbs
      list_items = String.new

      @crumbs.each do |c|
        list_items << content_tag(:li, link_to(h(c[:label]), c[:link]), :class => c[:class]) if c[:link]
        list_items << content_tag(:li, h(c[:label]), :class => c[:class]) unless c[:link]
      end

      content_tag :ul, list_items, :class => 'breadcrumb'
    end
  end  
end
