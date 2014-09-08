Discourse::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true
  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  if rails4?
    config.assets.js_compressor  = :uglifier
    config.assets.css_compressor = :sass
  else
    config.assets.compress = true
  end

  # stuff should be pre-compiled
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true
  config.assets.prefix = '/discourse/assets'

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  ActionMailer::Base.smtp_settings = {
    :address        => ENV['SMTP_HOST'],
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SMTP_USERNAME'],
    :password       => ENV['SMTP_PASSWORD'],
    :domain         => ENV['SMTP_DOMAIN'],
    :enable_starttls_auto => true
  }

  # Discourse master. Requires hard coding values in a file. Not 12 factor.
  # if GlobalSetting.smtp_address
  #   settings = {
  #     address:              GlobalSetting.smtp_address,
  #     port:                 GlobalSetting.smtp_port,
  #     domain:               GlobalSetting.smtp_domain,
  #     user_name:            GlobalSetting.smtp_user_name,
  #     user_name:            GlobalSetting.smtp_password,
      # authentication:       GlobalSetting.smtp_authentication,
  #     enable_starttls_auto: GlobalSetting.smtp_enable_start_tls
  #   }

  #   config.action_mailer.smtp_settings = settings.reject{|x,y| y.nil?}
  # else
  #   config.action_mailer.delivery_method = :sendmail
  #   config.action_mailer.sendmail_settings = {arguments: '-i'}
  # end

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # this will cause all handlebars templates to be pre-compiles, making your page faster
  config.handlebars.precompile = true

  # allows admins to use mini profiler
  config.enable_mini_profiler = GlobalSetting.enable_mini_profiler

  # Discourse strongly recommend you use a CDN.
  # For origin pull cdns all you need to do is register an account and configure
  #config.action_controller.asset_host = GlobalSetting.cdn_url

  config.action_controller.asset_host = Proc.new do |source, request = nil|
    scheme = request.try(:ssl?) ? "https" : "http"
    "#{scheme}://cdn#{Digest::MD5.hexdigest(source).to_i(16) % 3}.railsenespanol.co.global.prod.fastly.net"
    #"#{scheme}://#{ENV['S3_BUCKET']}.s3.amazonaws.com"
  end

  # a comma delimited list of emails your devs have
  # developers have god like rights and may impersonate anyone in the system
  # normal admins may only impersonate other moderators (not admins)
  if emails = GlobalSetting.developer_emails
    config.developer_emails = emails.split(",")
  end

end
