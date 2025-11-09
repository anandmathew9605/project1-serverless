// Theme Management
class ThemeManager {
    constructor() {
        this.themeToggle = document.getElementById('themeToggle');
        if (!this.themeToggle) return;
        
        this.moonIcon = this.themeToggle.querySelector('.moon-icon');
        this.sunIcon = this.themeToggle.querySelector('.sun-icon');
        this.currentTheme = this.getStoredTheme() || 'dark';
        
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


// Initialize everything when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new ThemeManager();
    new ProjectCards();
    new PageAnimations();
});

// ----------------------------
// Visitor Counter Integration
// ----------------------------

// Function to get ordinal suffix (st, nd, rd, th)
function getOrdinalSuffix(number) {
  const lastDigit = number % 10;
  const lastTwoDigits = number % 100;
  
  // Handle special cases (11th, 12th, 13th)
  if (lastTwoDigits >= 11 && lastTwoDigits <= 13) {
    return number + "th";
  }
  
  // Handle regular cases
  switch (lastDigit) {
    case 1:
      return number + "st";
    case 2:
      return number + "nd";
    case 3:
      return number + "rd";
    default:
      return number + "th";
  }
}

(async function updateVisitorCount() {
  const apiUrl = window.location.hostname.includes("serverless.anandmathew.site")
  ? "https://18ik10v4a3.execute-api.ap-south-1.amazonaws.com/count"
  : "https://nz9ry019oj.execute-api.ap-south-1.amazonaws.com/count";

  try {
    // Increment visitor count (POST)
    await fetch(apiUrl, { method: "POST" });

    // Fetch current count (GET)
    const response = await fetch(apiUrl);
    const data = await response.json();

    // Update visitor count in HTML with proper ordinal suffix
    const visitorElement = document.querySelector(".visitor-count");
    if (visitorElement && data.count !== undefined) {
      visitorElement.textContent = getOrdinalSuffix(data.count);
    }
  } catch (error) {
    console.error("Visitor counter error:", error);
  }
})();
