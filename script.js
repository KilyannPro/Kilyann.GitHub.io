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

// Gestion des langues
const langToggle = document.getElementById('langToggle');
const translations = {
    'fr': {
        'nav-home': 'Accueil',
        'nav-skills': 'Compétences',
        'nav-projects': 'Projets',
        'nav-alternance': 'Alternance',
        'nav-games': 'Mini-jeux',
        'nav-contact': 'Contact',
        'hero-greeting': '👋 Bienvenue',
        'hero-subtitle': 'Alternant Développement Web & Réseaux',
        'hero-desc': 'Créateur de solutions web modernes et performantes. Passionné par les technologies actuelles et les défis techniques.',
        'btn-contact': 'Me contacter',
        'btn-projects': 'Voir mes projets',
        'download-cv': 'Télécharger mon CV',
        'cover-letter': 'Lettre de motivation',
        'stat-years': 'Années de formation',
        'stat-projects': 'Projets réalisés',
        'stat-skills': 'Compétences',
        'preview-title': 'Explorez Mon Portfolio',
        'preview-skills-desc': 'Découvrez mes technologies et domaines d\'expertise',
        'preview-projects-desc': 'Les projets que j\'ai développés et leurs détails',
        'preview-alternance-desc': 'Mon parcours académique et professionnel',
        'preview-contact-desc': 'Discutons d\'une collaboration ou opportunité',
        'qualities-title': 'Qualités Professionnelles',
        'quality-motivation': 'Motivation',
        'quality-autonomy': 'Autonomie',
        'quality-team': 'Esprit d\'équipe',
        'quality-creativity': 'Créativité',
        'quality-rigor': 'Rigueur',
        'quality-adaptability': 'Adaptabilité',
        'footer-about': 'À propos',
        'footer-about-desc': 'Alternant passionné par le développement web et les technologies modernes.',
        'footer-nav': 'Navigation',
        'footer-socials': 'Réseaux',
        'footer-rights': 'Tous droits réservés.',
        'games-title': 'Mes Mini-jeux',
        'games-subtitle': 'Une façon ludique de découvrir mon univers et mes compétences',
        'game-mission-desc': 'Aidez-moi à décrocher mon alternance dans ce jeu d\'arcade ! Explorez mon parcours tout en évitant les obstacles et en collectant des bonus d\'expérience.',
        'btn-play': 'Jouer maintenant',
        'contact-title': 'Contactez-moi',
        'contact-subtitle': 'Un projet ? Une opportunité ? N\'hésitez pas à laisser un message !',
        'form-name': 'Nom complet',
        'form-email': 'Adresse Email',
        'form-subject': 'Sujet',
        'form-message': 'Votre message',
        'btn-send': 'Envoyer le message',
        'sending': 'Envoi en cours...',
        'send-success': '✓ Message envoyé avec succès !',
        'send-error': '✗ Erreur d\'envoi',
        'projects-title': 'Mes Projets',
        'projects-subtitle': 'Projets de stage en motion design, mock-up et tracking',
        'filter-all': 'Tous',
        'filter-motion': 'Motion & Vidéo',
        'filter-design': 'Design & Print',
        'filter-web': 'Web',
        'filter-com': 'Communication',
        'view-project': 'Voir le projet',
        'download-file': 'Télécharger',
        'view-site': 'Voir le site',
        'cta-title': 'Envie d\'un projet similaire ?',
        'cta-desc': 'Parlons de votre idée et transformons-la en réalité',
        'btn-skills': 'Voir mes compétences',
        'btn-start-project': 'Démarrer un projet',
        'skills-title': 'Compétences Techniques',
        'skills-subtitle': 'Découvrez mes domaines d\'expertise et technologies',
        'skill-web': 'Développement Web',
        'skill-web-desc': 'Création de sites web modernes et responsifs',
        'skill-db': 'Bases de Données',
        'skill-db-desc': 'Conception et gestion de données relationnelles',
        'skill-net': 'Réseaux & Systèmes',
        'skill-net-desc': 'Architecture réseau et administration système',
        'skill-ui': 'Design & UX/UI',
        'skill-ui-desc': 'Conception d\'interfaces utilisateur intuitives',
        'skill-lang': 'Langages',
        'skill-lang-desc': 'Programmation multi-langages et versatile',
        'skill-media': 'Multimédia',
        'skill-media-desc': 'Production vidéo et design graphique',
        'cta-skills-title': 'Intéressé par un projet ensemble ?',
        'cta-skills-desc': 'Explorez mes projets ou contactez-moi pour discuter',
        'exp-title': 'Parcours & Expérience',
        'exp-subtitle': 'Mon évolution académique et professionnelle',
        'exp1-title': 'Alternant Développement Web & Réseaux',
        'exp1-company': 'L\'ETNA',
        'exp1-desc': 'Alternance en cycle 3 semaines entreprise / 1 jour école. Acquisition de compétences solides en programmation, architecture réseau et gestion de bases de données. Amélioration et refonte du site élève.',
        'exp1-h1': 'Entreprise immersive',
        'exp1-h2': '3 semaines/1 jour',
        'exp1-h3': 'Expérience actuelle',
        'exp2-title': 'Stage - IUT MMI',
        'exp2-company': 'Treize cent treize',
        'exp2-desc': 'Stage de première année MMI (1 mois). Création de site vitrine pour artiste. Apprentissage des bonnes pratiques en web design et développement frontend.',
        'exp2-h1': '1 mois de stage',
        'exp2-h2': 'Web design',
        'exp2-h3': 'Site vitrine',
        'exp3-title': 'Formation - IUT MMI',
        'exp3-company': 'IUT Champs-sur-Marne (Parcours Développement Web)',
        'exp3-desc': '2 ans de formation en Métiers du Multimédia et de l\'Internet. Apprentissage en programmation Web, architecture réseau, gestion de bases de données et web marketing.',
        'exp3-h1': '2 années',
        'exp3-h2': 'Développement Web',
        'exp3-h3': 'Graduation réussie',
        'exp4-title': 'Bac STI2D',
        'exp4-company': 'Lycée',
        'exp4-desc': 'Baccalauréat Sciences Technologiques de l\'Industrie et du Développement Durable. Découverte de la programmation et infrastructure réseau. Projets pratiques en systèmes et électronique.',
        'exp4-h1': '2 années',
        'exp4-h2': 'STI2D',
        'exp4-h3': 'Bac obtenu',
        'cta-exp-title': 'Impressionné par mon parcours ?',
        'cta-exp-desc': 'Découvrez mes compétences ou contactez-moi pour une collaboration'
    },
    'en': {
        'nav-home': 'Home',
        'nav-skills': 'Skills',
        'nav-projects': 'Projects',
        'nav-alternance': 'Apprenticeship',
        'nav-games': 'Mini-games',
        'nav-contact': 'Contact',
        'hero-greeting': '👋 Welcome',
        'hero-subtitle': 'Fullstack Web & Network Apprentice',
        'hero-desc': 'Creator of modern and high-performance web solutions. Passionate about current technologies and technical challenges.',
        'btn-contact': 'Contact me',
        'btn-projects': 'View my projects',
        'download-cv': 'Download my CV',
        'cover-letter': 'Cover letter',
        'stat-years': 'Years of training',
        'stat-projects': 'Projects completed',
        'stat-skills': 'Skills',
        'preview-title': 'Explore My Portfolio',
        'preview-skills-desc': 'Discover my technologies and areas of expertise',
        'preview-projects-desc': 'The projects I\'ve developed and their details',
        'preview-alternance-desc': 'My academic and professional journey',
        'preview-contact-desc': 'Let\'s discuss a collaboration or opportunity',
        'qualities-title': 'Professional Qualities',
        'quality-motivation': 'Motivation',
        'quality-autonomy': 'Autonomy',
        'quality-team': 'Team Spirit',
        'quality-creativity': 'Creativity',
        'quality-rigor': 'Rigor',
        'quality-adaptability': 'Adaptability',
        'footer-about': 'About',
        'footer-about-desc': 'Apprentice passionate about web development and modern technologies.',
        'footer-nav': 'Navigation',
        'footer-socials': 'Networks',
        'footer-rights': 'All rights reserved.',
        'games-title': 'My Mini-games',
        'games-subtitle': 'A fun way to discover my world and skills',
        'game-mission-desc': 'Help me land my apprenticeship in this arcade game! Explore my journey while avoiding obstacles and collecting experience bonuses.',
        'btn-play': 'Play now',
        'contact-title': 'Contact me',
        'contact-subtitle': 'A project? An opportunity? Feel free to leave a message!',
        'form-name': 'Full name',
        'form-email': 'Email Address',
        'form-subject': 'Subject',
        'form-message': 'Your message',
        'btn-send': 'Send message',
        'sending': 'Sending...',
        'send-success': '✓ Message sent successfully!',
        'send-error': '✗ Sending error',
        'projects-title': 'My Projects',
        'projects-subtitle': 'Internship projects in motion design, mock-up and tracking',
        'filter-all': 'All',
        'filter-motion': 'Motion & Video',
        'filter-design': 'Design & Print',
        'filter-web': 'Web',
        'filter-com': 'Communication',
        'view-project': 'View project',
        'download-file': 'Download',
        'view-site': 'View site',
        'cta-title': 'Want a similar project?',
        'cta-desc': 'Let\'s talk about your idea and turn it into reality',
        'btn-skills': 'See my skills',
        'btn-start-project': 'Start a project',
        'skills-title': 'Technical Skills',
        'skills-subtitle': 'Discover my areas of expertise and technologies',
        'skill-web': 'Web Development',
        'skill-web-desc': 'Creation of modern and responsive websites',
        'skill-db': 'Databases',
        'skill-db-desc': 'Design and management of relational data',
        'skill-net': 'Networks & Systems',
        'skill-net-desc': 'Network architecture and system administration',
        'skill-ui': 'Design & UX/UI',
        'skill-ui-desc': 'Design of intuitive user interfaces',
        'skill-lang': 'Languages',
        'skill-lang-desc': 'Multi-language and versatile programming',
        'skill-media': 'Multimedia',
        'skill-media-desc': 'Video production and graphic design',
        'cta-skills-title': 'Interested in a project together?',
        'cta-skills-desc': 'Explore my projects or contact me to discuss',
        'exp-title': 'Journey & Experience',
        'exp-subtitle': 'My academic and professional evolution',
        'exp1-title': 'Web & Network Development Apprentice',
        'exp1-company': 'L\'ETNA',
        'exp1-desc': 'Apprenticeship with a 3-week company / 1-day school cycle. Acquisition of solid skills in programming, network architecture, and database management. Improvement and redesign of the student site.',
        'exp1-h1': 'Immersive company',
        'exp1-h2': '3 weeks/1 day',
        'exp1-h3': 'Current experience',
        'exp2-title': 'Internship - IUT MMI',
        'exp2-company': 'Treize cent treize',
        'exp2-desc': 'First-year MMI internship (1 month). Creation of a showcase site for an artist. Learning best practices in web design and frontend development.',
        'exp2-h1': '1-month internship',
        'exp2-h2': 'Web design',
        'exp2-h3': 'Showcase site',
        'exp3-title': 'Education - IUT MMI',
        'exp3-company': 'IUT Champs-sur-Marne (Web Development Track)',
        'exp3-desc': '2 years of training in Multimedia and Internet Careers. Learning in Web programming, network architecture, database management, and web marketing.',
        'exp3-h1': '2 years',
        'exp3-h2': 'Web Development',
        'exp3-h3': 'Successful graduation',
        'exp4-title': 'Bac STI2D',
        'exp4-company': 'High School',
        'exp4-desc': 'Technological Baccalaureate in Industry and Sustainable Development. Discovery of programming and network infrastructure. Practical projects in systems and electronics.',
        'exp4-h1': '2 years',
        'exp4-h2': 'STI2D',
        'exp4-h3': 'Baccalaureate obtained',
        'cta-exp-title': 'Impressed by my journey?',
        'cta-exp-desc': 'Discover my skills or contact me for a collaboration'
    }
};

let currentLang = localStorage.getItem('language') || 'fr';
const langMenu = document.getElementById('langMenu');

function setLanguage(lang) {
    document.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.getAttribute('data-i18n');
        if (translations[lang] && translations[lang][key]) {
            if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
                el.placeholder = translations[lang][key];
            } else {
                el.innerHTML = translations[lang][key];
            }
        }
    });

    // Update toggle button text to current language
    if (langToggle) {
        langToggle.textContent = lang.toUpperCase();
    }

    document.documentElement.lang = lang;
    currentLang = lang;
    localStorage.setItem('language', lang);
}

// Toggle language dropdown
if (langToggle && langMenu) {
    langToggle.addEventListener('click', (e) => {
        e.stopPropagation();
        langMenu.classList.toggle('show');
    });

    // Select language from dropdown
    document.querySelectorAll('.lang-option').forEach(option => {
        option.addEventListener('click', (e) => {
            e.preventDefault();
            const lang = option.getAttribute('data-lang');
            setLanguage(lang);
            langMenu.classList.remove('show');
        });
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        if (!langToggle.contains(e.target) && !langMenu.contains(e.target)) {
            langMenu.classList.remove('show');
        }
    });
}

// Initialiser la langue au chargement
window.addEventListener('DOMContentLoaded', () => {
    setLanguage(currentLang);
});


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
    contactForm.addEventListener('submit', function (e) {
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

const observer = new IntersectionObserver(function (entries) {
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

    // Filtre projets (page Projets)
    const filterBtns = document.querySelectorAll('.projects-filter .filter-btn');
    const projectCards = document.querySelectorAll('.projects-grid .project-card');
    if (filterBtns.length && projectCards.length) {
        filterBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const category = btn.getAttribute('data-filter');
                filterBtns.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                projectCards.forEach(card => {
                    const match = category === 'all' || card.getAttribute('data-category') === category;
                    card.style.display = match ? 'flex' : 'none';
                });
            });
        });
    }
});

/* ... existing code ... */

// Modal/Lightbox Logic
const modal = document.getElementById('projectModal');
const modalBody = document.getElementById('modalBody');
const modalClose = document.getElementById('modalClose');
const modalCaption = document.getElementById('modalCaption');

if (modal) { // Only run if modal exists
    function openModal(type, source, captionText) {
        modal.display = 'flex'; // Use flex to center
        // Small timeout to allow display:flex to apply before adding active class for opacity transition
        modal.style.display = 'flex';
        setTimeout(() => {
            modal.classList.add('active');
        }, 10);

        modalBody.innerHTML = ''; // Clear previous content
        modalCaption.textContent = captionText || '';

        if (type === 'video') {
            const video = document.createElement('video');
            video.src = source;
            video.controls = true;
            video.autoplay = true;
            video.className = 'modal-content';
            modalBody.appendChild(video);
        } else if (type === 'image') {
            const img = document.createElement('img');
            img.src = source;
            img.className = 'modal-content';
            img.alt = captionText;
            modalBody.appendChild(img);
        }
    }

    function closeModal() {
        modal.classList.remove('active');
        setTimeout(() => {
            modal.style.display = 'none';
            modalBody.innerHTML = ''; // Stop video playback
        }, 300);
    }

    modalClose.addEventListener('click', closeModal);

    // Close on click outside
    modal.addEventListener('click', (e) => {
        if (e.target === modal || e.target.classList.contains('modal-content-wrapper')) {
            closeModal();
        }
    });

    // Close on Escape key
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && modal.classList.contains('active')) {
            closeModal();
        }
    });

    // Attach event listeners to buttons
    document.querySelectorAll('.view-project-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            const type = btn.dataset.type;
            const source = btn.dataset.source;
            const caption = btn.dataset.caption;
            openModal(type, source, caption);
        });
    });
}