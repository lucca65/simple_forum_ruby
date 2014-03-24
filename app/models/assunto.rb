class Assunto
	include Mongoid::Document

	field :assunto, type: String
	field :texto, type: String
	field :data_criacao, type: DateTime
	
	embeds_many :comentarios

	validates_presence_of :assunto
	validates_presence_of :texto
end
