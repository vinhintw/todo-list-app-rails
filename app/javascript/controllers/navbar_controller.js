import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "userMenu",
    "sidebar",
    "userButton",
    "mobileToggle",
    "sidebarClose",
  ];

  connect() {
    // Bind methods to preserve 'this' context
    this.handleResize = this.handleResize.bind(this);

    // Add global event listeners
    window.addEventListener("resize", this.handleResize);

    // Initial resize check
    this.handleResize();
  }

  disconnect() {
    // Cleanup - Stimulus automatically calls this
    window.removeEventListener("resize", this.handleResize);
  }

  // Toggle mobile sidebar
  toggleSidebar(event) {
    event.preventDefault();

    if (this.hasSidebarTarget) {
      this.sidebarTarget.classList.remove("-translate-x-full");
    } else {
      // Fallback - find sidebar by ID
      const sidebar = document.getElementById("sidebar");
      if (sidebar) {
        sidebar.classList.remove("-translate-x-full");
      }
    }
  }

  // Close sidebar
  closeSidebar(event) {
    if (event) event.preventDefault();
    if (this.hasSidebarTarget) {
      this.sidebarTarget.classList.add("-translate-x-full");
    }
  }

  // Toggle user menu dropdown
  toggleUserMenu(event) {
    event.preventDefault();
    event.stopPropagation();
    if (this.hasUserMenuTarget) {
      this.userMenuTarget.classList.toggle("hidden");
    }
  }

  // Close user menu
  closeUserMenu() {
    if (this.hasUserMenuTarget) {
      this.userMenuTarget.classList.add("hidden");
    }
  }

  // Handle window resize
  handleResize() {
    if (this.hasSidebarTarget) {
      if (window.innerWidth >= 1024) {
        // Desktop - show sidebar
        this.sidebarTarget.classList.remove("-translate-x-full");
      } else {
        // Mobile - hide sidebar
        this.sidebarTarget.classList.add("-translate-x-full");
      }
    }
  }

  submit() {
    this.element.submit();
  }
}
