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
      flash[:notice] = 'Error: Query string is empty!'
    else
      find(params[:search_query])
      #render json: @results
      flash[:notice] = "#{@results.size} result(s) were found"
      @gists = @results
    end
    render 'gists/index'
  end

  def find(value)
    @results = Array.new
    @data.each { |v|
      if v[:label].include?(value) || v[:value].include?(value)
        @results[@results.size] = GistModel.find(v[:value])
      end
    }
    @results.uniq!
  end

  def specific_search_process
    specific_results = Array.new
    #unless params[:public].nil?
    #  @results.each { |r|
    #    specific_results[specific_results.size] = r if r[:public]
    #  }
    #end






    @results.each { |r|
      unless params[:categories].nil? || params[:categories].size == 0
        params[:categories].each{ |c|
          check = GistsByCategory.find_by_category_id_and_gist_id(Integer(c,10),r[:id])
          unless check.nil?
            specific_results[specific_results.size] = r
          end
        }
      end
      unless params[:commented].nil?
        specific_results[specific_results.size] = r unless GistModel.is_commented?(r)
      end
      unless params[:forks].nil?
        specific_results[specific_results.size] = r unless GistModel.has_forks?(r)
      end
      unless params[:fork_of].nil?
        specific_results[specific_results.size] = r unless GistModel.is_fork_of?(r)
      end
    }




    #unless params[:from].nil?
    #  @from = Date.parse(params[:from])
    #end

    #unless params[:to].nil?
    #  @to = Date.parse(params[:to])
    #end
    #unless params[:from].nil? && params[:to].nil?
    #  @results.each { |r|
    #    specific_results[specific_results.size] = r if !@from.nil? && Date.parse(r[:created_at]) > @from
    #  }
    #end
    specific_results.uniq
  end

  def specific_search
    if no_specific_params
      redirect_to search_path(search_query: params[:specific_search_query])
    else
      find(params[:specific_search_query])
      @gists = specific_search_process
      flash[:notice] = "#{@gists.size} result(s) were found"
      render 'gists/index'
    end
  end

  def no_specific_params
    params[:fork_of].nil? && params[:forks].nil? && params[:commented].nil? && params[:categories].nil? && params[:categories].size == 0
  end
end
