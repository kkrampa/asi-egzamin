class SmsSender
  def initialize(config)
    @config = config
  end

  def send_sms(phone_number, message)
    begin
      puts @config.email
      puts @config.password
      puts @config.device
      puts phone_number
      puts message
      RestClient.post 'smsgateway.me/api/v3/messages/send',
                       {
                         :email => @config.email,
                         :password => @config.password,
                         :device => @config.device,
                         :number => phone_number,
                         :message => message
                       }.to_json, :content_type => :json, :accept => :json
        true
    rescue RestClient::Unauthorized
      puts "unau"
      false
    rescue RestClient::RequestFailed
      puts "fail"
      false
    end
  end
end
