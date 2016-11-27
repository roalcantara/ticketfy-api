unless Admin.find_by(email: "admin@ticketfy.io").present?
  puts "SETTING UP DEFAULT ADMIN"
  user = Admin.create! name: "Admin",
                       email: "admin@ticketfy.io",
                       password: Rails.application.secrets[:admin][:password],
                       password_confirmation: Rails.application.secrets[:admin][:password]
  puts "Admin user #{user.name} (#{user.email}) created!"
end
