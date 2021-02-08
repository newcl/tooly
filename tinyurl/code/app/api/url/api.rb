

module Url
  class API < Grape::API
    version 'v1', using: :header, vendor: 'chelan'
    content_type :json, 'application/json'
    format :json
    # prefix :api
    default_format :json
    formatter :json, Grape::Formatter::Rabl

    resource do

      before do
        # @redis = Redis.new(host: "127.0.0.1", port: 6379, db: 0)
      end



      helpers do
        def rand_in_alphabet
          @ALPHABET = [('A'..'Z'), ('a'..'z'), ('0'..'9')].map{|e| e.to_a}.reduce([],:concat)
          @ALPHABET[rand(@ALPHABET.length)]
        end

        def rand_in_alphabet_all
          @ALPHABET = [('A'..'Z'), ('a'..'z'), ('0'..'9')].map{|e| e.to_a}.reduce([],:concat)
          @ALPHABET_ALL = @ALPHABET.concat([''])
          @ALPHABET_ALL[rand(@ALPHABET_ALL.length)]
        end

        def next_key
          10.times.map{rand_in_alphabet_all}.reduce('', :+) + rand_in_alphabet
        end
      end

      desc 'Return long url'
      params do
        requires :key, type: String, desc: 'short key'
      end
      get do
        # JSON.parse(@redis.get(params[:key]).to_s())
        {get: "yeah"}
      end

      desc 'Shorten URL'
      params do
        requires :url, type:String, desc: 'Original url'
      end
      post do
        new_key = next_key()
        now = Time.now.utc
        {key: new_key, url: params[:url], created_at: now, expire: now + 1.days}
      end
    end
  end
end