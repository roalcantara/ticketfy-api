class TicketSerializer < ApplicationSerializer
  attributes :id, :status, :description
  has_one :customer
  has_one :agent
end
