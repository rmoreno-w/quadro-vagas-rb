require 'rails_helper'

describe 'Usuario tenta carregar um novo anuncio' do
  it 'e consegue com sucesso', js: true  do
    visit root_path

    click_on 'Adicionar'

    expect(page).to have_selector "li", count: 3
  end
end
