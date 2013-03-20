module ApplicationHelper
  def edit_icon
    icon(name: "pencil")
  end

  def icon(options, &block)
    content = block_given? ? capture(&block) : ""
    classes = ["icon-#{options[:name]}", options[:class]].compact
    [
      "<i class=\"#{classes.join(" ")}\"></i>", 
      options[:label],
      content
    ].compact.join(" ").html_safe
  end

  def button(label, url, options = {})
    options = {:class => "btn"}.merge(options)
    link_to label, url, options
  end

  def bootstrap_form_for(object, options = {}, &block)
    options[:builder] = BootstrapFormBuilder
    form_for(object, options, &block)
  end

  def flash_label(content, options = {})
    classes = ["label"]
    classes << "label-#{options.fetch(:type)}" if options.has_key?(:type)
    classes << options.fetch(:class) if options.has_key?(:class)
        
    content_tag :span, content, :class => classes.join(" ")
  end

  def call_form
    render(partial: "call_form").to_str
  end
end
