class ConfigsController < ApplicationController
  before_action :set_config, only: [:show, :edit, :update]
  before_action :logged_in_user

  def show
  end

  # GET /configs/new
  def new
    config = Config.find_by_user_id(current_user.id)
    if config
      redirect_to edit_config_url(config.id)
    else
      @config = Config.new
    end
  end

  # GET /configs/1/edit
  def edit
  end

  # POST /configs
  # POST /configs.json
  def create
    @config = Config.new(config_params)
    @config.user = current_user
    respond_to do |format|
      if @config.save
        format.html { redirect_to @config, notice: 'Config was successfully created.' }
        format.json { render :show, status: :created, location: @config }
      else
        format.html { render :new }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /configs/1
  # PATCH/PUT /configs/1.json
  def update
    @config.user = current_user
    respond_to do |format|
      if @config.update(config_params)
        format.html { redirect_to @config, notice: 'Config was successfully updated.' }
        format.json { render :show, status: :ok, location: @config }
      else
        format.html { render :edit }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_config
      @config = Config.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def config_params
      params.require(:config).permit(:email, :password, :device, :user_id)
    end
end
