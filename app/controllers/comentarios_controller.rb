class ComentariosController < ApplicationController

	def new
		@parent_id = params[:parent_id]
		@subcomentario = params[:subcomentario]
		@comentario = Comentario.new
		respond_to do |format|
			format.js
		end
	end

	def create
		@comentario = Comentario.new(comentario_params)

		limpar_palavras!(@comentario.resposta)
		# verificar se não tem palavras da blacklist!

		sub = params[:subcomentario] == 'true'

		if sub
			# comentario de comentario
			bson_id = BSON::ObjectId.from_string(params[:parent_id])
			@comentarios = []

			# Pego os comentarios do primeiro nível com o map
			# E uso recursão para pegar todos os níveis de comentários
			Assunto.all.map(&:comentarios).flatten.each { |x| recursion(x)	}

			comentario_pai = @comentarios.flatten.find{|x| x.id == bson_id}
			comentario_pai.comentarios << @comentario

			respond_to do |format|
				format.html { redirect_to '/', notice: 'Comentario sobre comentario criado!' }
			end
		else
			# comentario de assunto
			assunto = Assunto.find(params[:parent_id])
			assunto.comentarios << @comentario

			respond_to do |format|
				format.html { redirect_to '/assuntos#index', notice: 'Comentario criado!'}
			end
		end
	end

	private
	def comentario_params
		params.require(:comentario).permit(:resposta, :assunto_id, :comentario_id)
	end

	def limpar_palavras!(texto)
		black_list = YAML.load_file('config/palavras_restritas.yml')
		black_list.each do |palavra|

			puts 'mudando palavra...' + palavra
			regex = Regexp.new /#{palavra}/i
			# Brute force para substituições mais comuns -- to sem tempo :|
			texto.gsub!(regex, "*" * palavra.length)
		end
	end

	def recursion(rec)
		# Adiciono todos os comentarios deste nível
		@comentarios << rec

		# Adiciono os comentarios de cada nível abaixo
		if rec.is_a?(Array)
			rec.each { |x| recursion(x.comentarios) if x.comentarios.any? }
		else
			recursion(rec.comentarios) if rec.comentarios.any?
		end
	end

end
