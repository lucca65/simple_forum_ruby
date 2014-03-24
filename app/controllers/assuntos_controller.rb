class AssuntosController < ApplicationController

	def index
		@assuntos = Assunto.all.order_by(:data_criacao.asc).page params[:page]
	end

	def show
		@assunto = Assunto.find(params[:id])
	end

	def new
		@assunto = Assunto.new
	end

	def create
		@assunto = Assunto.new(assunto_params)
		@assunto.data_criacao = DateTime.now

		respond_to do |format|
			if @assunto.save
				format.html { redirect_to action: 'index', notice: 'Nova Thread criada com sucesso!' }
			else
				format.html { render action: 'new' }
				format.json { render json: @assunto.erros, status: :unprocessable_entity }
			end
		end
	end

	private

	def assunto_params
		params.require(:assunto).permit(:assunto, :texto)
	end
end
