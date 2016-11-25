require 'rails_helper'

RSpec.describe ApplicationCable::Connection do
  it 'is an ActionCable::Connection::Base' do
    expect(ApplicationCable::Connection.ancestors).to include ActionCable::Connection::Base
  end
end
