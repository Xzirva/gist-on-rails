class GistsController < ApplicationController
  before_action :set_gist, only: [:show]#, :edit, :update, :destroy]

  # GET /gists
  # GET /gists.json
  def index
    @gists = GistModel.all
    #byebug
    #render json: @gists
  end

  # GET /gists/1
  # GET /gists/1.json
  def show
    #render json: @GistModel
  end

  # GET /gists/new
  def new
    @gists = GistModel.new
  end

  # GET /gists/1/edit
  #def edit
  #end

  # POST /gists
  # POST /gists.json
  #def create
  #  @GistModel = GistModel.new(GistModel_params)
  #
  # respond_to do |format|
  #   if @GistModel.save
  #     format.html { redirect_to @GistModel, notice: 'GistModel was successfully created.' }
  #     format.json { render :show, status: :created, location: @GistModel }
  #   else
  #     format.html { render :new }
  #     format.json { render json: @GistModel.errors, status: :unprocessable_entity }
  #   end
  # end
  #end

  # PATCH/PUT /gists/1
  # PATCH/PUT /gists/1.json
  #def update
  #  respond_to do |format|
  #    if @GistModel.update(GistModel_params)
  #      format.html { redirect_to @GistModel, notice: 'GistModel was successfully updated.' }
  #      format.json { render :show, status: :ok, location: @GistModel }
  #    else
  #      format.html { render :edit }
  #      format.json { render json: @GistModel.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /gists/1
  # DELETE /gists/1.json
  #def destroy
  #  @GistModel.destroy
  #  respond_to do |format|
  #    format.html { redirect_to GistModels_url, notice: 'GistModel was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gist
      @gist = GistModel.find(params[:id])
      @my_categories = Array.new
      categories_ids = GistsByCategory.where(gist_id: params[:id]).pluck(:category_id)
      categories_ids.each { |v|
        @my_categories[@my_categories.size] = Category.find(v)
      }

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gist_params
      #params.fetch(:GistModel, {})
    end
end
