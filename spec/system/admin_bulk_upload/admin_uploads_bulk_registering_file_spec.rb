require 'rails_helper'

describe 'Admin tries to access the page to upload a file for bulk registering', type: :system do
  it 'but first, has to be signed in' do
    create(:user, role: :admin)
    visit root_path

    expect(page).not_to have_link 'Registros em Massa'
  end

  it 'and succeeds', js: true do
    user = create(:user, role: :admin)
    login_as user
    file_reading_spy = spy('BulkRegistersFileReadingJob')
    stub_const('BulkRegistersFileReadingJob', file_reading_spy)

    visit bulk_registers_path
    click_on 'Novo Upload de Arquivo'
    attach_file('Arquivo de Registros', Rails.root.join('spec/support/files/text.txt'))
    click_on 'Criar Registro em Massa'

    expect(page).to have_content 'Upload de Arquivo de Registros feito com sucesso!'
    expect(page).to have_content 'text.txt'
    expect(page).to have_content 'Status: Pendente'
    bulk_register = BulkRegister.last
    expect(file_reading_spy).to have_received(:perform_later).with(bulk_register)
  end

  it 'and fails for informing invalid data', js: true do
    user = create(:user, role: :admin)
    login_as user

    visit bulk_registers_path
    click_on 'Novo Upload de Arquivo'
    attach_file('Arquivo de Registros', Rails.root.join('spec/support/files/logo.png'))
    click_on 'Criar Registro em Massa'

    expect(page).to have_content 'Erro ao fazer upload do Arquivo de Registros.'
  end
end
