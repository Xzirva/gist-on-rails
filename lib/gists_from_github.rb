class GistsFromGitHub
  def self.gists
    get_resource('gists')
  end

  def self.find(_params)
    if _params[:id].nil? || _params[:id].size == 0
      raise "Resource not Found : Missing id"
    else
      all = gists
      all.each { |v|

        if v[:id] == _params[:id]
          return v
        end
      }
    end
    nil
  end

  def self.users
    get_resource('users')
  end

  def self.gists_by_user(_params)
  end

  def self.get_from_github(resource)
    RestClient.get "#{base_url}/#{resource}"
  end

  #def self.reset_cache(resource,expiration)
  #  Rails.cache.write(resource,get_from_github(resource), :expires_in => expiration.seconds)
  #end

  def self.gists_cache_key
    'gists'
  end

  def self.users_cache_key
    'users'
  end

  def self.base_url
    'https://api.github.com'
  end

  def self.initialize_cache
    [users_cache_key, gists_cache_key].each { |v|
      Rails.cache.fetch(v, expire_in: 1.minutes) do
        JSON.parse(get_from_github(v), :symbolize_names => true)
      end
    }
  end

  def self.get_resource(resource)
    initialize_cache
    Rails.cache.read(resource)
  end

end