class SmsSender
  def initialize(config)
    @config = config
  end

  def send_sms(phone_number, message)
    response = RestClient.post 'smsgateway.me/api/v3/messages/send',
                               {
                                 :email => @config.email,
                                 :password => @config.password,
                                 :device => @config.device,
                                 :number => phone_number,
                                 :message => message
                               }.to_json, :content_type => :json, :accept => :json
    response.code == 200
  end
end