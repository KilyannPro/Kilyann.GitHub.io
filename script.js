// Navigation smooth scroll
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');
        if (href !== '#' && document.querySelector(href)) {
            e.preventDefault();
        }
    });
});

// Gestion du formulaire de contact
document.getElementById('contactForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    // Récupérer les valeurs
    const inputs = this.querySelectorAll('input, textarea');
    let isValid = true;
    
    inputs.forEach(input => {
        if (!input.value.trim()) {
            input.style.borderColor = '#ef4444';
            isValid = false;
        } else {
            input.style.borderColor = '#e9d5ff';
        }
    });
    
    if (isValid) {
        // Afficher un message de succès
        const button = this.querySelector('button');
        const originalText = button.textContent;
        button.textContent = '✓ Message envoyé !';
        button.style.background = 'linear-gradient(135deg, #10b981 0%, #059669 100%)';
        
        // Réinitialiser le formulaire
        setTimeout(() => {
            this.reset();
            button.textContent = originalText;
            button.style.background = '';
            inputs.forEach(input => {
                input.style.borderColor = '';
            });
        }, 3000);
    }
});

// Animation au scroll
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

document.querySelectorAll('.project-card, .experience-item').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(20px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    observer.observe(el);
});

// Menu mobile responsive
const createMobileMenu = () => {
    const navbar = document.querySelector('.navbar');
    const navMenu = document.querySelector('.nav-menu');
    
    if (window.innerWidth <= 768) {
        if (!document.querySelector('.menu-toggle')) {
            const toggle = document.createElement('button');
            toggle.className = 'menu-toggle';
            toggle.innerHTML = '<i class="fas fa-bars"></i>';
            toggle.style.cssText = `
                display: none;
                background: none;
                border: none;
                color: white;
                font-size: 1.5rem;
                cursor: pointer;
            `;
            
            if (window.innerWidth <= 768) {
                toggle.style.display = 'block';
                navbar.querySelector('.container').appendChild(toggle);
                navMenu.style.cssText = `
                    position: absolute;
                    top: 60px;
                    right: 0;
                    background: linear-gradient(135deg, #7c3aed 0%, #5b21b6 100%);
                    flex-direction: column;
                    width: 100%;
                    text-align: center;
                    display: none;
                    padding: 1rem 0;
                `;
                
                toggle.addEventListener('click', () => {
                    navMenu.style.display = navMenu.style.display === 'flex' ? 'none' : 'flex';
                });
                
                navMenu.querySelectorAll('a').forEach(link => {
                    link.addEventListener('click', () => {
                        navMenu.style.display = 'none';
                    });
                });
            }
        }
    }
};

window.addEventListener('resize', createMobileMenu);
createMobileMenu();

// Effet parallax léger sur le hero
window.addEventListener('scroll', () => {
    const hero = document.querySelector('.hero');
    const scrollY = window.scrollY;
    
    if (scrollY < 800) {
        hero.style.backgroundPosition = `0 ${scrollY * 0.5}px`;
    }
});
