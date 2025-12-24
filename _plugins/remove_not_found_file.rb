require 'fileutils'

module Jekyll
  class Clean404 < Generator
    safe true

    def generate(site)
      Jekyll::Hooks.register :site, :post_write do |_site|
        # Ignora o idioma padrão (mantém o 404 da raiz)
        next if _site.config['lang'] == _site.config['default_lang']

        not_found_path = File.join(_site.dest, '404.html')

        if File.exist?(not_found_path)
          FileUtils.rm_f(not_found_path)
        end
      end
    end
  end
end