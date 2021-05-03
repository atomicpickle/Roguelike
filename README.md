# Ruby Arena version FINAL 0.13

To support this games development, you can buy it here for your choice
of price: https://gumpnerd.itch.io/ruby-arena

This is a Roguelike text adventure game I have made while teaching myself Ruby.
This game is in active development.

This is considered the final version of the game. It is getting some small things
added to it but overall it is considered complete.

If you have Ruby installed, run the name by starting launch.rb If you don't have
Ruby, run the game with the RubyArena.exe file in the Compiled folder.

 Screenshots: https://imgur.com/gallery/Z8P1mB6

 Version updates and fixes:

    FINAL 0.13
      - added autosave on player level up

    FINAL 0.12
      - possible fix for item bag crash

    FINAL 0.1
      - reformatting of various text things
      - spell damage adjustment across the board

    BETA 1.9
      - Enemies now display a text value for their Race instead of a number
      - fixed jewel drop exception where the game didn't reward it sometimes
      - fixed some spelling errors
      - updated weapons and armor shop coloring and format
      - updated how two-handed weapons are displayed in the shop
      - updated main menu layout and coloring
      - updated player status menu, made it easier to read and understand

    BETA 1.8
      - repaired spawn logic that was borked when adding quest mobs forced spawn
      - item drop code has been reviewed, the rare item bag crash SHOULD be fixed

    BETA 1.7
      - adjusted various late game (level 8+) enemies, nerfed HP and some attacks
      - adjusted spell damage heavily, late game spells nerfed
      - updated magic spell animation flash
      - fixed human sword bonus error when a sword was only in your right hand
      - removed left/right hand prompt when equipping a 2 handed weapon
      - forced enemies to spawn if out of level range but needed for a quest

    BETA 1.6
      - fixed sale bug for rare items
      - fixed item use in battle crashing in some instances

    BETA 1.5
      - fixed Rosco's quest not triggering at level 4
      - fixed wrong command printing when entering arena (string id conflict)
      - added new enemies, up to level 14


    BETA 1.5-A
    - fixed Rosco's quest not triggering at level 4
    - fixed wrong command printing when entering arena (string id conflict)
    - this version is not complete, simply adding for the hotfixes.
    - 1.5 will be out later today.

    BETA 1.4
    - added a new quest that can be started at level 5
    - fixed crash where buying an item needed for a quest would raise an exception
    - cleaned up quest debugging text
    - modified layout of quest details screen
    - modified first quest to cap at level 2
    - fixed level checking to allow turning in of quests that are now too low
    - fixed an issue with traps(accidents) where sometimes they did no damage
    - added autosave function in a couple more places

    BETA 1.3
    - quest system added! quests can be taken at the tavern and have a lvl req
      - only 2 quests so far. one below or level 3 and one above 4
      - copy sgame.save over with the exe to make your old save file work
    - fixed item select error when a bonus jewel is found
    - fixed a load check for location file
    - added autosave function to prevent some reloading after certain decisions
    - added a sleep function to prevent players missing important information

    BETA 1.2.2
    - if a fatal crash happens, the game version is now saved to debug.log
    - if a fatal crash happens, player data is now saved to debug.log

    BETA 1.2.1
    - fixed formatting in status menu
    - added missing humans info in game intro

    BETA 1.2
    - fixed crashing issue with selling out of range items
    - damage done to item bags doesn't count towards total damage done
    - added feedback to status screen for new human/elf/dwarf bonuses
    - Elf: Buffed magic atk/def if Staff or Robe equipped (or both)
      - 1 staff or 1 robe equipped: 35% bonus
      - both staff and robe equipped: 60% bonus
    - Dwarf: Buffed attack power if a Lance is equipped
      - Lance equipped: 35% bonus
    - Human: Buffed attack power if one or two swords are equipped
      - 1 sword: 7% bonus
      - 2 swords: 10% bonus

    BETA 1.1.0-c
    - debug.log is now cleared when you launch the game
    - fixed bug where Mega Heal couldn't be cast properly
    - fixed improper speed reporting from Godspeck item
    - fixed yet another enemy spawn related bug

    BETA 1.1.0-b
    - fixed bag ambush spawning no enemy when player level is too high

    BETA 1.1.0
    - fixed traps triggering before a bag ambush
    - fixed hunting results not being visible after hitting a trap
    - modified gameover checking so it happens via the update function
    - added 6th level to the Arena
    - added enemies up to level 12 (4 new enemies)
    - put a soft level based cap on how much you can use jewels

    BETA 1.0.9
    - fixed spelling mistake in intro
    - fixed some spelling mistakes in Arena
    - fixed Final grade being A+ if damage done was 0
    - fixed accidental exit screen trigger from main menu
    - added traps! You can now randomly hit traps in Forest or Swamp
    - added error logs, a debug.log file will be made when playing

    BETA 1.0.8
    - fixed bug where hunting wouldn't reset after moving sometimes
    - fixed bug where sometimes finding a rare item could cause a crash
    - added damage ratio and grade to game over screen

    BETA 1.0.7-f
    - Final final patch for 1.0.7. Its fixed now
    - fixed spawn bug
    - adjusted common/rare item drop chance

    BETA 1.0.7-e
    - Final patch fix for 1.0.7

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
