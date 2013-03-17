module ApplicationHelper
  def edit_icon
    icon(name: "pencil")
  end

  def icon(options)
    [
      "<i class=\"icon-#{options[:name]}\"></i>", 
      options[:label]
    ].compact.join(" ").html_safe
  end

  def button(label, url, options = {})
    options = {:class => "btn"}.merge(options)
    link_to label, url, options
  end
end
