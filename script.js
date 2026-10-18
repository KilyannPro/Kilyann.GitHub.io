// ==========================================================================
// Portfolio Kilyann Boucly — v2
// ==========================================================================

const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

// --------------------------------------------------------------------------
// Traductions
// --------------------------------------------------------------------------
const translations = {
    'fr': {
        // Navigation & commun
        'nav-home': 'Accueil',
        'nav-skills': 'Compétences',
        'nav-projects': 'Projets',
        'nav-alternance': 'Parcours',
        'nav-games': 'Mini-jeux',
        'nav-contact': 'Contact',
        'nav-cta': 'Discutons',
        'download-cv': 'Télécharger mon CV',
        'btn-contact': 'Me contacter',
        'btn-projects': 'Voir mes projets',
        'btn-skills': 'Voir mes compétences',
        'footer-about-desc': 'Étudiant en BTS CIEL à l\'UTEC et alternant chez Cap RATP. Passionné d\'informatique, de réseaux et de cybersécurité.',
        'footer-nav': 'Navigation',
        'footer-socials': 'Réseaux',
        'footer-rights': 'Tous droits réservés.',
        'footer-made': 'Conçu et codé en Seine-et-Marne',

        // Accueil
        'hero-status': 'En alternance chez Cap RATP · BTS CIEL',
        'hero-hello': 'Salut, moi c\'est',
        'hero-desc': 'Étudiant en <strong>BTS CIEL</strong> (1<sup>re</sup> année) au CFA UTEC d\'Emerainville et alternant chez <strong>Cap RATP</strong>. Passionné d\'informatique, je me forme aux réseaux, à la cybersécurité et au développement web.',
        'stat-years': 'Années de formation',
        'stat-projects': 'Projets réalisés',
        'stat-skills': 'Compétences',
        'chip-job': 'Alternance',
        'chip-school': '1re année · UTEC',
        'chip-web': 'Cybersécurité',
        'chip-web-sub': 'Réseaux · Systèmes',
        'now-eyebrow': 'En ce moment',
        'now-title': 'Mon alternance',
        'now-sub': 'Depuis septembre 2026, je partage mon temps entre la formation au CFA et la pratique en entreprise.',
        'now-school-tag': 'Formation',
        'now-school-role': 'Cybersécurité, Informatique et réseaux, Électronique — 1<sup>re</sup> année sur 2',
        'now-company-tag': 'Entreprise',
        'now-company-role': 'Alternant — en parallèle du BTS CIEL',
        'now-since': 'Depuis sept. 2026',
        'preview-eyebrow': 'Explorer',
        'preview-title': 'Plongez dans mon univers',
        'preview-projects-desc': 'Web, design, vidéo, communication : une sélection de travaux réalisés en formation et en stage.',
        'preview-skills-desc': 'Mes technologies et domaines d\'expertise.',
        'preview-games-desc': 'Découvrez mon profil en jouant à Pac-Profil, mon Pac-Man maison.',
        'preview-alternance-desc': 'Du Bac STI2D à l\'alternance chez Cap RATP.',
        'preview-contact-desc': 'Une question, un projet, une opportunité ? Écrivez-moi, je réponds vite.',
        'quality-motivation': 'Motivation',
        'quality-autonomy': 'Autonomie',
        'quality-team': 'Esprit d\'équipe',
        'quality-creativity': 'Créativité',
        'quality-rigor': 'Rigueur',
        'quality-adaptability': 'Adaptabilité',
        'cta-home-title': 'Envie d\'en savoir plus ?',
        'cta-home-desc': 'Téléchargez mon CV ou envoyez-moi un message, je serai ravi d\'échanger.',

        // Compétences
        'skills-eyebrow': 'Compétences',
        'skills-title': 'Ce que je sais <span class="gradient-text">faire</span>',
        'skills-subtitle': 'Du code aux réseaux en passant par le design : les domaines dans lesquels je progresse chaque jour, en formation comme en entreprise.',
        'skill-web': 'Développement Web',
        'skill-web-desc': 'Création de sites web modernes et responsifs.',
        'skill-db': 'Bases de Données',
        'skill-db-desc': 'Conception et gestion de données relationnelles.',
        'skill-net': 'Réseaux & Cybersécurité',
        'skill-net-desc': 'Architecture réseau, administration système et sécurité, approfondies en BTS CIEL.',
        'skill-ui': 'Design & UX/UI',
        'skill-ui-desc': 'Conception d\'interfaces utilisateur intuitives.',
        'skill-lang': 'Langages',
        'skill-lang-desc': 'Programmation multi-langages et polyvalente.',
        'skill-media': 'Multimédia',
        'skill-media-desc': 'Montage vidéo et design graphique, acquis en IUT MMI.',
        'meter-label': 'Maîtrise',
        'tools-eyebrow': 'Boîte à outils',
        'tools-title': 'Les outils que j\'utilise',
        'cta-skills-title': 'Intéressé par un projet ensemble ?',
        'cta-skills-desc': 'Explorez mes projets ou contactez-moi pour en discuter.',

        // Projets
        'projects-eyebrow': 'Réalisations',
        'projects-title': 'Mes <span class="gradient-text">projets</span>',
        'projects-subtitle': 'Web, design, vidéo et communication : une sélection de travaux réalisés en formation et en stage.',
        'filter-all': 'Tous',
        'filter-motion': 'Vidéo & Animation',
        'filter-design': 'Design & Print',
        'filter-web': 'Web',
        'filter-com': 'Communication',
        'view-project': 'Voir le projet',
        'view-site': 'Voir le site',
        'download-source': 'Télécharger le fichier source',
        'download-file': 'Télécharger',
        'cta-title': 'Envie d\'un projet similaire ?',
        'cta-desc': 'Parlons de votre idée et transformons-la en réalité.',
        'btn-start-project': 'Démarrer un projet',

        // Parcours
        'exp-eyebrow': 'Parcours',
        'exp-title': 'Mon <span class="gradient-text">parcours</span>',
        'exp-subtitle': 'Mon évolution académique et professionnelle, du Bac STI2D à l\'alternance.',
        'tl-now': 'En cours',
        'tl-year1': '1re année sur 2',
        'exp0-date': 'Sept. 2026 — Aujourd\'hui',
        'exp0-title': 'Alternant — Cap RATP',
        'exp0-desc': 'Alternance en entreprise en parallèle de mon BTS CIEL : je mets en pratique au quotidien ce que j\'apprends en formation, au sein des équipes de Cap RATP.',
        'expB-title': 'BTS CIEL — en alternance',
        'expB-desc': 'BTS Cybersécurité, Informatique et réseaux, Électronique, préparé en 2 ans en alternance. Au programme : réseaux, systèmes, cybersécurité, programmation et électronique.',
        'exp1-title': 'ETNA — Piscine &amp; 2e année',
        'exp1-company': 'L\'ETNA — École des technologies numériques avancées',
        'exp1-desc': 'Piscine réussie en 2025 (programme d\'immersion intensif), puis intégration en 2<sup>e</sup> année. Bases solides en programmation, algorithmique et développement web. Projets : site de réservation d\'hôtel et refonte du site élève.',
        'exp2-title': 'Stage — IUT MMI',
        'exp2-desc': 'Stage de première année MMI (1 mois). Création de site vitrine pour artiste, animations de logos et mock-ups. Apprentissage des bonnes pratiques en web design et développement front-end.',
        'exp3-title': 'Formation — IUT MMI',
        'exp3-company': 'IUT de Champs-sur-Marne — parcours Développement Web',
        'exp3-desc': '2 ans de formation en Métiers du Multimédia et de l\'Internet : programmation web, architecture réseau, bases de données et web marketing.',
        'exp4-title': 'Bac STI2D',
        'exp4-company': 'Lycée',
        'exp4-desc': 'Baccalauréat Sciences et Technologies de l\'Industrie et du Développement Durable. Découverte de la programmation et des réseaux, projets pratiques en systèmes et électronique.',
        'cta-exp-title': 'Impressionné par mon parcours ?',
        'cta-exp-desc': 'Découvrez mes compétences ou contactez-moi pour échanger.',

        // Mini-jeux
        'games-eyebrow': 'Pause',
        'games-title': 'Mes <span class="gradient-text">mini-jeux</span>',
        'games-subtitle': 'Une façon ludique de découvrir mon univers et mes compétences.',
        'game-badge-new': 'À JOUER',
        'game-mission-desc': 'Un Pac-Man à ma sauce : mangez les 6 gros points en évitant les fantômes, chacun dévoile une partie de mon profil (formation, alternance, expériences, compétences…).',
        'btn-play': 'Jouer maintenant',
        'game-soon-title': 'Prochain jeu en préparation',
        'game-soon-desc': 'De nouveaux mini-jeux arrivent bientôt. Revenez faire un tour !',

        // Contact
        'contact-eyebrow': 'Contact',
        'contact-title': 'Prenons <span class="gradient-text">contact</span>',
        'contact-subtitle': 'Un projet, une question, une opportunité ? Je suis à l\'écoute.',
        'contact-intro': 'Le plus simple : un petit message via le formulaire ou par email. Je réponds dans les plus brefs délais !',
        'contact-email-detail': 'Réponse en moins de 24h',
        'contact-phone': 'Téléphone',
        'contact-phone-detail': 'Du lundi au vendredi, 9h – 18h',
        'contact-location': 'Localisation',
        'contact-status': 'Statut',
        'contact-status-val': 'Alternant chez Cap RATP',
        'socials-title': 'Retrouvez-moi aussi sur',
        'form-name': 'Nom complet *',
        'form-name-ph': 'Votre nom',
        'form-email': 'Adresse email *',
        'form-email-ph': 'votre@email.com',
        'form-subject': 'Sujet *',
        'form-subject-ph': 'Sujet du message',
        'form-message': 'Message *',
        'form-message-ph': 'Décrivez votre projet ou votre question…',
        'btn-send': 'Envoyer le message',
        'form-note': 'Les champs marqués * sont obligatoires',
        'sending': 'Envoi en cours…',
        'send-success': '✓ Message envoyé avec succès !',
        'send-error': '✗ Erreur d\'envoi, réessayez'
    },
    'en': {
        'nav-home': 'Home',
        'nav-skills': 'Skills',
        'nav-projects': 'Projects',
        'nav-alternance': 'Journey',
        'nav-games': 'Mini-games',
        'nav-contact': 'Contact',
        'nav-cta': 'Let\'s talk',
        'download-cv': 'Download my CV',
        'btn-contact': 'Contact me',
        'btn-projects': 'View my projects',
        'btn-skills': 'See my skills',
        'footer-about-desc': 'BTS CIEL student at UTEC and work-study apprentice at Cap RATP. Passionate about IT, networks and cybersecurity.',
        'footer-nav': 'Navigation',
        'footer-socials': 'Socials',
        'footer-rights': 'All rights reserved.',
        'footer-made': 'Designed and coded in Seine-et-Marne, France',

        'hero-status': 'Work-study at Cap RATP · BTS CIEL',
        'hero-hello': 'Hi, I\'m',
        'hero-desc': '<strong>BTS CIEL</strong> student (1st year) at CFA UTEC in Emerainville and work-study apprentice at <strong>Cap RATP</strong>. Passionate about IT, I\'m training in networks, cybersecurity and web development.',
        'stat-years': 'Years of training',
        'stat-projects': 'Projects completed',
        'stat-skills': 'Skills',
        'chip-job': 'Work-study',
        'chip-school': '1st year · UTEC',
        'chip-web': 'Cybersecurity',
        'chip-web-sub': 'Networks · Systems',
        'now-eyebrow': 'Right now',
        'now-title': 'My work-study',
        'now-sub': 'Since September 2026, I split my time between training at the CFA and hands-on work in a company.',
        'now-school-tag': 'Education',
        'now-school-role': 'Cybersecurity, IT & Networks, Electronics — year 1 of 2',
        'now-company-tag': 'Company',
        'now-company-role': 'Apprentice — alongside the BTS CIEL',
        'now-since': 'Since Sept. 2026',
        'preview-eyebrow': 'Explore',
        'preview-title': 'Dive into my world',
        'preview-projects-desc': 'Web, design, video, communication: a selection of work from school and internships.',
        'preview-skills-desc': 'My technologies and areas of expertise.',
        'preview-games-desc': 'Get to know me by playing Pac-Profil, my homemade Pac-Man.',
        'preview-alternance-desc': 'From the STI2D Bac to work-study at Cap RATP.',
        'preview-contact-desc': 'A question, a project, an opportunity? Write to me, I reply fast.',
        'quality-motivation': 'Motivation',
        'quality-autonomy': 'Autonomy',
        'quality-team': 'Team spirit',
        'quality-creativity': 'Creativity',
        'quality-rigor': 'Rigor',
        'quality-adaptability': 'Adaptability',
        'cta-home-title': 'Want to know more?',
        'cta-home-desc': 'Download my CV or send me a message, I\'d be happy to talk.',

        'skills-eyebrow': 'Skills',
        'skills-title': 'What I <span class="gradient-text">do</span>',
        'skills-subtitle': 'From code to networks to design: the areas I keep improving in every day, at school and at work.',
        'skill-web': 'Web Development',
        'skill-web-desc': 'Building modern, responsive websites.',
        'skill-db': 'Databases',
        'skill-db-desc': 'Designing and managing relational data.',
        'skill-net': 'Networks & Cybersecurity',
        'skill-net-desc': 'Network architecture, system administration and security, deepened in the BTS CIEL.',
        'skill-ui': 'Design & UX/UI',
        'skill-ui-desc': 'Designing intuitive user interfaces.',
        'skill-lang': 'Languages',
        'skill-lang-desc': 'Versatile, multi-language programming.',
        'skill-media': 'Multimedia',
        'skill-media-desc': 'Video editing and graphic design, learned at IUT MMI.',
        'meter-label': 'Proficiency',
        'tools-eyebrow': 'Toolbox',
        'tools-title': 'The tools I use',
        'cta-skills-title': 'Interested in working together?',
        'cta-skills-desc': 'Explore my projects or contact me to discuss.',

        'projects-eyebrow': 'Work',
        'projects-title': 'My <span class="gradient-text">projects</span>',
        'projects-subtitle': 'Web, design, video and communication: a selection of work from school and internships.',
        'filter-all': 'All',
        'filter-motion': 'Video & Animation',
        'filter-design': 'Design & Print',
        'filter-web': 'Web',
        'filter-com': 'Communication',
        'view-project': 'View project',
        'view-site': 'View site',
        'download-source': 'Download source file',
        'download-file': 'Download',
        'cta-title': 'Want a similar project?',
        'cta-desc': 'Let\'s talk about your idea and turn it into reality.',
        'btn-start-project': 'Start a project',

        'exp-eyebrow': 'Journey',
        'exp-title': 'My <span class="gradient-text">journey</span>',
        'exp-subtitle': 'My academic and professional path, from the STI2D Bac to work-study.',
        'tl-now': 'Ongoing',
        'tl-year1': 'Year 1 of 2',
        'exp0-date': 'Sept. 2026 — Present',
        'exp0-title': 'Apprentice — Cap RATP',
        'exp0-desc': 'Work-study position alongside my BTS CIEL: I apply what I learn at school every day, working with the Cap RATP teams.',
        'expB-title': 'BTS CIEL — work-study',
        'expB-desc': 'Two-year BTS in Cybersecurity, IT & Networks and Electronics, as a work-study program. Covers networks, systems, cybersecurity, programming and electronics.',
        'exp1-title': 'ETNA — Piscine &amp; 2nd year',
        'exp1-company': 'ETNA — School of advanced digital technologies',
        'exp1-desc': 'Passed the 2025 Piscine (intensive immersion program), then joined the 2nd year. Solid foundations in programming, algorithms and web development. Projects: hotel booking website and student site redesign.',
        'exp2-title': 'Internship — IUT MMI',
        'exp2-desc': 'First-year MMI internship (1 month). Built a showcase website for an artist, logo animations and mock-ups. Learned web design and front-end best practices.',
        'exp3-title': 'Education — IUT MMI',
        'exp3-company': 'IUT Champs-sur-Marne — Web Development track',
        'exp3-desc': '2 years of Multimedia and Internet studies: web programming, network architecture, databases and web marketing.',
        'exp4-title': 'Bac STI2D',
        'exp4-company': 'High school',
        'exp4-desc': 'Technological Baccalaureate in Industry and Sustainable Development. First steps in programming and networks, hands-on projects in systems and electronics.',
        'cta-exp-title': 'Impressed by my journey?',
        'cta-exp-desc': 'Discover my skills or get in touch.',

        'games-eyebrow': 'Break time',
        'games-title': 'My <span class="gradient-text">mini-games</span>',
        'games-subtitle': 'A fun way to discover my world and skills.',
        'game-badge-new': 'PLAY',
        'game-mission-desc': 'My take on Pac-Man: eat the 6 power pellets while dodging the ghosts, each one reveals part of my profile (education, work-study, experience, skills…).',
        'btn-play': 'Play now',
        'game-soon-title': 'Next game in the works',
        'game-soon-desc': 'New mini-games are coming soon. Check back later!',

        'contact-eyebrow': 'Contact',
        'contact-title': 'Let\'s get in <span class="gradient-text">touch</span>',
        'contact-subtitle': 'A project, a question, an opportunity? I\'m all ears.',
        'contact-intro': 'The easiest way: a quick message through the form or by email. I\'ll reply as soon as possible!',
        'contact-email-detail': 'Reply within 24h',
        'contact-phone': 'Phone',
        'contact-phone-detail': 'Monday to Friday, 9am – 6pm',
        'contact-location': 'Location',
        'contact-status': 'Status',
        'contact-status-val': 'Apprentice at Cap RATP',
        'socials-title': 'Also find me on',
        'form-name': 'Full name *',
        'form-name-ph': 'Your name',
        'form-email': 'Email address *',
        'form-email-ph': 'you@email.com',
        'form-subject': 'Subject *',
        'form-subject-ph': 'Message subject',
        'form-message': 'Message *',
        'form-message-ph': 'Describe your project or question…',
        'btn-send': 'Send message',
        'form-note': 'Fields marked * are required',
        'sending': 'Sending…',
        'send-success': '✓ Message sent!',
        'send-error': '✗ Sending failed, try again'
    }
};

const roleWords = {
    'fr': ['Réseaux & Cybersécurité', 'Développeur Web', 'Alternant chez Cap RATP', 'Futur technicien informatique'],
    'en': ['Networks & Cybersecurity', 'Web Developer', 'Apprentice at Cap RATP', 'Future IT technician']
};

function readStoredLang() {
    try {
        return localStorage.getItem('language');
    } catch (e) {
        return null;
    }
}

let currentLang = readStoredLang() || 'fr';
const t = (key) => (translations[currentLang] && translations[currentLang][key]) || translations.fr[key] || key;

const langToggle = document.getElementById('langToggle');
const langMenu = document.getElementById('langMenu');

function setLanguage(lang) {
    if (!translations[lang]) lang = 'fr';
    currentLang = lang;

    document.querySelectorAll('[data-i18n]').forEach(el => {
        const value = translations[lang][el.getAttribute('data-i18n')];
        if (!value) return;
        if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
            el.placeholder = value;
        } else {
            el.innerHTML = value;
        }
    });

    if (langToggle) langToggle.textContent = lang.toUpperCase();
    document.documentElement.lang = lang;
    try {
        localStorage.setItem('language', lang);
    } catch (e) { /* stockage indisponible */ }

    restartRotator();
}

if (langToggle && langMenu) {
    langToggle.addEventListener('click', (e) => {
        e.stopPropagation();
        langMenu.classList.toggle('show');
    });

    document.querySelectorAll('.lang-option').forEach(option => {
        option.addEventListener('click', (e) => {
            e.preventDefault();
            setLanguage(option.getAttribute('data-lang'));
            langMenu.classList.remove('show');
        });
    });

    document.addEventListener('click', (e) => {
        if (!langToggle.contains(e.target) && !langMenu.contains(e.target)) {
            langMenu.classList.remove('show');
        }
    });
}

// --------------------------------------------------------------------------
// Texte qui s'écrit tout seul (accueil)
// --------------------------------------------------------------------------
const rotator = document.getElementById('roleRotator');
let rotatorTimer = null;

function restartRotator() {
    if (!rotator) return;
    clearTimeout(rotatorTimer);
    const words = roleWords[currentLang] || roleWords.fr;
    let wordIndex = 0;
    let charIndex = words[0].length;
    let deleting = false;
    rotator.textContent = words[0];

    if (prefersReducedMotion) {
        const swap = () => {
            wordIndex = (wordIndex + 1) % words.length;
            rotator.textContent = words[wordIndex];
            rotatorTimer = setTimeout(swap, 2600);
        };
        rotatorTimer = setTimeout(swap, 2600);
        return;
    }

    const tick = () => {
        const word = words[wordIndex];
        if (deleting) {
            charIndex--;
            rotator.textContent = word.slice(0, charIndex);
            if (charIndex === 0) {
                deleting = false;
                wordIndex = (wordIndex + 1) % words.length;
                rotatorTimer = setTimeout(tick, 300);
                return;
            }
            rotatorTimer = setTimeout(tick, 35);
        } else {
            const next = words[wordIndex];
            charIndex++;
            rotator.textContent = next.slice(0, charIndex);
            if (charIndex === next.length) {
                deleting = true;
                rotatorTimer = setTimeout(tick, 2200);
                return;
            }
            rotatorTimer = setTimeout(tick, 70);
        }
    };
    deleting = true;
    rotatorTimer = setTimeout(tick, 2200);
}

// --------------------------------------------------------------------------
// Navigation
// --------------------------------------------------------------------------
const navbar = document.getElementById('navbar');
const menuToggle = document.getElementById('menuToggle');
const navMenu = document.getElementById('navMenu');

function setMenu(open) {
    if (!navMenu) return;
    navMenu.classList.toggle('active', open);
    if (navbar) navbar.classList.toggle('menu-open', open);
    if (menuToggle) {
        menuToggle.setAttribute('aria-expanded', String(open));
        menuToggle.innerHTML = open ? '<i class="fas fa-xmark"></i>' : '<i class="fas fa-bars"></i>';
    }
}

if (menuToggle && navMenu) {
    menuToggle.addEventListener('click', (e) => {
        e.stopPropagation();
        setMenu(!navMenu.classList.contains('active'));
    });
    navMenu.querySelectorAll('a').forEach(link => link.addEventListener('click', () => setMenu(false)));
    document.addEventListener('click', (e) => {
        if (!e.target.closest('.navbar')) setMenu(false);
    });
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') setMenu(false);
    });
}

(function markActiveLink() {
    const currentPage = window.location.pathname.split('/').pop() || 'index.html';
    document.querySelectorAll('.nav-link').forEach(link => {
        link.classList.toggle('active', link.getAttribute('href') === currentPage);
    });
})();

// --------------------------------------------------------------------------
// Scroll : barre de progression, navbar, retour en haut
// --------------------------------------------------------------------------
const scrollProgress = document.getElementById('scrollProgress');
const backToTop = document.getElementById('backToTop');

function onScroll() {
    const y = window.scrollY;
    const max = document.documentElement.scrollHeight - window.innerHeight;
    if (scrollProgress) scrollProgress.style.transform = `scaleX(${max > 0 ? y / max : 0})`;
    if (navbar) navbar.classList.toggle('scrolled', y > 20);
    if (backToTop) backToTop.classList.toggle('show', y > 600);
}

window.addEventListener('scroll', onScroll, { passive: true });
onScroll();

if (backToTop) {
    backToTop.addEventListener('click', () => window.scrollTo({ top: 0, behavior: 'smooth' }));
}

// --------------------------------------------------------------------------
// Apparitions au scroll, compteurs et barres de niveau
// --------------------------------------------------------------------------
function countUp(el) {
    const target = parseInt(el.dataset.count, 10);
    const suffix = el.dataset.suffix || '';
    if (prefersReducedMotion || isNaN(target)) return;
    const duration = 1200;
    const start = performance.now();
    const step = (now) => {
        const p = Math.min((now - start) / duration, 1);
        const eased = 1 - Math.pow(1 - p, 3);
        el.textContent = Math.round(target * eased) + suffix;
        if (p < 1) requestAnimationFrame(step);
    };
    requestAnimationFrame(step);
}

const progressBars = document.querySelectorAll('.progress-bar');
progressBars.forEach(bar => {
    bar.dataset.width = bar.style.width;
    bar.style.width = '0';
    bar.style.transition = 'width 1.4s cubic-bezier(0.22, 1, 0.36, 1)';
});

if ('IntersectionObserver' in window) {
    const revealObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (!entry.isIntersecting) return;
            const el = entry.target;
            el.classList.add('visible');
            el.querySelectorAll('[data-count]').forEach(countUp);
            el.querySelectorAll('.progress-bar').forEach(bar => { bar.style.width = bar.dataset.width; });
            revealObserver.unobserve(el);
        });
    }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });

    document.querySelectorAll('.reveal').forEach(el => revealObserver.observe(el));
} else {
    document.querySelectorAll('.reveal').forEach(el => el.classList.add('visible'));
    progressBars.forEach(bar => { bar.style.width = bar.dataset.width; });
}

// --------------------------------------------------------------------------
// Filtre des projets
// --------------------------------------------------------------------------
const filterBtns = document.querySelectorAll('.filter-bar .filter-btn');
const projectCards = document.querySelectorAll('.projects-grid .project-card');

filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
        const category = btn.getAttribute('data-filter');
        filterBtns.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        projectCards.forEach(card => {
            const match = category === 'all' || card.getAttribute('data-category') === category;
            card.classList.toggle('is-hidden', !match);
            if (match) card.classList.add('visible');
        });
    });
});

// --------------------------------------------------------------------------
// Formulaire de contact (Formspree)
// --------------------------------------------------------------------------
const contactForm = document.getElementById('contactForm');

if (contactForm) {
    const fields = contactForm.querySelectorAll('input, textarea');

    fields.forEach(field => {
        field.addEventListener('input', () => {
            if (field.value.trim()) field.closest('.form-group').classList.remove('invalid');
        });
    });

    contactForm.addEventListener('submit', function (e) {
        e.preventDefault();

        let isValid = true;
        fields.forEach(field => {
            const empty = !field.value.trim();
            field.closest('.form-group').classList.toggle('invalid', empty);
            if (empty) isValid = false;
        });
        if (!isValid) return;

        const button = this.querySelector('button[type="submit"]');
        const originalHTML = button.innerHTML;
        const reset = (delay) => setTimeout(() => {
            button.innerHTML = originalHTML;
            button.classList.remove('is-success', 'is-error');
            button.disabled = false;
        }, delay);

        button.innerHTML = `<span>${t('sending')}</span>`;
        button.disabled = true;

        fetch(this.action, {
            method: 'POST',
            headers: { 'Accept': 'application/json' },
            body: new FormData(this)
        })
            .then(response => {
                if (!response.ok) throw new Error('Erreur serveur ' + response.status);
                button.innerHTML = `<span>${t('send-success')}</span>`;
                button.classList.add('is-success');
                contactForm.reset();
                reset(3500);
            })
            .catch(error => {
                console.error('Erreur Formspree :', error);
                button.innerHTML = `<span>${t('send-error')}</span>`;
                button.classList.add('is-error');
                reset(3500);
            });
    });
}

// --------------------------------------------------------------------------
// Modal (vidéos des projets)
// --------------------------------------------------------------------------
const modal = document.getElementById('projectModal');

if (modal) {
    const modalBody = document.getElementById('modalBody');
    const modalClose = document.getElementById('modalClose');
    const modalCaption = document.getElementById('modalCaption');

    const openModal = (type, source, captionText) => {
        modalBody.innerHTML = '';
        modalCaption.textContent = captionText || '';

        let media;
        if (type === 'video') {
            media = document.createElement('video');
            media.controls = true;
            media.autoplay = true;
        } else {
            media = document.createElement('img');
            media.alt = captionText || '';
        }
        media.src = source;
        media.className = 'modal-content';
        modalBody.appendChild(media);

        modal.style.display = 'flex';
        requestAnimationFrame(() => modal.classList.add('active'));
        document.body.style.overflow = 'hidden';
    };

    const closeModal = () => {
        modal.classList.remove('active');
        document.body.style.overflow = '';
        setTimeout(() => {
            modal.style.display = 'none';
            modalBody.innerHTML = '';
        }, 300);
    };

    modalClose.addEventListener('click', closeModal);
    modal.addEventListener('click', (e) => {
        if (e.target === modal || e.target.classList.contains('modal-content-wrapper')) closeModal();
    });
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && modal.classList.contains('active')) closeModal();
    });

    document.querySelectorAll('.view-project-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            openModal(btn.dataset.type, btn.dataset.source, btn.dataset.caption);
        });
    });
}

// --------------------------------------------------------------------------
// Divers
// --------------------------------------------------------------------------
document.querySelectorAll('.year').forEach(el => { el.textContent = new Date().getFullYear(); });

setLanguage(currentLang);
