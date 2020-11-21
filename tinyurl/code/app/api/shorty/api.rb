

module Shorty
  class API < Grape::API
    version 'v1', using: :header, vendor: 'chelan'
    content_type :json, 'application/json'
    format :json
    prefix :api
    default_format :json
    formatter :json, Grape::Formatter::Rabl

    resource :shorty do

      before do
        @redis = Redis.new(host: "127.0.0.1", port: 6379, db: 0)
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
        JSON.parse(@redis.get(params[:key]).to_s())
      end

      desc 'Shorten URL'
      params do
        requires :url, type:String, desc: 'Original url'
      end
      post do
        key = next_key
        value = {
            url: params[:url],
            key: key,
            ttl: (Time.now + 1.day).utc
        }
        @redis.set(key, JSON.dump(value))
        value
      end
    end
  end
end