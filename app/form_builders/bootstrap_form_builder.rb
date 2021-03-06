class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  def on_off(field, options = {})
    @template.content_tag :div, class: "control-group" do
      form_content = "".html_safe
      form_content += label(field) if options.fetch(:labelled, false)
      form_content += @template.content_tag(:div, class: "controls") do
        @template.content_tag :div, class: "switch" do
          check_box field, checked: object.model.send(field)
        end
      end
    end    
  end

  def text_field(name, *args)
    @template.content_tag :div, class: "control-group" do 
      content = "".html_safe
      content += label(name, class: "control-label")
      content += @template.content_tag :div, class: "controls" do
        super(name, *args) + @template.content_tag(:span, "", class: "help-inline")
      end
    end
  end

  # <div class="control-group error">
  #   <label class="control-label" for="inputError">Input with error</label>
  #   <div class="controls">
  #     <input type="text" id="inputError">
  #     <span class="help-inline">Please correct the error</span>
  #   </div>
  # </div>

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
    classes = ["btn", "btn-primary"]
    classes << "btn-#{options[:size]}" if options.has_key?(:size)
    submit "Save Changes", {class: classes.join(" ")}.merge(options)
  end
end
