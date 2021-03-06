# object @user
# TODO: figure out how to cache this intelligently
# cache [root_object, root_object.achievements_count, root_object.relationship(current_user), (current_user and root_object.liked_by?(current_user)), (current_user and root_object.followed_by?(current_user))]

extends 'api/v1/users/base'

attributes :email, :settings, :sign_in_count, :last_sign_in_at, :updated_at, :gender, :birthday, :locale, :timezone, :remaining_invitations_count, :account_visible, :account_active , :if => lambda { |u| can?(:update, u) }

node :can_edit do |user|
	can?(:update, user)
end

node :can_delete do |user|
	can?(:destroy, user)
end

node :achievements_list, :if => lambda { |u| can?(:update, u) } do |user|
	user.achievements.pluck(:name)
end

node :accessible_attributes, :if => lambda { |u| can?(:update, u) } do |user|
	User.map_accessible_attributes
end

node :ready_conversations_count, :if => lambda { |u| can?(:update, u) } do |user|
	user.conversations.in_progress.turn(user.id).count
end

node :waiting_conversations_count, :if => lambda { |u| can?(:update, u) } do |user|
	user.conversations.in_progress.not_turn(user.id).size
end

node :ended_conversations_count, :if => lambda { |u| can?(:update, u) } do |user|
	user.conversations.ended.size
end

child root_object.magnetisms.limit(5) do
	attributes :id, :inc, :reason, :created_at
end

node :relationship do |user|
	user.relationship(current_user)
end

child :invitation => :invitation do
	child :user => :user do
		extends "api/v1/users/base"
	end
end

node :has_like do |u|
	u.liked_by?(current_user) if current_user
end

node :has_follow do |u|
	u.followed_by?(current_user) if current_user
end
