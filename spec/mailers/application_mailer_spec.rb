require 'rails_helper'

RSpec.describe ApplicationMailer do
  it 'is a ActionMailer::Base' do
    expect(ApplicationMailer.ancestors).to include ActionMailer::Base
  end
end
