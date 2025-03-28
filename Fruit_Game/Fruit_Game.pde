import java.awt.Rectangle;

Player player;
Enemy enemy;
boolean gameOver = false;

void setup() {
  fullScreen();
  player = new Player(width / 4, height - 150);
  enemy = new Enemy(width * 3 / 4, height - 150);
}

void draw() {
  background(100);

  if (!gameOver) {
    player.update();
    enemy.update();
    player.display();
    enemy.display();

    checkCollisions();
    displayHealthBars();
  } else {
    textSize(64);
    fill(255, 0, 0);
    textAlign(CENTER);
    text((player.health <= 0 ? "Enemy Wins!" : "Player Wins!"), width / 2, height / 2);
  }
}

void checkCollisions() {
  if (player.isAttacking && player.getAttackBounds().intersects(enemy.getBounds())) {
    enemy.health -= 10;
    player.isAttacking = false;  // Disable attack after hit
  }

  if (enemy.isAttacking && enemy.getAttackBounds().intersects(player.getBounds())) {
    player.health -= 10;
    enemy.isAttacking = false;  // Disable attack after hit
  }

  if (player.health <= 0 || enemy.health <= 0) {
    gameOver = true;
  }
}

void displayHealthBars() {
  fill(255, 0, 0);
  rect(50, 50, player.health * 2, 30);
  rect(width - 250, 50, enemy.health * 2, 30);
}

void keyPressed() {
  if (key == 'a') player.moveLeft = true;
  if (key == 'd') player.moveRight = true;
  if (key == 'w') player.jump();
  if (key == 'f') player.attack();
}

void keyReleased() {
  if (key == 'a') player.moveLeft = false;
  if (key == 'd') player.moveRight = false;
}

// --- Player Class ---
class Player {
  float x, y, speed = 5, gravity = 1, velocityY = 0;
  boolean moveLeft, moveRight, isJumping, isAttacking;
  int health = 100;
  int attackTimer = 0;
  int attackDirection = 1; // 1 for right, -1 for left

  Player(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    if (moveLeft) {
      x -= speed;
      if (!isAttacking) attackDirection = -1;
    }
    if (moveRight) {
      x += speed;
      if (!isAttacking) attackDirection = 1;
    }

    // Gravity
    if (isJumping) {
      velocityY += gravity;
      y += velocityY;
      if (y >= height - 150) {
        y = height - 150;
        isJumping = false;
      }
    }

    if (isAttacking) {
      attackTimer--;
      if (attackTimer <= 0) {
        isAttacking = false;
      }
    }
  }

  void jump() {
    if (!isJumping) {
      isJumping = true;
      velocityY = -18;
    }
  }

  void attack() {
    if (!isAttacking) {
      isAttacking = true;
      attackTimer = 15; // Attack lasts 15 frames
    }
  }

  Rectangle getBounds() {
    return new Rectangle((int)x, (int)y, 50, 100);
  }

  Rectangle getAttackBounds() {
    return new Rectangle((int)x + attackDirection * (60 + (15 - attackTimer) * 2), (int)y + 20, 40, 20);
  }

  void display() {
    fill(0, 0, 255);
    rect(x, y, 50, 100);

    if (isAttacking) {
      fill(255, 255, 0);
      rect(getAttackBounds().x, getAttackBounds().y, getAttackBounds().width, getAttackBounds().height);
    }
  }
}

// --- Enemy Class ---
class Enemy {
  float x, y, speed = 3;
  int health = 100;
  boolean isAttacking;
  int attackCooldown = 0;
  int attackTimer = 0;
  int attackDirection = 1;

  Enemy(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    // Move towards player if the player is far enough away
    if (dist(x, y, player.x, player.y) > 150) {
      if (x > player.x) {
        x -= speed;
        if (!isAttacking) attackDirection = -1;
      } else {
        x += speed;
        if (!isAttacking) attackDirection = 1;
      }
    } else {
      // Start attacking if close enough to the player and not in cooldown
      if (attackCooldown <= 0 && !isAttacking) {
        attack();
      }
    }

    // Handle attack logic
    if (isAttacking) {
      attackTimer--;
      if (attackTimer <= 0) {
        isAttacking = false;
        attackCooldown = 60; // Cooldown before the next attack
      }
    }

    // Decrease cooldown while it is above 0
    if (attackCooldown > 0) {
      attackCooldown--;
    }
  }

  void attack() {
    isAttacking = true;
    attackTimer = 15; // Enemy attack lasts 15 frames
  }

  Rectangle getBounds() {
    return new Rectangle((int)x, (int)y, 50, 100);
  }

  Rectangle getAttackBounds() {
    // Move the attack hitbox based on the enemy's position and attack direction
    return new Rectangle((int)x + attackDirection * (60 + (15 - attackTimer) * 2), (int)y + 20, 40, 20);
  }

  void display() {
    fill(255, 0, 0);
    rect(x, y, 50, 100);

    // Display attack hitbox only while attacking
    if (isAttacking) {
      fill(255, 100, 100);
      rect(getAttackBounds().x, getAttackBounds().y, getAttackBounds().width, getAttackBounds().height);
    }
  }
}
