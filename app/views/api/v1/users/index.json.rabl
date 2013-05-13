# object @users

# extends 'api/v1/users/base'

object false

node(:total) { |i| @users.total_count }
node(:total_pages) { |i| @users.num_pages }

child @users => :collection do
	# TODO: can cacheing be enabled with search?
	# cache @users
	extends 'api/v1/users/base'

	node :typeahead do |u|
		html = ''
			html << "<div style='white-space: normal;'>"
				html << "<div class='pbs'>"
					html << "<div class='pull-left mrs'>"
						html << image_tag(u.avatar.image.thumb.url, :class => "img-circle img-border img-mini") if u.avatar
					html << "</div>"
					html << "<div>"
						html << u.username if u.username
						# html << "<br/>"
						# html << "<small>#{u.name}</small>"
					html << "</div>"
				html << "</div>"
				html << "<div><small>"
					html << u.body if u.body
				html << "</small></div>"
				html << "<div class='muted pull-right plm'><small>"
					html << u.location if u.location
				html << "</small></div>"
				html << "<div class='faded'><small>"
					html << u.personal_url if u.personal_url
				html << "</small></div>"
			html << "</div>"
		html
	end
end
