module ActionView::Helpers::UrlHelper

  def link_to(*args, &block)
    if block_given?
      options      = args.first || {}
      html_options = args.second
      concat(link_to(capture(&block), options, html_options))
    else
      name         = args.first
      options      = args.second || {}
      html_options = args.third
      button_options = args[3]

      url = url_for(options)

      if html_options
        html_options = html_options.stringify_keys
        href = html_options['href']
        convert_options_to_javascript!(html_options, url)
        tag_options = tag_options(html_options)
      else
        tag_options = nil
      end

      href_attr = "href=\"#{url}\"" unless href

      if button_options
        image = tag :img, { :alt => name, :src => MagicDoorHelper.new(name, button_options).generate_and_get_path! }
        "<a #{href_attr}#{tag_options}>#{image}</a>"
      else
        "<a #{href_attr}#{tag_options}>#{name || url}</a>".html_safe
      end
    end
  end

end
