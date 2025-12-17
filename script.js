const toggle = document.getElementById("mode");

// Vérifier si un mode est déjà stocké
if (localStorage.getItem("theme") === "dark") {
  document.body.classList.add("dark");
  if (toggle) toggle.textContent = "☀️ Mode clair";
}

// Écoute du clic
if (toggle) {
  toggle.addEventListener("click", () => {
    document.body.classList.toggle("dark");

    if (document.body.classList.contains("dark")) {
      localStorage.setItem("theme", "dark");
      toggle.textContent = "☀️ Mode clair";
    } else {
      localStorage.setItem("theme", "light");
      toggle.textContent = "🌙 Mode sombre";
    }
  });
}