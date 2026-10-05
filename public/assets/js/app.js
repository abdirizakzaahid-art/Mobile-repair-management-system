(() => {
  const sidebar = document.getElementById('sidebar');
  const toggle = document.getElementById('sidebarToggle');
  const backdrop = document.getElementById('sidebarBackdrop');
  const panel = document.getElementById('mainPanel');
  const mobile = () => window.innerWidth < 992;
  const closeMobile = () => {
    sidebar?.classList.remove('show');
    backdrop?.classList.remove('show');
  };

  toggle?.addEventListener('click', () => {
    if (mobile()) {
      sidebar?.classList.remove('collapsed');
      sidebar?.classList.toggle('show');
      backdrop?.classList.toggle('show');
      return;
    }
    sidebar?.classList.toggle('collapsed');
    panel?.classList.toggle('expanded');
  });

  backdrop?.addEventListener('click', closeMobile);
  document.querySelectorAll('.sidebar-nav a').forEach(link => link.addEventListener('click', () => {
    if (mobile()) closeMobile();
  }));
  window.addEventListener('resize', () => {
    if (!mobile()) closeMobile();
  });
  document.querySelectorAll('[data-confirm]').forEach(element => element.addEventListener('click', event => {
    if (!window.confirm(element.dataset.confirm || 'Are you sure?')) event.preventDefault();
  }));
  window.setTimeout(() => document.querySelectorAll('.alert-dismissible').forEach(element => {
    bootstrap.Alert.getOrCreateInstance(element).close();
  }), 6000);
})();
