// Navbar functionality
document.addEventListener("DOMContentLoaded", function () {
  // Elements
  const userMenuButton = document.getElementById("user-menu-button");
  const userMenu = document.getElementById("user-menu");

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
    });
  }
});
