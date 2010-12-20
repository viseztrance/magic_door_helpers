module ActionView::Helpers::UrlHelper

  def link_to(*args, &block)
    if block_given?
      options      = args.first || {}
      html_options = args.second
      link_to(capture(&block), options, html_options)
    else
      name           = args[0]
      options        = args[1] || {}
      html_options   = args[2]
      button_options = args[3]

      html_options = convert_options_to_data_attributes(options, html_options)
      url = url_for(options)

      href = html_options['href']
      tag_options = tag_options(html_options)

      href_attr = "href=\"#{html_escape(url)}\"" unless href

      if button_options
        image = tag :img, { :alt => name, :src => image_path(MagicDoorHelper.new(name, button_options).generate_and_get_path!)}
        "<a #{href_attr}#{tag_options}>#{image}</a>".html_safe
      else
        "<a #{href_attr}#{tag_options}>#{html_escape(name || url)}</a>".html_safe
      end
    end

  end

end
