module GramGoods
  module Instagram
    def config
      ::Instagram.configure do |config|
        config.client_id = self.uid
        config.access_token = self.access_token
      end
    end

    def fetch_media_count
      config
      (::Instagram.user.counts.media).to_i
    end

    def feed_item(item)
      tags = item.tags
      like_count = item.likes[:count]
      url = item.images.standard_resolution.url

      (Struct.new(:like_count, :url, :tags)).new(like_count, url, tags)
    end

    def fetch_recent_media(max_id = nil)
      config

      i = 0
      last_id = nil
      items = ::Instagram.user_recent_media({:max_id => max_id}).tap do |items|
        i += items.length
        puts last_id = items.last.id
      end.map { |item| feed_item(item) }

      {
        :items => items,
        :i => i,
        :last_id => last_id
      }
    end

    def fetch_feed(max_id = nil)
      config

      media_count = fetch_media_count
      last_id = nil
      i = 0
      user_photo_feed = []

      lambda { |_self, max_id|
        response = fetch_recent_media(max_id)

        i += response[:i]
        last_id = response[:last_id]
        user_photo_feed.concat response[:items]

        _self.call(_self, last_id) if i < media_count
      }.tap { |_self| _self.call(_self, max_id) }

      block_given? ? yield(user_photo_feed) : user_photo_feed
    end

    def fetch_feed_and_filter_by_tag(_tag)
      tag = _tag.downcase
      tag = tag.split('#')[1] if /^#+/ =~ tag

      fetch_feed do |user_photo_feed|
        user_photo_feed.find_all { |item| item.tags.member?(tag) }
      end
    end

    def comment_on_feed_item(id, comment = 'WAT?')
      # background task
      config
      ::Instagram.create_media_comment(id, comment)
    end
    #handle_asynchronously :comment_on_feed_item, :run_at => Proc.new { 20.minutes.from_now }

    def comment_on_feed_items(items)
      items.each &:comment_on_feed_item
    end

    private
      def config
        ::Instagram.configure do |config|
          config.client_id = self.uid
          config.access_token = self.access_token
        end
      end
  end
end
