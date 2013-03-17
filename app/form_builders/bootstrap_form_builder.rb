class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  def on_off(field, options = {})
    @template.content_tag :div, class: "control-group" do
      form_content = "".html_safe
      form_content += label(field) if options.fetch(:labelled, false)
      form_content += @template.content_tag(:div, class: "controls") do
        @template.content_tag :div, class: "switch switch-mini" do
          check_box field, checked: object.model.send(field)
        end
      end
    end    
  end

  def text_field(name, *args)
    options = args.last || {}
    if options.fetch(:edit_on_click, false)
      edit_on_click_text_field(name, options)
    else
      super
    end
  end

  def edit_on_click_text_field(name, options = {})
    @template.content_tag :div, class: "edit-on-click" do
      html = "".html_safe
      html += @template.content_tag :div, class: "display" do
        "#{object.send(name)} #{@template.icon(name: "pencil")}".html_safe
      end

      html += @template.content_tag :div, class: "field" do
        options.delete(:edit_on_click)
        text_field name, options
      end
    end
  end

  def save_changes(options = {})
    submit "Save Changes", {:class => "btn btn-primary"}.merge(options)
  end
end