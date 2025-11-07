// Theme Management
class ThemeManager {
    constructor() {
        this.themeToggle = document.getElementById('themeToggle');
        if (!this.themeToggle) return;
        
        this.moonIcon = this.themeToggle.querySelector('.moon-icon');
        this.sunIcon = this.themeToggle.querySelector('.sun-icon');
        this.currentTheme = this.getStoredTheme() || 'light';
        
        this.init();
    }
    
    init() {
        // Set initial theme
        this.applyTheme(this.currentTheme);
        
        // Add event listener for theme toggle
        this.themeToggle.addEventListener('click', () => {
            this.toggleTheme();
        });
        
        // Listen for system theme changes
        if (window.matchMedia) {
            window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
                if (!this.getStoredTheme()) {
                    this.applyTheme(e.matches ? 'dark' : 'light');
                }
            });
        }
    }
    
    toggleTheme() {
        const newTheme = this.currentTheme === 'light' ? 'dark' : 'light';
        this.applyTheme(newTheme);
        this.storeTheme(newTheme);
    }
    
    applyTheme(theme) {
        this.currentTheme = theme;
        
        // Apply theme to document
        if (theme === 'dark') {
            document.documentElement.setAttribute('data-theme', 'dark');
            this.moonIcon.style.display = 'none';
            this.sunIcon.style.display = 'block';
        } else {
            document.documentElement.removeAttribute('data-theme');
            this.moonIcon.style.display = 'block';
            this.sunIcon.style.display = 'none';
        }
        
        // Add smooth transition class
        document.body.classList.add('theme-transition');
        const transitionDuration = 300;
        setTimeout(() => {
            document.body.classList.remove('theme-transition');
        }, transitionDuration);
    }
    
    storeTheme(theme) {
        try {
            localStorage.setItem('portfolio-theme', theme);
        } catch (e) {
            // Silent fail for localStorage issues
        }
    }
    
    getStoredTheme() {
        try {
            return localStorage.getItem('portfolio-theme');
        } catch (e) {
            return null;
        }
    }
}


// Project Card Selection System
class ProjectCards {
    constructor() {
        this.cards = document.querySelectorAll('.project-card');
        this.projectsGrid = document.querySelector('.projects-grid');
        this.defaultCard = this.cards[0];
        
        if (this.cards.length === 0) return;
        this.init();
    }
    
    init() {
        this.cards.forEach((card, index) => {
            // Add click handlers for project buttons
            const button = card.querySelector('.project-button');
            if (button) {
                button.addEventListener('click', (e) => {
                    e.stopPropagation();
                    this.handleProjectClick(card, button, e);
                });
            }
            
            // Add hover effects for card selection
            card.addEventListener('mouseenter', () => {
                this.selectCard(card);
            });
        });
        
        // Reset to default card when mouse leaves the projects grid
        this.projectsGrid.addEventListener('mouseleave', () => {
            this.resetToDefault();
        });
        
        // Ensure default card is selected on load
        this.selectCard(this.defaultCard);
    }
    
    selectCard(card) {
        // Remove selected class from all cards
        this.cards.forEach(c => c.classList.remove('selected'));
        
        // Add selected class to the target card
        card.classList.add('selected');
        
    }
    
    resetToDefault() {
        // Reset to card 1 when cursor leaves the grid area
        this.selectCard(this.defaultCard);
    }
    
    handleProjectClick(card, button, event) {
        // Handle placeholder buttons (security improvement)
        if (button.dataset.placeholder === 'true') {
            event.preventDefault();
            alert('Project URL not configured yet');
            return;
        }
        
        // Only handle current button (non-link buttons)
        if (button.classList.contains('current') || button.disabled) {
            return;
        }
        
        // Add click animation for all buttons
        button.style.transform = 'scale(0.95)';
        setTimeout(() => {
            button.style.transform = '';
        }, 150);
    }
}

// Smooth Scroll and Page Animations
class PageAnimations {
    constructor() {
        this.cards = document.querySelectorAll('.project-card');
        this.init();
    }
    
    init() {
        // Add entrance animations
        this.addEntranceAnimations();
        
        // Add scroll animations if needed
        this.setupScrollAnimations();
    }
    
    addEntranceAnimations() {
        const elements = document.querySelectorAll('.top-controls, .header, .project-card');
        
        elements.forEach((el, index) => {
            el.style.cssText = 'opacity: 0; transform: translateY(20px); transition: opacity 0.6s ease, transform 0.6s ease;';
            
            requestAnimationFrame(() => {
                setTimeout(() => {
                    el.style.cssText += 'opacity: 1; transform: translateY(0);';
                }, index * 80);
            });
        });
    }
    
    setupScrollAnimations() {
        // Intersection Observer for scroll animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };
        
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('animate-in');
                }
            });
        }, observerOptions);
        
        // Observe project cards for scroll animations (reuse existing cards)
        this.cards = this.cards || document.querySelectorAll('.project-card');
        this.cards.forEach(card => {
            observer.observe(card);
        });
    }
}

// Enhanced Title Interactions
class TitleEnhancer {
    constructor() {
        this.titleElement = document.querySelector('.title');
        this.init();
    }
    
    init() {
        this.titleElement.addEventListener('click', () => {
            this.triggerClickEffect();
        });
        
        // Add typing effect on load
        this.addTypingEffect();
    }
    
    triggerClickEffect() {
        // Create ripple effect
        this.titleElement.style.animation = 'none';
        this.titleElement.style.transform = 'scale(1.1) rotate(2deg)';
        
        setTimeout(() => {
            this.titleElement.style.transform = '';
            this.titleElement.style.animation = 'gradientShift 4s ease-in-out infinite';
        }, 300);
        
        // Create floating particles
        this.createParticles();
    }
    
    createParticles() {
        const rect = this.titleElement.getBoundingClientRect();
        const particleConfig = {
            count: 8,
            colors: ['#4a90e2', '#28a745', '#ffc107', '#e74c3c'],
            minDistance: 100,
            maxDistance: 150,
            minDuration: 800,
            maxDuration: 1200
        };
        
        for (let i = 0; i < particleConfig.count; i++) {
            const particle = document.createElement('div');
            particle.style.cssText = `
                position: fixed;
                width: 6px;
                height: 6px;
                background: ${particleConfig.colors[Math.floor(Math.random() * particleConfig.colors.length)]};
                border-radius: 50%;
                pointer-events: none;
                z-index: 1000;
                left: ${rect.left + rect.width / 2}px;
                top: ${rect.top + rect.height / 2}px;
            `;
            
            document.body.appendChild(particle);
            
            // Animate particle
            const angle = (Math.PI * 2 * i) / 8;
            const distance = particleConfig.minDistance + Math.random() * (particleConfig.maxDistance - particleConfig.minDistance);
            const duration = particleConfig.minDuration + Math.random() * (particleConfig.maxDuration - particleConfig.minDuration);
            
            particle.animate([
                { 
                    transform: 'translate(0, 0) scale(1)',
                    opacity: 1
                },
                { 
                    transform: `translate(${Math.cos(angle) * distance}px, ${Math.sin(angle) * distance}px) scale(0)`,
                    opacity: 0
                }
            ], {
                duration: duration,
                easing: 'cubic-bezier(0.4, 0, 0.2, 1)'
            }).onfinish = () => {
                particle.remove();
            };
        }
    }
    
    addTypingEffect() {
        const originalText = this.titleElement.textContent;
        this.titleElement.textContent = '';
        
        let index = 0;
        const type = () => {
            if (index < originalText.length) {
                this.titleElement.textContent += originalText[index];
                index++;
                setTimeout(type, 80);
            }
        };
        
        setTimeout(type, 100);
    }
}

// Initialize everything when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new ThemeManager();
    new ProjectCards();
    new PageAnimations();
    new TitleEnhancer();
});

// ----------------------------
// Visitor Counter Integration
// ----------------------------
(async function updateVisitorCount() {
  const apiUrl = window.location.hostname.includes("serverless.anandmathew.site")
  ? "https://6co3lc5hi3.execute-api.ap-south-1.amazonaws.com/count"
  : "https://2f4r4598n7.execute-api.ap-south-1.amazonaws.com/count";

  try {
    // Increment visitor count (POST)
    await fetch(apiUrl, { method: "POST" });

    // Fetch current count (GET)
    const response = await fetch(apiUrl);
    const data = await response.json();

    // Update visitor count in HTML
    const visitorElement = document.querySelector(".visitor-count");
    if (visitorElement && data.count !== undefined) {
      visitorElement.textContent = data.count + "th";
    }
  } catch (error) {
    console.error("Visitor counter error:", error);
  }
})();
