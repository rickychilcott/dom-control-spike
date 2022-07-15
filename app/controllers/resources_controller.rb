class ResourcesController < ApplicationController
  before_action :set_resource, only: %i[ show edit update destroy ]

  # GET /resources
  def index
    @roots = Resource.roots
  end

  # GET /resources/new
  def new
    @resource = Resource.new
  end

  # GET /resources/1/edit
  def edit
    raise "ON NO!" unless can?(:edit, @resource)
  end

  # POST /resources
  def create
    @resource = Resource.new(resource_params)

    if @resource.save
      redirect_to resources_url, notice: "Resource was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /resources/1
  def update
    if @resource.update(resource_params)
      redirect_to resources_url, notice: "Resource was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /resources/1
  def destroy
    @resource.destroy
    redirect_to resources_url, notice: "Resource was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @resource = Resource.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def resource_params
      params.require(:resource).permit(:name, :ancestry)
    end
end
