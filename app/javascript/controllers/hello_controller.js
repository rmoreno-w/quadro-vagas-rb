import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['ul'];

  addListItem() {
    const newItem = document.createElement('li');
    newItem.textContent = 'Nova Vaga com stimullus';
    newItem.classList.add('bg-[#1b1826]', 'p-4', 'flex', 'flex-col');

    // Adiciona o novo item à lista
    this.ulTarget.appendChild(newItem);
    console.log(this.ulTarget);
  }
}
