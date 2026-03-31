module Jekyll
  module FormatDateFilter

    MONTHS = {
      "us" => %w[january february march april may june july august september october november december],
      "br" => %w[janeiro fevereiro março abril maio junho julho agosto setembro outubro novembro dezembro]
    }

    def format_date(day, month, lang = "us")
      return "" if day.nil? || month.nil?

      lang = lang.to_s.downcase

      day = day.to_i
      month = month.to_i

      return "" if month < 1 || month > 12

      months = MONTHS[lang] || MONTHS["us"]
      month_name = months[month - 1]

      case lang
      when "br"
        "#{day} de #{month_name}"
      else
        "#{month_name.capitalize} #{day}"
      end
    end

  end
end

Liquid::Template.register_filter(Jekyll::FormatDateFilter)