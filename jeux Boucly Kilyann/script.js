/**
 * PAC-MAN NEON EDITION CV
 * 
 * Game Engine: Grid Based
 */

const TILE_SIZE = 30; // 20x21 grid = 600x630
const COLS = 20;
const ROWS = 21;

// 1 = Mur, 0 = Point, 2 = Power Pellet (CV Info), 9 = Vide (Ghost House)
const MAP_LAYOUT = [
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 2, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 2, 1],
    [1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1],
    [1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1],
    [1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1],
    [1, 1, 1, 1, 0, 1, 1, 1, 9, 1, 1, 9, 1, 1, 1, 0, 1, 1, 1, 1],
    [1, 1, 1, 1, 0, 1, 9, 9, 9, 9, 9, 9, 9, 9, 1, 0, 1, 1, 1, 1],
    [1, 2, 0, 0, 0, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 0, 0, 0, 2, 1],
    [1, 1, 1, 1, 0, 1, 9, 9, 9, 9, 9, 9, 9, 9, 1, 0, 1, 1, 1, 1],
    [1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1],
    [1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
    [1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1],
    [1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1],
    [1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1],
    [1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] // Extra row
];

class Input {
    constructor() {
        this.dir = { x: 0, y: 0 };
        this.nextDir = { x: 0, y: 0 };

        window.addEventListener('keydown', e => {
            switch (e.key) {
                case 'ArrowUp': case 'z': case 'Z': this.nextDir = { x: 0, y: -1 }; break;
                case 'ArrowDown': case 's': case 'S': this.nextDir = { x: 0, y: 1 }; break;
                case 'ArrowLeft': case 'q': case 'Q': this.nextDir = { x: -1, y: 0 }; break;
                case 'ArrowRight': case 'd': case 'D': this.nextDir = { x: 1, y: 0 }; break;
                default: return;
            }
            e.preventDefault();
        });

        // Touch Controls
        const setupBtn = (id, dx, dy) => {
            const btn = document.getElementById(id);
            if (btn) {
                btn.addEventListener('touchstart', (e) => {
                    e.preventDefault();
                    this.nextDir = { x: dx, y: dy };
                });
                btn.addEventListener('mousedown', (e) => {
                    this.nextDir = { x: dx, y: dy };
                });
            }
        };

        setupBtn('ctrl-up', 0, -1);
        setupBtn('ctrl-down', 0, 1);
        setupBtn('ctrl-left', -1, 0);
        setupBtn('ctrl-right', 1, 0);
    }
}

class Pacman {
    constructor(map) {
        this.map = map;
        this.x = 10; // Grid coordinates (case libre sous la maison des fantômes)
        this.y = 14;
        this.dir = { x: 0, y: 0 };
        this.nextDir = { x: 0, y: 0 };
        this.angle = 0;
        this.mouthOpen = 0;
        this.mouthSpeed = 0.2;

        // Pixel pos
        this.px = this.x * TILE_SIZE + TILE_SIZE / 2;
        this.py = this.y * TILE_SIZE + TILE_SIZE / 2;
        this.speed = 0.15; // Grid cells per frame approx
    }

    update(inputDir) {
        // Try to change direction if aligned to grid
        if (this.isCentered()) {
            if (inputDir.x !== 0 || inputDir.y !== 0) this.nextDir = inputDir;

            // Apply next dir if valid
            if (!this.map.isWall(this.x + this.nextDir.x, this.y + this.nextDir.y)) {
                this.dir = this.nextDir;
            }

            // Stop if hitting wall directly
            if (this.map.isWall(this.x + this.dir.x, this.y + this.dir.y)) {
                this.dir = { x: 0, y: 0 };
            }
        }

        // Move
        this.px += this.dir.x * this.speed * TILE_SIZE;
        this.py += this.dir.y * this.speed * TILE_SIZE;

        // Update Grid Coords
        this.x = Math.round((this.px - TILE_SIZE / 2) / TILE_SIZE);
        this.y = Math.round((this.py - TILE_SIZE / 2) / TILE_SIZE);

        // Mouth animation
        this.mouthOpen += this.mouthSpeed;
        if (this.mouthOpen > 0.2 * Math.PI || this.mouthOpen < 0) this.mouthSpeed *= -1;

        // Rotation
        if (this.dir.x === 1) this.angle = 0;
        if (this.dir.x === -1) this.angle = Math.PI;
        if (this.dir.y === 1) this.angle = Math.PI / 2;
        if (this.dir.y === -1) this.angle = -Math.PI / 2;
    }

    isCentered() {
        const centerX = this.x * TILE_SIZE + TILE_SIZE / 2;
        const centerY = this.y * TILE_SIZE + TILE_SIZE / 2;
        return Math.abs(this.px - centerX) < 2 && Math.abs(this.py - centerY) < 2;
    }

    snapToGrid() {
        this.px = this.x * TILE_SIZE + TILE_SIZE / 2;
        this.py = this.y * TILE_SIZE + TILE_SIZE / 2;
    }

    draw(ctx) {
        ctx.fillStyle = '#ffff00';
        ctx.beginPath();
        ctx.moveTo(this.px, this.py);
        ctx.arc(this.px, this.py, TILE_SIZE / 2 - 2, this.angle + this.mouthOpen, this.angle + (Math.PI * 2 - this.mouthOpen));
        ctx.fill();

        // Glow
        ctx.shadowBlur = 10;
        ctx.shadowColor = '#ffff00';
        ctx.fill();
        ctx.shadowBlur = 0;
    }
}

class Ghost {
    constructor(map, color, startX, startY) {
        this.map = map;
        this.color = color;
        this.x = startX;
        this.y = startY;
        this.px = this.x * TILE_SIZE + TILE_SIZE / 2;
        this.py = this.y * TILE_SIZE + TILE_SIZE / 2;
        this.dir = { x: 0, y: -1 }; // Start moving up
        this.speed = 0.12;
    }

    update() {
        if (this.isCentered()) {
            // Simple Random AI
            const choices = [];
            if (!this.map.isWall(this.x + 1, this.y) && this.dir.x !== -1) choices.push({ x: 1, y: 0 });
            if (!this.map.isWall(this.x - 1, this.y) && this.dir.x !== 1) choices.push({ x: -1, y: 0 });
            if (!this.map.isWall(this.x, this.y + 1) && this.dir.y !== -1) choices.push({ x: 0, y: 1 });
            if (!this.map.isWall(this.x, this.y - 1) && this.dir.y !== 1) choices.push({ x: 0, y: -1 });

            if (choices.length > 0) {
                this.dir = choices[Math.floor(Math.random() * choices.length)];
            } else {
                this.dir = { x: -this.dir.x, y: -this.dir.y }; // Dead end reverse
            }
        }

        this.px += this.dir.x * this.speed * TILE_SIZE;
        this.py += this.dir.y * this.speed * TILE_SIZE;

        this.x = Math.round((this.px - TILE_SIZE / 2) / TILE_SIZE);
        this.y = Math.round((this.py - TILE_SIZE / 2) / TILE_SIZE);
    }

    isCentered() {
        const centerX = this.x * TILE_SIZE + TILE_SIZE / 2;
        const centerY = this.y * TILE_SIZE + TILE_SIZE / 2;
        return Math.abs(this.px - centerX) < 2 && Math.abs(this.py - centerY) < 2;
    }

    draw(ctx) {
        ctx.fillStyle = this.color;
        ctx.shadowColor = this.color;

        // Ghost Shape
        ctx.beginPath();
        ctx.arc(this.px, this.py - 2, TILE_SIZE / 2 - 4, Math.PI, 0);
        ctx.lineTo(this.px + TILE_SIZE / 2 - 4, this.py + TILE_SIZE / 2 - 4);
        // Feet
        ctx.lineTo(this.px + 5, this.py + TILE_SIZE / 2 - 8);
        ctx.lineTo(this.px - 5, this.py + TILE_SIZE / 2 - 4);
        ctx.lineTo(this.px - TILE_SIZE / 2 + 4, this.py + TILE_SIZE / 2 - 4);
        ctx.fill();

        // Eyes
        ctx.fillStyle = '#fff';
        ctx.shadowBlur = 0;
        ctx.beginPath();
        ctx.arc(this.px - 4, this.py - 4, 3, 0, Math.PI * 2);
        ctx.arc(this.px + 4, this.py - 4, 3, 0, Math.PI * 2);
        ctx.fill();

        ctx.fillStyle = '#000';
        ctx.beginPath();
        ctx.arc(this.px - 4 + this.dir.x * 2, this.py - 4 + this.dir.y * 2, 1.5, 0, Math.PI * 2);
        ctx.arc(this.px + 4 + this.dir.x * 2, this.py - 4 + this.dir.y * 2, 1.5, 0, Math.PI * 2);
        ctx.fill();
    }
}

class Game {
    constructor() {
        this.canvas = document.getElementById('gameCanvas');
        this.ctx = this.canvas.getContext('2d');
        // Match CSS (600x650)
        this.canvas.width = 600;
        this.canvas.height = 630;

        this.input = new Input();
        this.resetGame();

        this.initListeners();
        this.loop();
    }

    countPellets() {
        let left = 0;
        for (let r = 0; r < ROWS; r++)
            for (let c = 0; c < COLS; c++)
                if (this.map[r][c] === 2) left++;
        return left;
    }

    startPlaying() {
        this.gameState = 'PLAYING';
        this.updateUI('hud');
        this.startTimer();
    }

    isWall(x, y) {
        if (x < 0 || x >= COLS || y < 0 || y >= ROWS) return true;
        return this.map[y][x] === 1;
    }

    resetGame() {
        this.map = JSON.parse(JSON.stringify(MAP_LAYOUT)); // Deep copy
        this.pacman = new Pacman(this);
        this.ghosts = [
            new Ghost(this, '#ff0000', 9, 8), // Red
            new Ghost(this, '#00ffff', 10, 8), // Cyan
            new Ghost(this, '#ffb8ff', 9, 9), // Pink
            new Ghost(this, '#ffb852', 10, 9) // Orange
        ];
        this.score = 0;
        this.gameState = 'MENU';
        this.showingInfo = false;
        this.infoDisplayIndex = 0;
        this.input.nextDir = { x: 0, y: 0 };
        this.startTime = 0;
        this.timerInterval = null;
        try {
            this.highscore = parseInt(localStorage.getItem('pacman_highscore'), 10) || 0;
        } catch (e) {
            this.highscore = 0;
        }
        document.getElementById('score').innerText = '0';
        document.getElementById('timer').innerText = '00:00';
        document.getElementById('highscore').innerText = this.highscore;
    }

    initListeners() {
        document.getElementById('start-btn').addEventListener('click', () => this.startPlaying());

        ['restart-btn', 'replay-btn'].forEach(id => {
            document.getElementById(id).addEventListener('click', () => {
                this.resetGame();
                this.startPlaying();
            });
        });

        document.querySelector('.close-modal').addEventListener('click', () => {
            document.getElementById('info-modal').classList.add('hidden');
            this.showingInfo = false;

            // Tous les gros points mangés : profil débloqué
            if (this.countPellets() === 0) {
                this.gameState = 'VICTORY';
                this.updateUI('victory');
                return;
            }

            this.gameState = 'PLAYING';
            // Teleport Ghosts back to house to avoid instant death
            this.ghosts.forEach(g => { g.x = 9; g.y = 8; g.px = g.x * 30 + 15; g.py = g.y * 30 + 15; });
        });

        window.addEventListener('keydown', e => {
            if (e.key === 'Enter' && this.showingInfo) {
                document.querySelector('.close-modal').click();
            }
        });
    }

    updateUI(screen) {
        document.querySelectorAll('.screen').forEach(s => s.classList.add('hidden'));
        document.getElementById('hud').classList.add('hidden');
        document.getElementById('mobile-controls').classList.add('hidden');

        if (screen === 'hud') {
            document.getElementById('hud').classList.remove('hidden');
            if ('ontouchstart' in window || navigator.maxTouchPoints > 0) {
                document.getElementById('mobile-controls').classList.remove('hidden');
            }
        }
        else if (screen === 'menu') document.getElementById('start-screen').classList.remove('hidden');
        else if (screen === 'victory') {
            document.getElementById('victory-screen').classList.remove('hidden');
            this.stopTimer();
            this.checkHighScore();
        }
        else if (screen === 'gameover') {
            document.getElementById('game-over-screen').classList.remove('hidden');
            this.stopTimer();
        }
    }

    startTimer() {
        this.startTime = Date.now();
        if (this.timerInterval) clearInterval(this.timerInterval);
        this.timerInterval = setInterval(() => {
            const now = Date.now();
            const elapsed = now - this.startTime;
            const minutes = Math.floor(elapsed / 60000).toString().padStart(2, '0');
            const seconds = Math.floor((elapsed % 60000) / 1000).toString().padStart(2, '0');
            document.getElementById('timer').innerText = `${minutes}:${seconds}`;
        }, 1000);
    }

    stopTimer() {
        clearInterval(this.timerInterval);
    }

    checkHighScore() {
        if (this.score > this.highscore) {
            this.highscore = this.score;
            try {
                localStorage.setItem('pacman_highscore', this.highscore);
            } catch (e) { /* stockage indisponible */ }
            document.getElementById('highscore').innerText = this.highscore;
        }
    }

    loop() {
        this.update();
        this.draw();
        requestAnimationFrame(() => this.loop());
    }

    update() {
        if (this.gameState !== 'PLAYING') return;
        if (this.showingInfo) return;

        this.pacman.update(this.input.nextDir);
        this.ghosts.forEach(g => g.update());

        // Collisions
        // Dots
        if (this.map[this.pacman.y][this.pacman.x] === 0) {
            this.map[this.pacman.y][this.pacman.x] = 9; // Empty
            this.score += 10;
        } else if (this.map[this.pacman.y][this.pacman.x] === 2) {
            // POWER PELLET
            this.map[this.pacman.y][this.pacman.x] = 9;
            this.score += 50;
            this.showCVInfo();
        }

        document.getElementById('score').innerText = this.score;
        if (this.showingInfo) return;

        // Ghost Collision
        const caught = this.ghosts.some(g => Math.hypot(this.pacman.px - g.px, this.pacman.py - g.py) < TILE_SIZE);
        if (caught) {
            this.gameState = 'GAMEOVER';
            this.updateUI('gameover');
            this.checkHighScore();
        }
    }

    showCVInfo() {
        this.showingInfo = true; // Pause

        const total = MAP_LAYOUT.flat().filter(cell => cell === 2).length;
        const info = CV_DATA[this.infoDisplayIndex % CV_DATA.length];
        this.infoDisplayIndex++;

        document.getElementById('info-modal').classList.remove('hidden');
        document.getElementById('modal-title').innerText = info.title;
        document.getElementById('modal-desc').innerHTML = info.desc;
        document.getElementById('modal-progress').innerText = `${this.infoDisplayIndex} / ${total}`;
    }

    draw() {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

        // Draw Map
        for (let y = 0; y < ROWS; y++) {
            for (let x = 0; x < COLS; x++) {
                const cell = this.map[y][x];
                const px = x * TILE_SIZE;
                const py = y * TILE_SIZE;

                if (cell === 1) {
                    // Wall
                    this.ctx.fillStyle = '#100020'; // Dark fill
                    this.ctx.fillRect(px, py, TILE_SIZE, TILE_SIZE);
                    // Neon Border
                    this.ctx.strokeStyle = '#8b6cff';
                    this.ctx.lineWidth = 1;
                    this.ctx.strokeRect(px + 4, py + 4, TILE_SIZE - 8, TILE_SIZE - 8);

                    // Box shadow effect simulated
                    this.ctx.shadowBlur = 5;
                    this.ctx.shadowColor = '#ff4d94';
                    this.ctx.strokeRect(px + 4, py + 4, TILE_SIZE - 8, TILE_SIZE - 8);
                    this.ctx.shadowBlur = 0;

                } else if (cell === 0) {
                    // Dot
                    this.ctx.fillStyle = '#e0b0ff';
                    this.ctx.beginPath();
                    this.ctx.arc(px + TILE_SIZE / 2, py + TILE_SIZE / 2, 2, 0, Math.PI * 2);
                    this.ctx.fill();
                } else if (cell === 2) {
                    // Power Pellet
                    this.ctx.fillStyle = '#fff';
                    this.ctx.shadowBlur = 10;
                    this.ctx.shadowColor = '#fff';
                    this.ctx.beginPath();
                    this.ctx.arc(px + TILE_SIZE / 2, py + TILE_SIZE / 2, 6, 0, Math.PI * 2);
                    this.ctx.fill();
                    this.ctx.shadowBlur = 0;
                }
            }
        }

        this.pacman.draw(this.ctx);
        this.ghosts.forEach(g => g.draw(this.ctx));
    }
}

window.onload = () => { window.pacProfil = new Game(); };
