// Mode Sombre/Clair
const themeToggle = document.getElementById('themeToggle');
const body = document.body;

// Charger le thème sauvegardé
const savedTheme = localStorage.getItem('theme');
if (savedTheme === 'dark') {
    body.classList.add('dark-mode');
    updateThemeIcon();
}

// Toggle mode sombre
themeToggle.addEventListener('click', () => {
    body.classList.toggle('dark-mode');
    const isDarkMode = body.classList.contains('dark-mode');
    localStorage.setItem('theme', isDarkMode ? 'dark' : 'light');
    updateThemeIcon();
});

function updateThemeIcon() {
    const icon = themeToggle.querySelector('i');
    if (body.classList.contains('dark-mode')) {
        icon.classList.remove('fa-moon');
        icon.classList.add('fa-sun');
    } else {
        icon.classList.remove('fa-sun');
        icon.classList.add('fa-moon');
    }
}

// Menu Mobile
const menuToggle = document.getElementById('menuToggle');
const navMenu = document.getElementById('navMenu');

if (menuToggle) {
    menuToggle.addEventListener('click', () => {
        navMenu.classList.toggle('active');
    });

    // Fermer le menu au clic sur un lien
    navMenu.querySelectorAll('a').forEach(link => {
        link.addEventListener('click', () => {
            navMenu.classList.remove('active');
        });
    });

    // Fermer le menu au clic en dehors
    document.addEventListener('click', (e) => {
        if (!e.target.closest('.navbar')) {
            navMenu.classList.remove('active');
        }
    });
}

// Activer le lien de navigation actuel
function updateActiveNavLink() {
    const currentPage = window.location.pathname.split('/').pop() || 'index.html';
    
    document.querySelectorAll('.nav-link').forEach(link => {
        link.classList.remove('active');
        const href = link.getAttribute('href');
        if (href === currentPage || (currentPage === '' && href === 'index.html')) {
            link.classList.add('active');
        }
    });
}

updateActiveNavLink();

// Gestion du formulaire de contact
const contactForm = document.getElementById('contactForm');

if (contactForm) {
    contactForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const inputs = this.querySelectorAll('input, textarea');
        let isValid = true;
        
        inputs.forEach(input => {
            if (!input.value.trim()) {
                input.style.borderColor = '#ef4444';
                isValid = false;
            } else {
                input.style.borderColor = '';
            }
        });
        
        if (isValid) {
            const button = this.querySelector('button');
            const originalText = button.innerHTML;
            button.innerHTML = '<span class="btn-text">Envoi en cours...</span>';
            button.disabled = true;
            
            // Envoyer à Formspree en POST standard
            const formData = new FormData(this);
            
            fetch(this.action, {
                method: 'POST',
                headers: {
                    'Accept': 'application/json'
                },
                body: formData
            })
            .then(response => {
                console.log('Réponse Formspree:', response.status);
                if (response.ok || response.status === 200) {
                    button.innerHTML = '<span class="btn-text">✓ Message envoyé avec succès !</span>';
                    button.style.background = 'linear-gradient(135deg, #10b981 0%, #059669 100%)';
                    
                    setTimeout(() => {
                        contactForm.reset();
                        button.innerHTML = originalText;
                        button.style.background = '';
                        button.disabled = false;
                        inputs.forEach(input => {
                            input.style.borderColor = '';
                        });
                    }, 3000);
                } else {
                    console.error('Erreur serveur:', response.status);
                    throw new Error('Erreur serveur ' + response.status);
                }
            })
            .catch(error => {
                console.error('Erreur Formspree:', error);
                button.innerHTML = '<span class="btn-text">✗ Erreur d\'envoi</span>';
                button.style.background = 'linear-gradient(135deg, #ef4444 0%, #dc2626 100%)';
                button.disabled = false;
                
                setTimeout(() => {
                    button.innerHTML = originalText;
                    button.style.background = '';
                }, 3000);
            });
        }
    });
}

// Animations au scroll
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -100px 0px'
};

const observer = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observer pour les cartes
document.querySelectorAll('.skill-card, .project-card, .preview-card, .experience-item').forEach(el => {
    if (!el.style.opacity) {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    }
});

// Animation des barres de progression
function animateProgressBars() {
    const progressBars = document.querySelectorAll('.progress-bar');
    progressBars.forEach(bar => {
        const width = bar.style.width;
        bar.style.width = '0';
        setTimeout(() => {
            bar.style.transition = 'width 1.5s ease-out';
            bar.style.width = width;
        }, 100);
    });
}

// Appeler l'animation au chargement
if (document.querySelectorAll('.progress-bar').length > 0) {
    animateProgressBars();
}

// Smooth scroll navigation
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');
        if (href !== '#' && document.querySelector(href)) {
            e.preventDefault();
            const target = document.querySelector(href);
            const offset = 80;
            const targetPosition = target.offsetTop - offset;
            window.scrollTo({
                top: targetPosition,
                behavior: 'smooth'
            });
        }
    });
});

// Validation du formulaire en temps réel
document.querySelectorAll('.form-group input, .form-group textarea').forEach(input => {
    input.addEventListener('focus', () => {
        input.style.borderColor = 'var(--color-primary)';
    });
    
    input.addEventListener('blur', () => {
        if (!input.value.trim()) {
            input.style.borderColor = 'var(--color-border)';
        }
    });
});

// Page transition animation
window.addEventListener('load', () => {
    document.body.style.opacity = '0';
    setTimeout(() => {
        document.body.style.transition = 'opacity 0.5s ease-in';
        document.body.style.opacity = '1';
    }, 100);
});

// Effet de soulignement au survol des cartes
document.querySelectorAll('.preview-card, .project-card, .skill-card').forEach(card => {
    card.addEventListener('mouseenter', function() {
        this.style.transform = this.style.transform ? this.style.transform.replace(/translateY\([^)]*\)/, 'translateY(-10px)') : 'translateY(-10px)';
    });
    
    card.addEventListener('mouseleave', function() {
        this.style.transform = 'translateY(0)';
    });
});