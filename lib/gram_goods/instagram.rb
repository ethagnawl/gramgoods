module GramGoods
  module Instagram
    def fetch_feed(_args = {})
      defaults = {
        count: 18,
        method: :fetch_feed,
        max_id: nil
      }

      args = defaults.merge(_args)
      args[:key] = "#{self.uid}_feed_#{(args[:max_id] || 0)}"

      foo(args)
    end

    def fetch_feed_and_filter_by_tag(_tag)
      tag = _tag.downcase
      tag = (tag.downcase).split('#')[1] if /^#+/ =~ tag
      key = "#{self.uid}_#{tag}"
      callback = ->(feed) {
        feed.find_all do |item|
          item.tags.member?(tag)
        end
      }

      foo({
        key: key,
        recurse: true,
        callback: callback,
        method: :fetch_feed_and_filter_by_tag
      })
    end

    def comment_on_feed_item(id, comment)
      config
      ::Instagram.create_media_comment(id, comment)
    end
    handle_asynchronously :comment_on_feed_item

    def comment_on_feed_items(items)
      items.each &:comment_on_feed_item
    end

    private
      def fetch_media_count
        config
        (::Instagram.user.counts.media).to_i
      end

      def config
        ::Instagram.configure do |config|
          config.client_id = self.uid
          config.access_token = self.access_token
        end
      end

      def update_cache(method, params)
        return true
        self.send(method, params)
      end
      handle_asynchronously :update_cache, :run_at => Proc.new { 20.minutes.from_now }

      def feed_item(item)
        tags = item.tags
        like_count = item.likes[:count]
        url = item.images.standard_resolution.url
        id = item.id

        (Struct.new(:like_count, :url, :tags, :id)).new(like_count, url, tags, id)
      end

      def fetch_recent_media(args)
        config

        i = 0
        last_id = nil
        items = ::Instagram.user_recent_media(args).tap do |items|
          return false if items.empty?
          i += items.length
          last_id = items.last.id
        end

        {
          :user_media_count => args[:user_media_count].to_i,
          :items => (items.map { |item| feed_item(item) }),
          :i => i,
          :last_id => last_id
        }
      end

      def fetch_proxy(args = {})
        count = args[:count] || nil
        max_id = args[:max_id] || nil
        recurse = args[:recurse] || false
        return_object = {}

        config

        return_object[:media_count] = media_count = fetch_media_count
        last_id = nil
        i = 0
        user_photo_feed = []

        lambda { |_self, max_id|
          response = fetch_recent_media({
            max_id: max_id,
            count: count
          })

          unless response
            false
          else
            i += response[:i]
            last_id = response[:last_id]
            user_photo_feed.concat response[:items]

            _self.call(_self, last_id) if recurse && i < media_count
          end
        }.tap { |_self| _self.call(_self, max_id) }

        return_object[:user_photo_feed] = args[:callback] ?
          args[:callback].call(user_photo_feed) : user_photo_feed

        return_object
      end

      def foo(args = {})
        _cache_response = Rails.cache.read(args[:key])
        user_photo_feed_from_cache = _cache_response ? YAML::load(_cache_response) : nil

        if user_photo_feed_from_cache.nil?
          user_photo_feed = fetch_proxy(args)
          Rails.cache.write args[:key],
            YAML::dump(user_photo_feed), :expires_in => 20.minutes
          update_cache(args[:method], args)
          user_photo_feed
        else
          user_photo_feed_from_cache
        end
      end
  end
end
