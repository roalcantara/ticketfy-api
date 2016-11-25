require 'rails_helper'

RSpec.describe ApplicationRecord do
  it 'is a ActiveRecord::Base' do
    expect(ApplicationRecord.ancestors).to include ActiveRecord::Base
  end
end
