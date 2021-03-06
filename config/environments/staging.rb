Positivespace::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this, and we use S3 and CloudFront!)
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Set Mailer Host
  config.action_mailer.default_url_options = { :host => 'ps-stage.herokuapp.com' }

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store
  config.cache_store = :dalli_store

  # Don't cache assets. Let Cloudflare do it
  # config.assets.cache_store = :null_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( email.css embed.css embed.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  config.threadsafe!
  config.dependency_loading = true if $rails_rake_task

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5


  # config.action_dispatch.rack_cache = {
  #   :metastore    => Dalli::Client.new,
  #   :entitystore  => 'file:tmp/cache/rack/body',
  #   :allow_reload => false
  # }

  # config.static_cache_control = "public, max-age=2592000"

  # config.action_controller.asset_host = ENV['FOG_HOST']
  config.action_controller.asset_host = Proc.new do |source, request=nil|
    # Serves HTML and Fonts Locally
    /.html$|.eot$|.ttf$|.woff$|.otf$/.match(source) ? '//ps-stage.herokuapp.com' : ENV['FOG_HOST_SSL']
  end
  # config.action_controller.asset_host = Proc.new do |source, request=nil|
  #   if request and request.ssl?
  #     ENV['FOG_HOST_SSL']
  #   else
  #     ENV['FOG_HOST']
  #   end
  # end
  config.action_mailer.asset_host = ENV['FOG_HOST']


  config.gzip_compression = true

  config.middleware.use ExceptionNotification::Rack,
    :email => {
      email_prefix: "[staging] ",
      sender_address: 'staging@positivespace.io',
      exception_recipients: 'dev@positivespace.io'
    }

end
