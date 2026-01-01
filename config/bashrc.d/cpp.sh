comp-command() {
# Check if at least one argument is passed
    if [ "$#" -lt 1 ]; then
        echo "Usage: gen_compile_commands <file1.cpp> <file2.cpp> ..."
        return 1
    fi

    local COMPILE_COMMANDS="compile_commands.json"

    # Start JSON array
    echo "[" > "$COMPILE_COMMANDS"

    # Loop through all provided C++ files
    for file in "$@"; do
        local abs_path
        abs_path=$(realpath "$file")

        local compile_command="g++ -std=c++20 -Wall -Wextra -o /dev/null -c $abs_path"

        {
            echo "  {"
            echo "    \"directory\": \"$(pwd)\","
            echo "    \"command\": \"$compile_command\","
            echo "    \"file\": \"$abs_path\""
            echo "  },"
        } >> "$COMPILE_COMMANDS"
    done

    # Remove last comma and close JSON array properly
    sed -i '$ s/,$//' "$COMPILE_COMMANDS"
    echo "]" >> "$COMPILE_COMMANDS"

    echo "Generated $COMPILE_COMMANDS"
}
