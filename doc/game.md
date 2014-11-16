# game
Documentation for the X-COM Game object. For all the would-be authors
of save game editor programs. This document covers Version 1.

## Game (object)
The `Game` class is found at `src/main/coffee/state/game.coffee`.

### Loading and Saving
object is translated to a pretty-printed JSON string before saving in the
browser's `localStorage` object. When loading a game, the saved JSON is
provided to the constructor of the `Game` object.

## Game (fields)

### difficulty
The difficulty level of the game. This is selected at the beginning of a
new game and does not change throughout the game.

    Type:   Number
    Valid:  [0..4]

    0   =   Beginner
    1   =   Experienced
    2   =   Veteran
    3   =   Genius
    4   =   Superhuman

Higher numbers indicate stronger and more aggressive aliens.

### nightmare
The Nightmare Scenario. When this flag is set, the player has consented
to a completely unfair gameplay experience. Aliens may cheat in order to
make things more difficult. Absolutely anything goes.

* Add a handful of Chryssalids at random spots on the map?
* Disable the flying capability of Flying Suits halfway through the battle?
* Alien Pact USA uses a nuclear weapon to permanently remove an X-COM base?

Sure, it's The Nightmare Scenario. What did you expect? 

    Type:   Boolean
    Valid:  false, true

    false   =   Player expects fair gameplay
    true    =   Player consents to unfair gameplay; let 'em have it

### version
The version of the game object. This is used to provide backward compatibility
with older versions. If an older xcomjs saved a Version 5 game, and then the
game is reloaded into an xcomjs supporting Version 8, the game object can be
migrated forward to the new version.

    Type:   Number
    Valid:  [1..2147483647]
