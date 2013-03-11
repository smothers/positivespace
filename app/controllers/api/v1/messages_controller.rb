class Api::V1::MessagesController < InheritedResources::Base
	belongs_to :user

	respond_to :json
	actions :show, :index, :create, :update, :destroy


	has_scope :page, :only => :index, :default => 1 do |controller, scope, value|
		value.to_i > 0 ? scope.page(value.to_i) : scope.page(1)
	end
	has_scope :per, :only => :index, :default => 10


	before_filter :authenticate_user!, :except => [:create, :update]
	load_and_authorize_resource


	before_filter :pick_params, :only => [:create, :update]


	def create
		@user = User.find(params[:user_id])
		@message = Message.new(params[:message])
		@message.to = @user
		@message.from = current_user
		@message.session_id = positivespace_session_id
		@message.save!
	end

protected

	def collection
		@messages = apply_scopes(end_of_association_chain)
	end

	def pick_params
		if message = params[:message]
			params[:message] = pick(message, Message.accessible_attributes.to_a)
		end
	end
end