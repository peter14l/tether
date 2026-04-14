document.addEventListener('DOMContentLoaded', () => {
    // 1. Intersection Observer for scroll animations
    const animationObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
                
                // For number counters
                if (entry.target.classList.contains('stat-number')) {
                    animateValue(entry.target);
                }
            } else {
                // Remove active class to allow animation to repeat
                entry.target.classList.remove('active');
                
                // Reset counters
                if (entry.target.classList.contains('stat-number')) {
                    entry.target.innerHTML = '0';
                }
            }
        });

    }, { threshold: 0.1 });

    document.querySelectorAll('.animate-on-scroll').forEach(el => {
        animationObserver.observe(el);
    });


    // 2. Cursor Glow Follow (Lerp)
    const cursorGlow = document.getElementById('cursor-glow');
    let mouseX = 0, mouseY = 0;
    let glowX = 0, glowY = 0;

    window.addEventListener('mousemove', (e) => {
        mouseX = e.clientX;
        mouseY = e.clientY;
    });

    function updateGlow() {
        // Smooth lerp (linear interpolation)
        glowX += (mouseX - glowX) * 0.1;
        glowY += (mouseY - glowY) * 0.1;

        cursorGlow.style.left = `${glowX}px`;
        cursorGlow.style.top = `${glowY}px`;

        requestAnimationFrame(updateGlow);
    }
    updateGlow();


    // 3. Navbar scroll transition
    const navbar = document.getElementById('navbar');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 80) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });


    // 4. Mobile Menu Toggle
    const menuToggle = document.querySelector('.mobile-menu-toggle');
    const mobileNav = document.getElementById('mobile-nav');
    const mobileLinks = document.querySelectorAll('.mobile-nav-link');
    
    const toggleMenu = () => {
        mobileNav.classList.toggle('active');
        menuToggle.classList.toggle('open');
    };

    menuToggle.addEventListener('click', toggleMenu);

    mobileLinks.forEach(link => {
        link.addEventListener('click', () => {
            mobileNav.classList.remove('active');
            menuToggle.classList.remove('open');
        });
    });



    // 5. Download Modal
    const androidBtn = document.getElementById('android-download-btn');
    const androidBtnV2 = document.getElementById('android-download-btn-v2');
    const modal = document.getElementById('download-modal');
    const modalClose = document.querySelector('.modal-close');
    const modalOverlay = document.querySelector('.modal-overlay');

    const openModal = () => {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    };

    if (androidBtn) androidBtn.addEventListener('click', openModal);
    if (androidBtnV2) androidBtnV2.addEventListener('click', openModal);

    const closeModal = () => {
        modal.classList.remove('active');
        document.body.style.overflow = 'auto';
    };

    modalClose.addEventListener('click', closeModal);
    modalOverlay.addEventListener('click', (e) => {
        if (e.target === modalOverlay) closeModal();
    });
    
    // ... closeModal logic remains same ...

    // 8. Theme Showcase Logic
    const themeTabs = document.querySelectorAll('.theme-tab');
    const themeImg = document.getElementById('main-theme-img');

    themeTabs.forEach(tab => {
        tab.addEventListener('click', () => {
            // Update tabs
            themeTabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');

            // Crossfade effect (simple version)
            themeImg.style.opacity = '0';
            setTimeout(() => {
                // In a real app, you'd change the src here to match the theme
                // themeImg.src = `assets/theme_${tab.getAttribute('data-theme')}.png`;
                themeImg.style.opacity = '1';
            }, 300);
        });
    });



    // 6. Number Counter Animation
    function animateValue(obj) {
        const start = 0;
        const end = parseInt(obj.getAttribute('data-target'));
        const duration = 1200;
        let startTimestamp = null;

        const step = (timestamp) => {
            if (!startTimestamp) startTimestamp = timestamp;
            const progress = Math.min((timestamp - startTimestamp) / duration, 1);
            
            // Ease out cubic
            const easeOutCubic = 1 - Math.pow(1 - progress, 3);
            const value = Math.floor(easeOutCubic * end);
            
            obj.innerHTML = value + (obj.getAttribute('data-suffix') || '');
            
            if (progress < 1) {
                window.requestAnimationFrame(step);
            }
        };
        window.requestAnimationFrame(step);
    }


    // 7. Time Theme Logic
    function updateTimeTheme() {
        const timeDisplay = document.getElementById('footer-time');
        if (!timeDisplay) return;

        const now = new Date();
        const hours = now.getHours();
        let theme = 'Night';
        let emoji = '🌙';

        if (hours >= 5 && hours < 11) { theme = 'Morning'; emoji = '🌅'; }
        else if (hours >= 11 && hours < 17) { theme = 'Afternoon'; emoji = '☀️'; }
        else if (hours >= 17 && hours < 21) { theme = 'Dusk'; emoji = '🌇'; }

        const timeString = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        timeDisplay.innerHTML = `${timeString} · ${theme} theme ${emoji}`;
    }

    updateTimeTheme();
    setInterval(updateTimeTheme, 60000); // Update every minute
});
