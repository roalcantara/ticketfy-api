unless Customer.find_by(email: 'customer@ticketfy.io').present?
  puts 'SETTING UP A DEMO CUSTOMER'
  user = Customer.create! name: 'Customer',
                          email: 'customer@ticketfy.io',
                          password: Rails.application.secrets[:customer][:password],
                          password_confirmation: Rails.application.secrets[:customer][:password],
                          confirmed_at: Date.current
  puts "Customer user #{user.name} (#{user.email}) created!"
end
