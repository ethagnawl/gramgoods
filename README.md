GramGoods
=

GramGoods is an e-commerce platform that allows merchants to create stores using their Instagram feeds.

Getting Started
-

1. Install gems using: `bundle install`

2. [Configure your database.](http://edgeguides.rubyonrails.org/configuring.html)

3. `bundle exec rake db:setup`

4. Add the following to ~/path/to/gramgoods/.env: (These can also be exported using via /etc/exports or however else you add environment variables.)
  <pre>
  <code>
  AWS_BUCKET = 'AWS_BUCKET'
  AWS_ACCESS_KEY_ID = 'AWS_ACCESS_KEY_ID'
  AWS_SECRET_ACCESS_KEY = 'AWS_SECRET_ACCESS_KEY'

  INSTAGRAM_ID = 'INSTAGRAM_ID'
  INSTAGRAM_SECRET = 'INSTAGRAM_SECRET'

  STRIPE_API_KEY = "STRIPE_API_KEY"
  STRIPE_PUBLIC_KEY = "STRIPE_PUBLIC_KEY"

  SECRET_TOKEN = "MY_SECRET_TOKEN"

  DEVISE_SECRET_KEY = "MY_DEVISE_SECRET_KEY"
  </code>
  </pre>

5. `foreman start`
