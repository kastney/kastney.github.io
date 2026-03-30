module Jekyll
  module ExternalHyperlinkFilter
    def hyperlink(input, url, external = false)
      if external
        "<a href=\"#{url}\" target=\"_blank\" rel=\"noopener noreferrer\">#{input}</a>"
      else
        "<a href=\"#{url}\">#{input}</a>"
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::ExternalHyperlinkFilter)