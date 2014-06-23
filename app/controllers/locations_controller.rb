class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy, :scan]

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.order('updated_at DESC').page params[:page]
    @count = Location.count
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @meta = MetaInspector.new(@location.url, allow_redirections: :all)
    @headers = @location.headers
    # MetaInspector's external_links method needs some cleanup
    @external_links = @meta.external_links.select {|link| /^http/ =~ link }
    @internal_links = @meta.internal_links.select {|link| /^http/ =~ link }
    @email_links = @meta.external_links.select {|link| /^mailto:/ =~ link }
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/batch
  def batch
    @location = Location.new
  end

  # POST /locations/import
  def import
    list = params[:list]
    list.lines.each do |line|
      url = line.chomp
      location = Location.create({name:url, url: url, skip_scan: true})
    end
    redirect_to locations_path
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations/1/scan
  def scan
    @location.scan
    respond_to do |format|
      format.html { redirect_to @location, notice: 'Location was successfully scanned.' }
      format.json { render :show, status: :ok, location: @location }
    end
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:name, :url, :cached_results)
    end
end
