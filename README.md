# Ruby Arena version BETA 1.0.7

To support this games development, you can buy it here for your choice
of price: https://gumpnerd.itch.io/ruby-arena

This is a Roguelike text adventure game I have made while teaching myself Ruby.
This game is in active development.

The Beta version is now available, which means all core systems are completed.
More content, formatting and stuff is now being added to the game. It is Now
in a playable state with all the core stuff.

 If you have Ruby installed, run the name by starting launch.rb

 If you don't have Ruby, Run the game with the RubyArena.exe file in the Compiled
 folder.

 Screenshots: https://imgur.com/gallery/Z8P1mB6

 BETA Versions updates and fixes:

    BETA 1.0.7-d
    - I need to test these new builds before pushing them
    - hotfix for nil return on extra enemy spawn

    BETA 1.0.7-c
    - hotfix for enemy 0 spawning from item bag traps

    BETA 1.0.7-b
    - Droprate adjustment for jewels (lower)
    - Price fixing for jewels
    - Increased Item Bag spawn rate

    BETA 1.0.7
    - added file verification checking when loading a saved game
    - exposed game cheats in build_cmds.txt which are used for testing (see github)
    - New enemy: Item Bags. Usually enemies will use Item Bags to set traps
    - Added new area: Swamp (accessible at level 5)
    - Forest now has a level cap for enemies and will only spawn up to a certain levels
    - Swamp spawns higher level monsters, spirits and item bags
    - Forest spawns lower level monsters and item bags
    - buffed attack power for various higher level enemies

    BETA 1.0.6.hotfix.a
    - fixes display error when finding jewels on a hard to get roll option

    BETA 1.0.6
    - formatting changes on some strings
    - added some new usable items (jewels) which can be dropped by all enemies
    - jewels permanently increase stats when used
    - fixed a bug where trying to cast spells from battle and not knowing any would crash the game

    BETA 1.0.5
    - lots of rebalancing (enemies, items, spells)
    - added a couple new weapons and armor
    - Game now restarts when player gets a game over instead of exiting
    - improved text formatting in various instances


    BETA 1.0.4
    - fixed bug where having only a 1 handed weapon in your right hand caused an error
    - level-tree is now expanded, all races can get up to level 20
    - all races now have different exp requirements to level up
    - dwarfs are easiest to level, humans mid range, elves hardest
    - new spells added, Mega Heal, Tsunami, Deathknell
    - colorized Weapon, Armor and Item sub menus (status screen)
    - colorized Item sub menu (battle screen)
    - colorized spell selection menu

    BETA 1.0.3
    - added more enemies and arena bosses
    - added more badge levels; arena now has 5 completed levels
    - added more logic to shops and fixed a sell exploit
    - did a bunch of balancing of enemy stats

    BETA 1.0.2:
    - fixed error obtaining new badges beyond 2nd badge

    BETA 1.0.1:
    - initial stable release with all core functions

Bug reporting: If you find a bug, please report it under Issues and I'll take a look.
Please include your player and world save files if they are relevant to the bug you've
found. both the save files are currently unencrypted as this game is a beta.



 in progress (not ordered):
  - addition of more arena bosses
  - formatting various screens to look prettier
  - adding more areas
  - adding npcs to describe things in world (how to hunt and level, tips etc)
  - adding of basic quests (such as kill x mob for reward)
  - adding of method to get currently hidden stat view items

completed:
  - arena badges and earning system
  - arena battles
  - figured out compiling and added precompiled version
  - difficulty rating for battles
  - arena badges
  - tavern functions as an inn
  - common items shop
  - armor shop
  - weapons shop
  - spell usage (for enemies)
  - item usage in battle
  - enemy item drops
  - spell usage and logic (for players, in or out of battle)
  - item system
  - equipment system
  - battle system
  - Forest: mob finding system
  - save/load system
  - player stats
  - background logic for various things i.e. equipping and unequipping items


  Humans:
   - well rounded
   - weak magic user (magic spells are 10% less effective)

  Dwarves:
   - no mp, cant use spells
   - higher attack and defense
   - lower speed
   - higher hp
   - weak to magic (take 10% more magic damage)
   - strong attacker (physical attacks are 10% more effective)

  Elves:
   - higher mp, lower hp
   - lower attack, lower defense
   - higher speed
   - resistant to magic (take 20% less magic damage)
   - weak attacker (physical attacks are 10% less effective)
