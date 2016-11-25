require 'rails_helper'

RSpec.describe ApplicationCable::Channel do
  it 'is a ActionCable::Channel::Base' do
    expect(ApplicationCable::Channel.ancestors).to include ActionCable::Channel::Base
  end
end
