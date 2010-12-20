class CustomFormBuilder < ActionView::Helpers::FormBuilder

  def submit(value = "Save changes", options = {}, button_options = {})
    @template.tag :input, {
      'value' => value,
      'type' => 'image',
      'src' => @template.image_path(MagicDoorHelper.new(value, button_options).generate_and_get_path!)
    }.update(options.stringify_keys)
  end

end
