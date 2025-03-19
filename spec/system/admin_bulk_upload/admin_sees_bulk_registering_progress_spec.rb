require 'rails_helper'

describe 'Admin tries to access the page to see the progress of a bulk registering process', type: :system do
  it 'but first, has to be signed in' do
    user = create(:user, role: :admin)
    bulk_register = create(:bulk_register, user: user)

    visit bulk_registers_path(bulk_register)

    expect(page).not_to have_content 'Progresso'
  end

  it 'and succeeds', js: true do
    user = create(:user, role: :admin)
    bulk_register = create(:bulk_register, user: user)
    login_as user

    visit bulk_register_path(bulk_register)

    expect(page).to have_content('Status: Pendente')
    expect(page).to have_content('Número de linhas processadas: 0')
    expect(page).to have_content('Número de linhas processadas com Sucesso: 0')
    expect(page).to have_content('Número de linhas processadas com Erro: 0')
  end
end
