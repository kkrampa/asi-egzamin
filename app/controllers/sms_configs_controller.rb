class SmsConfigsController < ApplicationController
  before_action :set_config, only: [:show, :edit, :update]
  before_action :logged_in_user

  def show
  end

  # GET /configs/new
  def new
    config = SmsConfig.find_by_user_id(current_user.id)
    if config
      redirect_to edit_sms_config_path(config.id)
    else
      @sms_config = SmsConfig.new
    end
  end

  # GET /configs/1/edit
  def edit
  end

  # POST /configs
  # POST /configs.json
  def create
    @sms_config = SmsConfig.new(config_params)
    @sms_config.user = current_user
    respond_to do |format|
      if @sms_config.save
        format.html { redirect_to @sms_config, notice: 'Config was successfully created.' }
        format.json { render :show, status: :created, location: @sms_config }
      else
        format.html { render :new }
        format.json { render json: @sms_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /configs/1
  # PATCH/PUT /configs/1.json
  def update
    @sms_config.user = current_user
    respond_to do |format|
      if @sms_config.update(config_params)
        format.html { redirect_to @sms_config, notice: 'Config was successfully updated.' }
        format.json { render :show, status: :ok, location: @sms_config }
      else
        format.html { render :edit }
        format.json { render json: @sms_config.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_config
      @sms_config = SmsConfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def config_params
      params.require(:sms_config).permit(:email, :password, :device, :user_id)
    end
end
