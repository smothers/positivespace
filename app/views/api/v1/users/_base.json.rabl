object @user
cache [@object, @object.avatar, @object.space]

attributes :id, :username, :name, :slug, :bio, :location, :personal_url, :facebook_id, :twitter_id, :twitter_handle, :magnetism, :created_at

child :avatar => :avatar do
	extends 'api/v1/images/base'
end

child :space => :space do
	extends 'api/v1/spaces/base'
end

node :uri do |user|
	"#{root_url}api/users/#{user.slug}" rescue nil
end
