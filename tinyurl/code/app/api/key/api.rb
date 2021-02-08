module Key
  class Api < Grape::API
    version 'v1', using: :header, vendor: 'chelan'
    content_type :json, 'application/json'
    format :json
    # prefix :key
    default_format :json
    formatter :json, Grape::Formatter::Rabl

    resource :key do
      desc 'Allocate key ranges'
      params do
        requires :count, type:Integer, desc: 'how many'
      end
      post '/allocate' do
        allocated = { from: @from, count: params[:count] }
        @from += params[:count]
        allocated
      end

      desc 'Expire a key'
      params do
        requires :key, type:String, desc: 'Key to expire'
      end
      post '/keys' do
        "a number of keys that might not be next to each other"
      end
    end
  end
end
