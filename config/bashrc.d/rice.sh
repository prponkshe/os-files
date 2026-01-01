# Path to your wallpaper folder
WALLPAPER_DIR="$HOME/.config/backgrounds"

# Function to change wallpaper every 5 minutes
change_wallpaper_loop() {
    while true; do
    feh --randomize --bg-fill "$WALLPAPER_DIR"/*
    sleep 300
    done
}
