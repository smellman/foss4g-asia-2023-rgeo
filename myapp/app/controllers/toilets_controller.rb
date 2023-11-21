class ToiletsController < ApplicationController
  before_action :set_toilet, only: %i[ show update destroy ]

  # GET /toilets
  def index
    @toilets = Toilet.all
    geojson = {
      type: "FeatureCollection",
      features: @toilets.map(&:as_json)
    }
    render json: geojson
  end

  # GET /toilets/1
  def show
    render json: @toilet
  end

  # POST /toilets
  def create
    @toilet = Toilet.new(toilet_params)

    if @toilet.save
      render json: @toilet, status: :created, location: @toilet
    else
      render json: @toilet.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /toilets/1
  def update
    if @toilet.update(toilet_params)
      render json: @toilet
    else
      render json: @toilet.errors, status: :unprocessable_entity
    end
  end

  # DELETE /toilets/1
  def destroy
    @toilet.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_toilet
      @toilet = Toilet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def toilet_params
      params.fetch(:toilet, {})
    end
end
