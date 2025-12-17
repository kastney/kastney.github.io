# Namespace principal do Jekyll, onde plugins e extensões devem ser definidos.
module Jekyll
    # Gerador personalizado responsável por ajustar dinamicamente os permalinks das coleções com base nas páginas que definem a propriedade `posters`.
    class CustomPermalink < Generator
        # Marca este gerador como seguro, permitindo sua execução mesmo quando o Jekyll está rodando em modo seguro.
        safe true

        # Método principal executado durante o processo de build do site. Aqui é onde toda a lógica de geração e correção de permalinks acontece.
        def generate(site)
            # Obtém a lista de idiomas definidos no _config.yml. Caso não exista, utiliza um array vazio para evitar erros.
            languages = site.config['languages'] || []
            # Define o idioma padrão como o primeiro da lista. Este idioma terá URLs sem sufixo.
            default_lang = languages.first

            # Filtra todas as páginas do site que possuem a propriedade `posters` no front matter. Essas páginas funcionam como páginas-base para geração dos permalinks das coleções relacionadas.
            poster_pages = site.pages.select { |page| page.data['posters'] }

            # Itera por cada página que define um tipo de coleção (posters).
            poster_pages.each do |page|
                # Obtém o identificador do grupo de coleções.
                posters_key = page.data['posters']

                # Para cada idioma configurado no site, gera os permalinks correspondentes.
                languages.each do |lang|
                    # Define a chave do permalink: idioma padrão → 'permalink'; demais idiomas → 'permalink_<lang>'
                    permalink_key = (lang == default_lang) ? 'permalink' : "permalink_#{lang}"

                    # Obtém o permalink base definido na página.
                    base_permalink = page.data[permalink_key]
                    # Se não existir, pula para o próximo idioma.
                    next unless base_permalink

                    # Monta o nome da coleção com base no tipo e no idioma.
                    collection_name = "#{posters_key}_#{lang}"
                    # Obtém a coleção correspondente no site.
                    collection = site.collections[collection_name]
                    # Caso a coleção não exista, ignora este idioma.
                    next unless collection

                    # Itera por todos os documentos da coleção.
                    collection.docs.each do |doc|
                        # Apenas documentos que possuem a propriedade `code` participam da geração de permalink.
                        next unless doc.data['code']
                        # Gera o permalink final combinando: (1) permalink base da página; (2) código único do documento; (3) barra final para padronização.
                        doc.data['permalink'] = "#{base_permalink}#{doc.data['code']}/"
                    end
                end
            end
        end
    end
end