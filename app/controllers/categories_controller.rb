class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action 'my_gists', only: [:show, :edit]
  before_action :set_gists, only: [:new, :create, :edit, :update]
  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    std_params = category_params
    @category = Category.new(title: std_params[:title], description: std_params[:description],
                             gists_by_categories_attributes: category_gists)
    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    std_params = category_params
    gists = category_gists
    old_gists = @category.gists_by_categories
    old_gists.each { |v|
      if gists.include?({gist_id: v.gist_id})
        gists = gists - [{gist_id: v.gist_id}]
      else
        v.mark_for_destruction
      end
    }

    @params = {title: std_params[:title], description: std_params[:description],
               gists_by_categories_attributes: gists}

    respond_to do |format|
      if @category.update(@params)
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_category
    render json: params
    return
    @category = Category.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def category_params
    #params.require(:category).permit(:title,:description)
    params[:category]
  end

  def category_gists
    unless params[:gists].nil?
      gists = Array.new
      params[:gists].each { |g|
        gists[gists.size] = {gist_id:g}
      }
      return gists
    end
    []
  end

  def my_gists
    @my_gists = Array.new
    @my_gists_ids = Array.new
    @category.gists_by_categories.each { |v|
      @my_gists[@my_gists.size] = GistModel.find(v.gist_id)
      @my_gists_ids[@my_gists_ids.size] = v.gist_id
    }
  end

  def set_gists
    @gists = GistModel.pluck(:description)
  end
end
