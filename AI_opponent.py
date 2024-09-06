#ambikam2
#Analyse frequency and pattern of left opponents attacks to modify own block (down arrow) and attacks
pip install pygame
pip install scikit-learn

# Initialize Pygame
import pygame
pygame.init()

# Set display dimensions
WIDTH, HEIGHT = 640, 480
screen = pygame.display.set_mode((WIDTH, HEIGHT))

# Set title
pygame.display.set_caption("Key Press Counter")

# Define colors
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)

# Font for displaying text
font = pygame.font.Font(None, 74)

# Initialize counters
w_count = 0
one_count = 0

# Define function to display counts
def display_counts():
    screen.fill(WHITE)  # Fill screen with white background

    # Render text for W count
    w_text = font.render(f"W Count: {w_count}", True, BLACK)
    screen.blit(w_text, (50, 100))

    # Render text for 1 count
    one_text = font.render(f"1 Count: {one_count}", True, BLACK)
    screen.blit(one_text, (50, 200))

    pygame.display.flip()  # Update the display

# Run game loop
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

        # Check for key presses
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_w:  # 'W' key pressed
                w_count += 1
            if event.key == pygame.K_1:  # '1' key pressed
                one_count += 1

    # Update the display with the counts
    display_counts()

# Quit Pygame
pygame.quit()
