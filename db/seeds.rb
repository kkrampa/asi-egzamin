User.create!(name:  "Marek Strzała",
             email: "marekwstrzala@gmail.com",
             password:              "marek123",
             password_confirmation: "marek123",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Kamil Krampa",
             email:  "mail@kamil.com",
             password:              "kamil123",
             password_confirmation: "kamil123",
	     admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Testowy",
             email:  "test@test.com",
             password:              "test123",
             password_confirmation: "test123",
             activated: true,
             activated_at: Time.zone.now)

users = User.order(:created_at).take(3)

3.times do |n|
  user = users[n]
  SmsConfig.create!(email:"wojtark@vp.pl", 
		   password: "lubieplacki1", 
		   device: 8795,
		   user_id: user.id)
end

3.times do |n|
  user = users[n]
  Contact.create!(email: "marekwstrzala@gmail.com",
    		  phone_number: 516540467,
    		  user_id: user.id,
    		  name: "Kontakt Testowy")
end

