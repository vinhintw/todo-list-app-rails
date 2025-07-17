// Navbar and Sidebar functionality
document.addEventListener("DOMContentLoaded", function () {
  // Elements
  const userMenuButton = document.getElementById("user-menu-button");
  const userMenu = document.getElementById("user-menu");
  const sidebar = document.getElementById("sidebar");
  const mobileSidebarToggle = document.getElementById("mobile-sidebar-toggle");
  const sidebarClose = document.getElementById("sidebar-close");

  // Mobile sidebar toggle
  if (mobileSidebarToggle) {
    mobileSidebarToggle.addEventListener("click", function () {
      sidebar.classList.remove("-translate-x-full");
    });
  }

  // Close sidebar
  function closeSidebar() {
    sidebar.classList.add("-translate-x-full");
  }

  if (sidebarClose) {
    sidebarClose.addEventListener("click", closeSidebar);
  }

  // User menu dropdown
  if (userMenuButton && userMenu) {
    userMenuButton.addEventListener("click", function (e) {
      e.stopPropagation();
      userMenu.classList.toggle("hidden");
    });

    // Close user menu when clicking outside
    document.addEventListener("click", function (e) {
      if (
        userMenuButton &&
        userMenu &&
        !userMenuButton.contains(e.target) &&
        !userMenu.contains(e.target)
      ) {
        userMenu.classList.add("hidden");
      }

      // Close sidebar when clicking outside (only on mobile)
      if (
        window.innerWidth < 1024 &&
        sidebar &&
        !sidebar.contains(e.target) &&
        !mobileSidebarToggle.contains(e.target)
      ) {
        closeSidebar();
      }
    });
  }

  // Close sidebar on escape key
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") {
      closeSidebar();
      if (userMenu) {
        userMenu.classList.add("hidden");
      }
    }
  });

  // Handle responsive behavior
  function handleResize() {
    if (window.innerWidth >= 1024) {
      // lg breakpoint
      sidebar.classList.remove("-translate-x-full");
    } else {
      sidebar.classList.add("-translate-x-full");
    }
  }

  window.addEventListener("resize", handleResize);
  handleResize(); // Initial check
});
