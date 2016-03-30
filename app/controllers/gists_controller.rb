class GistsController < ApplicationController
  before_action :set_gist, only: [:show, :tag]#, :edit, :update, :destroy]

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
    if @gist.nil? || @gist.size == 0
      respond_to do |format|
        format.html { redirect_to gists_path, notice: 'Resource not found.' }
      end
    end
    #render json: @GistModel
  end

  # GET /gists/new

  def tag
    #render json: params
    tag_params = set_tagging_params
    if tag_params.nil?
      respond_to do |format|
        format.html { redirect_to gist_path(@gist[:id]), notice: 'Error: No tagging Parameters' }
      end
    else
      to_be_deleted = Array.new
      unless @my_categories.nil? || @my_categories.size == 0
        @my_categories.each { |v|
          hash = {gist_id: @gist[:id], category_id: v.id}
          if tag_params.include?(hash)
            tag_params = tag_params - [hash]
          else
            to_be_deleted[to_be_deleted.size] = hash
          end
        }
      end
      unless to_be_deleted.nil? || to_be_deleted.size == 0
        to_be_deleted.each { |v|
          gist_by_cat = GistsByCategory.find_by_category_id_and_gist_id(v[:category_id],v[:gist_id])
          gist_by_cat.destroy
        }
      end
      unless tag_params.nil? || tag_params.size == 0
        tag_params.each { |v|
          gist_by_cat = GistsByCategory.create(category_id: v[:category_id], gist_id: v[:gist_id])
          respond_to do |format|
            format.html { redirect_to gist_path(@gist[:id]), notice: "Error: Something went wrong: #{gist_by_cat.errors[:base]}" }
          end
          return
        }
      end
      respond_to do |format|
        format.html { redirect_to gist_path(@gist[:id]), notice: 'The gist was successfully tagged' }
      end

    end
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
    @my_categories = GistModel.categories(@gist)
  end

  def set_tagging_params
    unless params[:categories].nil?
      gists_by_categories = Array.new
      params[:categories].each { |c|
        gists_by_categories[gists_by_categories.size] = {category_id: c, gist_id: params[:id]}
      }
      gists_by_categories
    end
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def gist_params
    #params.fetch(:GistModel, {})
  end
end
