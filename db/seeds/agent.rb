unless Agent.find_by(email: 'agent@ticketfy.io').present?
  puts 'SETTING UP A DEMO AGENT'
  user = Agent.create! name: 'Agent',
                       email: 'agent@ticketfy.io',
                       password: Rails.application.secrets[:agent][:password],
                       password_confirmation: Rails.application.secrets[:agent][:password],
                       confirmed_at: Date.current
  puts "Agent user #{user.name} (#{user.email}) created!"
end
