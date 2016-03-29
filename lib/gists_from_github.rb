class GistsFromGitHub
  def self.gists
    get_resource('gists')
  end

  def self.find(_params)
    if _params[:id].nil? || _params[:id].size == 0
      raise "Resource not Found : Missing id"
    else
      all = gists_with_details
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

  def self.gists_with_details
    Rails.cache.fetch('gists_with_details', expire_in: 1.minutes) do
      vgists = gists
      gists_with_d = Array.new
      vgists.each { |g|
        gists_with_d[gists_with_d.size] = JSON.parse(get_from_github_with_details(g[:id]), :symbolize_names => true)
      }
      gists_with_d
    end
  end

  def self.gists_by_ids
    Rails.cache.fetch('gists_by_ids', expire_in: 1.minutes) do
      vgists = gists
      gists_ids = Array.new
      vgists.each { |g|
        gists_ids[gists_ids.size] = g[:id]
      }
      gists_ids
    end
  end

  def self.gists_by_description
    Rails.cache.fetch('gists_by_description', expire_in: 1.minutes) do
      vgists = gists
      gists_ds = Array.new
      vgists.each { |g|
        if g[:owner].nil?
          owner = "Anonymous"
        else
          owner = g[:owner][:login]
        end
        gists_ds[gists_ds.size] = ["#{owner}/#{g[:description]}", g[:id]]
      }
      gists_ds
    end
  end

  def self.get_from_github(resource)
    RestClient.get "#{base_url}/#{resource}"
  end

  def self.get_from_github_with_details(id)
    RestClient.get "#{base_url}/gists/#{id}"
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