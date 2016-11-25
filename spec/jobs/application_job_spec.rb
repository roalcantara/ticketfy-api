require 'rails_helper'

RSpec.describe ApplicationJob do
  it 'is a ActiveJob::Base' do
    expect(ApplicationJob.ancestors).to include ActiveJob::Base
  end
end
