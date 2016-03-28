class SearchController < ApplicationController
  def load_search_data
    #searching on gist's owner, description, and files' name
    @gists = GistModel.all
    @data = Array.new
    @gists.each { |g|
      val = g[:id]
      g[:files].each { |k,v|
        @data[@data.size] = {:label => v[:filename], :value=> val, category: 'Found by file(s)'}
      }
      @data[@data.size] = {:label => g[:owner][:login], value: val, category: 'Found by owner'} unless g[:owner].nil?
      @data[@data.size] = {:label => "#{g[:description][0..100]}...", value: val, category: 'Found by description'}
    }
    render json: @data
  end

  def search

  end
end
