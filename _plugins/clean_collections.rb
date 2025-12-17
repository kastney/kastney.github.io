# Importa utilitários de sistema de arquivos para permitir remoção de diretórios gerados.
require 'fileutils'

# Define um plugin customizado do Jekyll.
module Jekyll
	# Gerador responsável por limpar diretórios de coleções que não pertencem ao idioma ativo.
	class CleanCollections < Generator
		# Indica que o plugin é seguro para execução no modo seguro do Jekyll.
		safe true

		# Método principal chamado durante o ciclo de geração do site.
		def generate(site)
			# Registra um hook executado após o Jekyll terminar de escrever os arquivos no _site.
			Jekyll::Hooks.register :site, :post_write do |_site|
				# Obtém a lista de idiomas definidos na configuração do site.
				languages = site.config['languages'] || []
				# Define o idioma padrão como o primeiro da lista de idiomas.
				default_lang = languages.first
				# Obtém o idioma atualmente ativo na build.
				current_lang = site.config['lang']

				# Todas as páginas que definem a propriedade "posters".
				poster_pages = site.pages.select { |p| p.data['posters'] }

				# Itera por cada página que define coleções de posters.
				poster_pages.each do |page|
					# Itera por cada idioma configurado no site.
					languages.each do |lang|
						# Define a chave do permalink conforme o idioma, usando o padrão sem sufixo para o idioma default.
						permalink_key = (lang == default_lang) ? 'permalink' : "permalink_#{lang}"

						# Não remove o diretório correspondente ao idioma atualmente ativo.
						next if lang == current_lang

						# Obtém o permalink base correspondente ao idioma atual do loop.
						base_permalink = page.data[permalink_key]
						# Ignora o processamento caso o permalink não esteja definido na página.
						next unless base_permalink

						# Remove apenas o diretório do idioma não ativo.
						rel = base_permalink.sub(%r{^/}, '')
						# Monta o caminho absoluto do diretório a ser removido dentro do _site.
						target = File.join(site.dest, rel)
						# Remove recursivamente o diretório e todo o seu conteúdo, se existir.
						FileUtils.rm_rf(target)
					end
				end

				# Após remover os diretórios, limpa quaisquer pastas vazias restantes no _site.
				remove_empty_dirs_recursive(site.dest)
			end
		end

		private

		# Remove recursivamente diretórios vazios a partir de um diretório raiz.
		def remove_empty_dirs_recursive(root)
			# Interrompe a execução caso o diretório raiz não exista.
			return unless Dir.exist?(root)

			# Flag usada para repetir o processo enquanto ainda houver diretórios sendo removidos.
			removed_any = true
			# Loop que continua até que nenhuma pasta vazia seja removida em uma iteração.
			while removed_any
				# Reseta a flag no início de cada iteração.
				removed_any = false

				# Obtém todos os diretórios abaixo da raiz e ordena do mais profundo para o mais superficial.
				dirs = Dir.glob(File.join(root, '**', '*'))
						  .select { |p| File.directory?(p) }
						  .sort_by { |d| -d.count(File::SEPARATOR) }

				# Itera sobre cada diretório encontrado.
				dirs.each do |dir|
					# Ignora o diretório raiz para evitar sua remoção acidental.
					next if File.identical?(dir, root) rescue false

					# Tenta obter os arquivos e subdiretórios contidos no diretório atual.
					begin
						# Obtém os arquivos e subdiretórios contido no diretório atual.
						children = Dir.children(dir)
					rescue Errno::ENOENT
						# Ignora o diretório caso ele tenha sido removido por outro processo.
						next
					end

					# Verifica se o diretório está vazio.
					if children.empty?
						# Tenta remover o diretório vazio.
						begin
							# Remove o diretório vazio.
							Dir.rmdir(dir)
							# Marca que ao menos um diretório foi removido nesta iteração.
							removed_any = true
						rescue
							# Ignora diretórios que não podem ser removidos por estarem em uso ou protegidos.
						end
					end
				end
			end
		end
	end
end