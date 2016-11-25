require 'rails_helper'

RSpec.describe ApplicationController do
  it 'is an ActionController::API' do
    expect(ApplicationController.ancestors).to include ActionController::API
  end
end
