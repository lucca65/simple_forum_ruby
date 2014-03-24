class Comentario
	include Mongoid::Document
	
	field :resposta, type: String

	embedded_in :assunto

	embeds_many :comentarios
  	belongs_to :comentario, class_name: 'Comentario'

	validates_presence_of :resposta
end
