class SearchController < ApplicationController
  before_action :preload_data

  def preload_data
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
  end

  def load_search_data
    render json: @data
  end

  def search
    if params[:search_query].nil? || params[:search_query].size == 0
      #notice
      else
      find(params[:search_query])
      #render json: @results
      @gists = @results
      render 'gists/index'
    end
  end

  def find(value)
    @results = Array.new
    @data.each { |v|
      if v[:label].include?(value) || v[:value].include?(value)
        @results[@results.size] = GistModel.find(v[:value])
      end
    }
  end

end
