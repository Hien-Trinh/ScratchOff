# GAS STATION SCRATCH LOTTERY SIMULATOR
Gas Station Scratch Lottery Simulator is a comedic arcade roguelike game made in Godot 4.

**Issue Tracking:** We track all known bugs, glitches, and planned features using GitHub Issues. Currently, there are no major known bugs. One thing to note is that the game currently does not support save/load functionality, so if you close the game, you will lose all progress.

## How to Play
- **Scratch Phase:** Buy scratch cards from the shop, scratch them at the table to reveal symbols, and cash them in to see if you won!
- **Shop Phase:** Use the shop menu to purchase new cards and upgrades. When the round starts, the purchased cards will appear on the table and you can scratch them.
- **Win Condition:** Earn enough money to pay the interest, or else...

### FAQ
- **How do I scratch a card?** Use the right click mouse button over the foil to scratch the card.
- **How do I collect my winnings?** Drag the scratched card to the "CASH IN" mat and number go UP.
- **How do I win?** Earn enough money to pay the interest.
- **What happens if I go broke?** You patiently wait for your inevitable doom.

## For Developers (Onboarding & Documentation)

If you know Python, GDScript is very similar, so you should not worry too much. Start by reading the documentation for [Godot](https://docs.godotengine.org/en/stable/). We compartmentalize components such that all developers can work on different parts of the game without much conflict. Feel free to look through the code and get a feel for it. We recommend focusing on one component at a time.

### Project Structure
- `./assets/`: Contains all the assets (i.e. textures, audio, fonts, etc) in the game.
- `./scripts/`: Contains all the scripts (GDScript files) in the game. Each script is a class, and the class name is the same as the file name.
- `./*.tscn`: All the prefab/scenes in the game. A scene is a collection of nodes, and each node is a class, and its class name is the same as the file name.
- `./shaders/`: Contains all the shaders in the game. Mostly from [Godot Shaders](https://godotshaders.com/)
- `./themes/`: Contains all the themes in the game.
- `./project.godot`: Contains the project settings.

### How to install, build, and run

### I want to play the game on Windows or MacOS
1. Download the zip file from the Releases tab on GitHub. Make sure you choose the version that corresponds to your operating system!
2. Extract the zip in your chosen location.
3. Run `gsslsim.exe` (on Windows) or the provided app executable (on macOS).

### I want to edit the game in Godot
1. Clone the repository to your local machine.
2. Download and install [Godot v.4.6.1](https://godotengine.org/download/archive/4.6.1-stable/). We cannot guarantee that the project will be compatible with other versions of Godot 4.
3. Open Godot, click **Import**, and navigate to the `project.godot` file in the cloned repository folder.
4. Once the project is open, you can run the game by clicking the **Play** button in the top right corner of the editor.
5. **Building/Exporting:** You can export the project by navigating to `Project > Export` in Godot. The project uses standard Godot export templates; no special dependencies are required.

## Credits
Created by:
David Trinh
Henry Pedersen
Sam Kennedy
Gunnar Ray

This game was created for COMP225 at Macalester College.
Special thanks to Paul Cantrell and the entire COMP225 Spring 2026 class.
