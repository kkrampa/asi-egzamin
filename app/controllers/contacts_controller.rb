require 'google_contacts_api'

class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy, :send_sms, :create_email, :send_email]
  before_action :logged_in_user

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.where(:user_id => current_user.id)
    @sms_config = SmsConfig.find_by_user_id(current_user.id)
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)
    @contact.user = current_user
    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, flash: {success: 'Contact was successfully created.'} }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def send_sms
  end

  def sms_sender
    require 'rest-client'
    @contact = Contact.find(params[:id])
    config = SmsConfig.find_by_user_id(current_user.id)
    success = false

    if config and @contact.phone_number
      sms_sender = SmsSender.new(config)
      success = sms_sender.send_sms(@contact.phone_number, params[:message])
    end

    if success
      flash = {
          success: 'Message was sent successfully'
      }
    else
      flash = {
          danger: 'SMS was not send due to error'
      }
    end
    redirect_to contacts_path, flash: flash
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, flash: {success: 'Contact was successfully updated.' } }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, flash: {success: 'Contact was successfully destroyed.'} }
      format.json { head :no_content }
    end
  end

  def import
    client = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET,
                                site: 'https://accounts.google.com',
                                token_url: '/o/oauth2/token',
                                authorize_url: '/o/oauth2/auth')
    if params[:code] != nil
      token = client.auth_code.get_token(params[:code], :redirect_uri => import_contacts_url)
      google_contacts_user = GoogleContactsApi::User.new(token)
      contacts = google_contacts_user.contacts.to_a.sort_by{|x| x.full_name or 'Unknown'}
      contacts.each { |google_contact|
        phone_number = google_contact.phone_numbers.first
        email = google_contact.primary_email
        unless Contact.find_by_email_and_phone_number_and_user_id(email, phone_number, current_user.id)
          contact = Contact.new
          contact.name = google_contact.full_name || 'Unknown'
          contact.email = email
          contact.phone_number = phone_number
          contact.user = current_user
          contact.save
        end

      }
      redirect_to contacts_url, flash: { success: 'Contacts imported successfully'}
    else
      url = client.auth_code.authorize_url(scope: 'https://www.google.com/m8/feeds',
                                           redirect_uri: import_contacts_url)
      redirect_to url
    end
  end

  def create_email

  end

  def send_email
    UserMailer.email_to_contact(@contact, current_user.email, params[:subject], params[:message]).deliver_now
    redirect_to contacts_url, flash: { success: 'Email was sent successfully' }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:name, :email, :phone_number, :message)
    end
end
