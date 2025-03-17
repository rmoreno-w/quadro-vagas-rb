require 'rails_helper'

describe 'User tries to get the bulk registers page', type: :request do
  it 'and fails for being unauthenticated' do
    create(:user)

    get(bulk_registers_path)

    expect(response).to redirect_to new_session_path
    expect(response.status).to eq 302
  end

  it 'and fails for not being an admin' do
    user = create(:user)
    login_as user

    get(bulk_registers_path)

    expect(response).to redirect_to root_path
    expect(response.status).to eq 302
  end
end
