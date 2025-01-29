import Combobox from '@github/combobox-nav';
import debounce from './debounce.js';
import { LitElement, html, css } from 'lit';

export class AutocompleteInputElement extends LitElement {
  static formAssociated = true;

  static properties = {
    value: {},
    name: {},
    displayValue: {
      type: String,
      attribute: 'display-value',
    },
    items: { type: Array },
    debounce: { type: Number },
    minlength: { type: Number },
    searchValue: { attribute: 'search-value' },
    clearListOnSelect: { attribute: 'clear-list-on-select', type: Boolean },
    open: { type: Boolean, state: true },
  }

  constructor() {
    super();
    this.searchValue = '';
    this.displayValue = 'Choose an organization';
    this.debounce = 300;
    this.minlength = 3;
    this.items = [];
    this.elementInternals = this.attachInternals();
    this.addEventListener('focusout', (e) => {
      console.log(e);
    });
  }

  cancel() {
    this.open = false;
    // setTimeout(() => this.dispatchEvent(new CustomEvent('autocomplete-close', { detail: { query: this.searchInput?.value } })));
  }

  startSearch() {
    this.open = true;
    console.log(`In open, this.open: ${this.open}`);
  }

  hasState(state) {
    return this.elementInternals && this.elementInternals.states.has(state);
  }

  updated() {
    if (this.open && !this.hasState('open')) {
      this.elementInternals.states.add('open');
    }
    if (this.elementInternals.form && this.value) {
      this.elementInternals.setFormValue(this.value, this.searchValue);
    }
    if (this.open) {
      this.searchInput.focus();
    }
    this.initializeComboBox();
  }

  render() {
    console.log(`In render, this.open: ${this.open}`);
    return this.open ? html`
      <input name="${this.name}" .value="${this.searchValue}" @keydown=${this.onKeyDown} part="input" autocomplete="off" @input=${debounce((e) => this.onSearch(e), this.debounce)}>
      <button @click=${this.cancel}>Cancel</button>
      <ul part="list">
        ${this.items.map((item) => html`<li role="option" part="option" data-value="${item.id}">${item.name}</li>`)}
      </ul>
    ` : html`
      <span @click=${this.startSearch}>${this.displayValue}</span>
    `;
  }

  onKeyDown(e) {
    if (e.key == 'Escape') {
      this.cancel();
      e.stopPropagation();
    }
    console.log(e);
  }

  onSearch(e) {
    if (this.searchInput.value.length >= this.minlength) {
      this.elementInternals.states.add('searching');
      this.dispatchEvent(
        new CustomEvent('autocomplete-search', { detail: { query: this.searchInput.value } }));
    }
  }

  onCommit({ target }) {
    this.open = false;
    this.displayValue = target.dataset.label ? target.dataset.label : target.innerText;
    this.value = target.dataset.value;
    if (this.elementInternals.form) {
      this.elementInternals.setFormValue(target.dataset.value);
      new FormData(this.elementInternals.form).forEach(console.debug);
    }
    if (this.clearListOnSelect) {
      this.list.replaceChildren();
    }
    this.dispatchEvent(new CustomEvent('autocomplete-commit', { detail: target.dataset, bubbles: true }));
  }

  get list() {
    return this.shadowRoot.querySelector('ul');
  }

  get listSlot() {
    return this.shadowRoot.querySelector('slot[name="list"]');
  }

  initializeComboBox() {
    if (this.searchInput && this.list && (!this.combobox || this.combobox.list !== this.list)) {
      this.combobox = new Combobox(this.searchInput, this.list)
      // when options appear, start intercepting keyboard events for navigation
      this.combobox.start();
      this.list.addEventListener('combobox-commit', (e) => this.onCommit(e));
      this.list.addEventListener('combobox-select', (e) => {
        this.list.querySelectorAll('li').forEach((li) => li.setAttribute('part', 'option'));
        e.target.setAttribute('part', 'selected-option');
      });
    }
  }

  disconnectedCallback() {
    this.combobox && this.combobox.stop();
  }

  get searchInput() {
    return this.shadowRoot.querySelector('input');
  }
}

customElements.define('autocomplete-input', AutocompleteInputElement)