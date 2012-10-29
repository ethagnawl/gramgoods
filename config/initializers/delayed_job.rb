Delayed::Worker.logger = Rails.logger
Delayed::Worker.logger.auto_flushing = true

if Rails.env.production?
  DelayedJobWeb.use Rack::Auth::Basic do |username, password|
    username == 'GramG00d$' && password == '0ct@n3!'
  end
end
