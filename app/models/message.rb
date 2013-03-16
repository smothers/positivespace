require 'embedly'
class Message < ActiveRecord::Base

	state_machine :initial => :pending do
		event :continue do
			transition :pending => :continued
		end

		event :discontinue do
			transition :pending => :discontinued
		end
	end

	attr_accessible :body, :embed_url, :from_email
	attr_protected :none, as: :admin

	serialize :embed_data

	belongs_to :to, :class_name => 'User', :foreign_key => :to_id
	belongs_to :from, :class_name => 'User', :foreign_key => :from_id

	validates :body, presence: true, length: {maximum: 250}

	default_scope :order => 'created_at asc'

	scope :pending, where(state: :pending)
	scope :continued, where(state: :continued)
	scope :discontinued, where(state: :discontinued)
	scope :between, lambda { |id1, id2| where("(from_id = ? AND to_id = ?) OR (from_id = ? AND to_id = ?)", id1, id2, id2, id1) }

	def self.total_seconds_to_edit
		0 # TODO: think about removing all of this out
	end

	def seconds_left_to_edit
		self.created_at + Message.total_seconds_to_edit - DateTime.now.utc
	end

	# def embed_url= url
	#	# TODO: move the key out of the model
	#	unless url.blank?
	#		embedly_api = Embedly::API.new :key => 'TODO: Add a key', :user_agent => 'Mozilla/5.0 (compatible; mytestapp/1.0; my@email.com)'
	#		obj = embedly_api.oembed :url => url
	#		self.embed_data = obj[0].marshal_dump
	#	end
	#	super url
	# end

	def editors
		[self.from]
	end
end
