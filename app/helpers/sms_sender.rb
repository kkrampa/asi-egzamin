class SmsSender
  def initialize(config)
    @config = config
  end

  def send_sms(phone_number, message)
    begin
      RestClient.post 'smsgateway.me/api/v3/messages/send',
                       {
                         :email => @config.email,
                         :password => @config.password,
                         :device => @config.device,
                         :number => phone_number,
                         :message => message[0].to_s
                       }.to_json, :content_type => :json, :accept => :json
        true
    rescue RestClient::Unauthorized
      false
    rescue RestClient::RequestFailed
      false
    end
  end
end
