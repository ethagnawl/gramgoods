OmniAuth.config.logger = Rails.logger

INSTAGRAM_CONFIG = {
  'id' => ENV['INSTAGRAM_ID'],
  'secret' => ENV['INSTAGRAM_SECRET']
}

INSTAGRAM_CONFIG['AUTH_URL'] = '/users/auth/instagram'
