document.addEventListener("DOMContentLoaded", function () {
  if (window.TE) {
    const dropdowns = document.querySelectorAll('[data-te-dropdown-toggle]');
    dropdowns.forEach((dropdownToggleEl) => {
      window.TE.Dropdown.init(dropdownToggleEl);
    });
  }
});