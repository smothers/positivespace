FriendlyId.defaults do |config|
	config.use :slugged, :reserved
	config.reserved_words = %w(
		a
		about
		account
		add
		admin
		answer
		answers
		api
		app
		apps
		archive
		archives
		auth
		better
		blog
		cache
		changelog
		chaos
		codereview
		compare
		config
		connect
		contact
		create
		current
		data
		delete
		dev
		direct_messages
		downloads
		edit
		email
		emptiness
		enterprise
		faq
		favorites
		feed
		feeds
		follow
		followers
		following
		gist
		help
		home
		hosting
		ideas
		index
		invitations
		invite
		koosalagoopagoop
		lists
		login
		logout
		logs
		map
		maps
		me
		mine
		nameless
		negentropy
		new
		news
		oauth
		oauth_clients
		openid
		organization
		organizations
		plans
		popular
		privacy
		profile
		profiles
		project
		projects
		q
		question
		questions
		random
		register
		remove
		replies
		rss
		save
		search
		security
		sessions
		settings
		shop
		show
		signup
		sitemap
		ssl
		status
		stories
		style
		styleguide
		subscribe
		tasks
		terms
		todo
		tour
		translation
		translations
		trends
		unfollow
		unsubscribe
		url
		user
		users
		widget
		widgets
		wiki
		xfn
		xmpp
	)
end
