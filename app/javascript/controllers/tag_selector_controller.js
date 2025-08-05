import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "dropdown", "selectedDisplay", "arrow"];

  connect() {
    this.handleOutsideClick = this.handleOutsideClick.bind(this);
    document.addEventListener("click", this.handleOutsideClick);
    this.updateDisplay();
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick);
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.closeDropdown();
    }
  }

  toggleDropdown(event) {
    event.stopPropagation();

    if (this.dropdownTarget.classList.contains("hidden")) {
      this.openDropdown();
    } else {
      this.closeDropdown();
    }
  }

  openDropdown() {
    this.dropdownTarget.classList.remove("hidden");
    this.arrowTarget.style.transform = "rotate(180deg)";
  }

  closeDropdown() {
    this.dropdownTarget.classList.add("hidden");
    this.arrowTarget.style.transform = "rotate(0deg)";
  }

  toggleTag(event) {
    event.preventDefault();
    event.stopPropagation();

    const tagOption = event.currentTarget;
    const tagId = tagOption.dataset.tagId;
    const checkbox = tagOption.querySelector(".tag-checkbox");

    if (!checkbox) return;

    checkbox.checked = !checkbox.checked;

    if (checkbox.checked) {
      this.addTag(tagId);
    } else {
      this.removeTagById(tagId);
    }

    this.updateDisplay();
    this.updateCheckboxIndicator(tagOption, checkbox.checked);
  }

  addTag(tagId) {
    const existingInput = document.querySelector(
      `.selected-tag-input[data-tag-id="${tagId}"]`
    );
    if (existingInput) return;

    const input = document.createElement("input");
    input.type = "hidden";
    input.name = "task[tag_ids][]";
    input.value = tagId;
    input.className = "selected-tag-input";
    input.dataset.tagId = tagId;

    const container = document.getElementById("selected-tags-inputs");
    if (container) {
      container.appendChild(input);
    }
  }

  removeTag(event) {
    event.preventDefault();
    event.stopPropagation();

    const tagId = event.currentTarget.dataset.tagId;
    this.removeTagById(tagId);
    this.updateDisplay();

    // Update checkbox in dropdown
    const checkbox = this.element.querySelector(
      `.tag-checkbox[data-tag-id="${tagId}"]`
    );
    if (checkbox) {
      checkbox.checked = false;
      const tagOption = checkbox.closest(".tag-option");
      this.updateCheckboxIndicator(tagOption, false);
    }
  }

  removeTagById(tagId) {
    const input = document.querySelector(
      `.selected-tag-input[data-tag-id="${tagId}"]`
    );
    if (input) {
      input.remove();
    }

    const checkbox = this.element.querySelector(
      `.tag-checkbox[data-tag-id="${tagId}"]`
    );
    if (checkbox) {
      checkbox.checked = false;
    }
  }

  updateDisplay() {
    const selectedInputs = document.querySelectorAll(".selected-tag-input");
    const displayContainer = this.selectedDisplayTarget;

    displayContainer.innerHTML = "";

    selectedInputs.forEach((input) => {
      const tagId = input.dataset.tagId;
      const tagOption = this.element.querySelector(
        `.tag-option[data-tag-id="${tagId}"]`
      );
      const tagName = tagOption ? tagOption.dataset.tagName : `Tag ${tagId}`;

      const tagElement = document.createElement("span");
      tagElement.innerHTML = this.createTagBadgeHTML(tagId, tagName);
      displayContainer.appendChild(tagElement.firstElementChild);
    });
  }

  updateCheckboxIndicator(tagOption, isChecked) {
    const indicator = tagOption.querySelector(".check-icon");

    if (isChecked && !indicator) {
      const checkIcon = document.createElement("svg");
      checkIcon.className = "w-4 h-4 text-blue-600 ml-2 check-icon";
      checkIcon.setAttribute("fill", "none");
      checkIcon.setAttribute("stroke", "currentColor");
      checkIcon.setAttribute("viewBox", "0 0 24 24");
      checkIcon.innerHTML =
        '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>';

      tagOption.querySelector(".flex").appendChild(checkIcon);
    } else if (!isChecked && indicator) {
      indicator.remove();
    }
  }

  createTagBadgeHTML(tagId, tagName) {
    const escapedName = this.escapeHtml(tagName);
    return `
      <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800 border border-blue-200 transition-colors duration-150 hover:bg-blue-200" data-tag-id="${tagId}">
        <span>${escapedName}</span>
        <button type="button" 
                class="ml-1.5 inline-flex items-center justify-center w-3.5 h-3.5 rounded-full text-blue-600 hover:bg-blue-300 hover:text-blue-800 focus:outline-none transition-colors duration-150" 
                data-action="click->tag-selector#removeTag" 
                data-tag-id="${tagId}">
          <svg class="w-2.5 h-2.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </span>
    `;
  }

  escapeHtml(text) {
    const map = {
      "&": "&amp;",
      "<": "&lt;",
      ">": "&gt;",
      '"': "&quot;",
      "'": "&#039;",
    };
    return text.replace(/[&<>"']/g, (m) => map[m]);
  }
}
