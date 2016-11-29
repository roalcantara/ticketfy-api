unless Ticket.any?
  puts 'SETTING UP A DEMO TICKET'
  ticket = Customer.last.tickets.create! description: 'Some problem',
                                         status: :pending
  puts "Ticket (#{ticket.to_param}) created!"
end
