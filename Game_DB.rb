=begin
module commands:
Game_DB.experience_array(id)
- pass level as id to get array of [req, total] exp for that level

Game_DB.level_stats_array(:race, lvl)
- pass :race and lvl to get stats for that lvl.
- pass race to get all lvl stats for that race.
- pass nothing to get full block of all races

Game_DB.enemies_array(id, value)
- pass id and value to get a specific stat value for a specific Enemy
- pass id to get all values for an enemy
- pass nothing to get full block of all enemies

Game_DB.weapons_array(id, value)
- pass id and value to grab specific stat from a weapon
- pass id to get all values for one weapon
- pass nothing to get full block of all weapons

Game_DB.armor_array(id, value)
- pass id and value to grab specific stat from a armor
- pass id to get all values for one armor
- pass nothing to get full block of all armors

Game_DB.items_array(id, value)
- pass id and value to get a specific value from selected item
- pass id to get a specific item
- pass nothing to get full block of all items

Game_DB.spellbook(spellid, value)
- pass id and value to get a specific array value for the selected spell
- pass id to get all data for one spell
- pass nothing to get a full book of all spells

Game_DB.tx(:section, id)
- pass section and id to fetch specific text line

=end
module Game_DB

  @weapons = {}
  @armors = {}
  @items = {}
  @spells = {}
  @enemies = {}
  @experience_reqd = {}
  @experience_reqh = {}
  @experience_reqe = {}
  @level_up_chart = {}
  @level_up_chart[:dwarf] = {}
  @level_up_chart[:human] = {}
  @level_up_chart[:elf] = {}
  @textdb = {}
  @textdb[:intro] = {}
  @textdb[:common] = {}
  @textdb[:cmd] = {}
  @textdb[:battle] = {}
  @textdb[:badges] = {}
  @textdb[:other] = {}

  def populate_database
    populate_weapons_db
    populate_armor_db
    populate_items_db
    populate_spells_db
    populate_enemies_db
    populate_experience_req_db
    populate_level_up_chart_db
    populate_text_db
  end

  def populate_text_db
   #@textdb[:area][id] = ["String"]
    @textdb[:intro][0] = " Welcome to Ruby Arena, a small roguelike text adventure. \n Begin by choosing your race and name..."
    @textdb[:intro][1] = ["1: Dwarf - no magic, hits hard. slower."]
    @textdb[:intro][2] = ["2: Human -  well rounded, can hit and use magic"]
    @textdb[:intro][3] = ["3: Elf -  primary magic user. faster. Take less magic damage."]
    @textdb[:intro][4] = " Type your name (Maximum 20 characters, may have spaces)"
    @textdb[:intro][5] = " Error, invalid name length... Try that again."
    @textdb[:intro][6] = " This world is very unforgiving. Keep that in mind and save\n often. Some things for an adventurer to know: You can stay at\n taverns to heal for the right price. You can equip a one\n handed weapon in each hand... Its time to start your journey through \n Ruby Arena... Wake up!"
    @textdb[:intro][7] = " You wake up on the side of town square. Your head hurts. \n Your whole body hurts. You have no recent memory of how you \n got here. You stand up, foggy and in pain, and look around."
    @textdb[:intro][8] = "
                  DWARF:
                   - no mp, cant use spells
                   - higher attack and defense
                   - lower speed
                   - higher hp
                   - weak to magic (take 10% more magic damage)
                   - strong attacker (physical attacks are 10% more effective)

                  HUMAN:
                    - well rounded
                    - weak magic user (magic spells are 10% less effective)

                  ELF:
                   - higher mp, lower hp
                   - lower attack, lower defense
                   - higher speed
                   - resistant to magic (take 20% less magic damage)
                   - weak attacker (physical attacks are 10% less effective)"

    @textdb[:common][0]  = " You are standing in the middle of Draclix City. The city is \n bustling with activity all around you."
    @textdb[:common][1]  = " To your NORTH, you notice a large Arena. A large banner    \n reads 'ARENA: FIGHT TO THE DEATH! PROVE YOUR WORTH! GET RICH!'"
    @textdb[:common][2]  = " To your WEST, you notice a large tavern that appears to be \n quite busy. A few drunk patrons lean against the taverns walls."
    @textdb[:common][3]  = " To your EAST, you notice a large marketplace. It seems you   \n can buy almost anything within these shops."
    @textdb[:common][4]  = " To your SOUTH is the town exit, you see Surgalic Forest.  \n various sounds come from Surgalic Forest which gives you some    \n various forms of anxiety."

    @textdb[:common][5]  = " You are standing in Surgalic Forest. The deeper you go, the more \n strange the sounds get. Surely if you venture in, you will \n find something you can kill, or something that will eat you."
    @textdb[:common][6]  = " To your NORTH, you see the city gates and the entrance to  \n Dracilix City. A Sentinal stares at you from the gates."
    @textdb[:common][110]= " To your WEST, you see a massive swamp. A sign in front of a \n narrow trail leading in reads 'Modove Swamp'. "
    @textdb[:common][7]  = " All other directions seemed covered in overgrowth. Will you \n (L)ook (A)round the Forest, or go NORTH back to the city?"
    @textdb[:common][109]= " "

    @textdb[:common][8]  = " You stand at the entrance to the Arena. An angry looking man \n guards the main entrance. He takes one look at you, and motions\n you forward. He stops you and says 'show Badge! No Badge, no\n enter!' Not having any badges, you walk away..."
    @textdb[:common][101]= " You stand at the entrance to the Arena. An angry looking man \n guards the main entrance. He takes one look at you, and motions\n you forward. He stops you and says 'show Badge! No Badge, no\n enter!' You show him your Badges. He smiles, and motions you\n inside."
    @textdb[:common][102]= " You are in the Arena Front Hall. A Lady behind a counter and \n glass motions you forward. 'Hey buddy, you can only fight on the level'\n 'that you are qualified for. Let me see your badges.'\n After showing her your badges, she points you to a short hall\n that leads to a fighting pit. A crowd can be heard mingling."
    @textdb[:common][107]= " You stand at the edge of the fighting pit. A crowd of patrons\n cheer from the stands, atop a stone wall surrounding the pit."
    @textdb[:common][103]= " To your SOUTH is the Arena entrance and Front Hall."
    @textdb[:common][104]= " Step Forward into the fighting pit to begin combat."
    @textdb[:common][108]= " Step Forward into the hall to approach the fighting pit."
    @textdb[:common][106]= " To your SOUTH is the Arena Entrance."
    @textdb[:common][105]= " To your NORTH is the Arena Hall."
    @textdb[:common][9]  = " To your SOUTH is the center of Dracilix City."

    @textdb[:common][10] = " You make your way through some dense Brush, barely any sunlight \n pierces the thick canopy of the forest. You hear something. \n Continue to (L)ook (A)round or select a target."
    @textdb[:common][11] = " You walk into the Tavern. The Bartender Greets you."
    @textdb[:common][12] = " To your EAST is the center of Dracilix City."

    @textdb[:common][13] = " You enter the marketplace. It is bustling with activity. Around \n you are a series of open shops. You can buy Items, Weapons \n and Armor here. You can also sell extra items here."
    @textdb[:common][14] = " To your WEST is the center of Dracilix City."
    @textdb[:common][15] = ["(3) Enter the Weapons shop"]
    @textdb[:common][16] = ["(4) Enter the Armor shop"]
    @textdb[:common][17] = ["(5) Enter the Commons shop"]
    @textdb[:common][18] = " You enter the Weapons shop. A large man wearing only pants and \n suspenders stares at you. He motions you to his counter."
    @textdb[:common][19] = " As you walk into the Armor shop, you see various items on display.\n A large man wearing too many layers of clothing and smelling \n like manure greets you with a big smile."
    @textdb[:common][20] = " You open the door to the Commons shop and walk in. A very old man \n with a large grey beard and no other hair to speak of greets \n you from behind his counter."
    @textdb[:common][21] = " SHOP ITEMS:"
    @textdb[:common][22] = " Select an item to buy, choose number, or (0) to cancel."
    @textdb[:common][23] = " Select an item to sell, choose number, or (0) to cancel."

    @textdb[:common][24] = " You enter Modove Swamp. The stench of the swamp is extremely \n overwhelming. You cover your nose and look around. Your eyes start\n to sting a little from contact with the air around you.\n Many unusual sounds come from the swamp. This place is starting\n to trigger your fight or flight response."
    @textdb[:common][25] = " To your EAST, you see a trail leading to Surgalic Forest."
    @textdb[:common][26] = " All other directions seem to be swampland. Will you leave this\n place, or (L)ook (A)round?"
    @textdb[:common][27] = " You make your way through the swamp. a fog envelopes you and \n chirps and howls can be heard in all directions... You definitely\n hear something close by. (L)ook (A)round or select a target."

    @textdb[:common][28] = " SLICE!!!! Ouch! While wandering in the forest you scratched \n yourself on a large branch!"
    @textdb[:common][29] = " SPLASH!!! THUD!!! Ouch! While slogging through the swamp, \n your foot gets stuck in some mud. You fall down into the\n water and smack your head on a log!"

    @textdb[:cmd][0] = ["(N)orth"]
    @textdb[:cmd][1] = ["(W)est"]
    @textdb[:cmd][2] = ["(E)ast"]
    @textdb[:cmd][3] = ["(S)outh"]

    @textdb[:cmd][28] = ["(2) Step (F)orward"]

    @textdb[:cmd][4] = ["(1) Buy"]
    @textdb[:cmd][5] = ["(2) Sell"]
    @textdb[:cmd][103] = ["(3) Exit"]

    @textdb[:cmd][6] = ["(L)ook (A)round"]

    @textdb[:cmd][7]  = ["(1) Menu"]
    @textdb[:cmd][8]  = "(1) PLAYER STATUS"
    @textdb[:cmd][9]  = "  (2) INVENTORY"
    @textdb[:cmd][10] = "    (3) SPELLS"
    @textdb[:cmd][11] = "      (4) BACK TO GAME"
    @textdb[:cmd][12] = "        (5) SAVE GAME"
    @textdb[:cmd][13] = "          (X) EXIT GAME"
    @textdb[:cmd][101]= ["(1) Use"]
    @textdb[:cmd][102]= ["(2) Back"]

    @textdb[:cmd][14] = ["(N) New Game"]
    @textdb[:cmd][15] = ["(L) Load Game"]
    @textdb[:cmd][104]= ["(E) Exit + View Credits"]
    @textdb[:cmd][16] = ["(1) Yes"]
    @textdb[:cmd][17] = ["(2) No"]

    @textdb[:cmd][18] = ["(1) Weapons"]
    @textdb[:cmd][19] = ["(2) Armor"]
    @textdb[:cmd][20] = ["(3) Items"]
    @textdb[:cmd][21] = ["(1) Equip"]
    @textdb[:cmd][22] = ["(2) Unequip"]
    @textdb[:cmd][23] = ["(1) Left Hand"]
    @textdb[:cmd][24] = ["(2) Right Hand"]
    @textdb[:cmd][25] = ["(1) Use Item"]
    @textdb[:cmd][26] = ["(4) Back"]

    @textdb[:cmd][27] = ["(2) Rent Room"]

    @textdb[:battle][6] = ["(A)ttack"]
    @textdb[:battle][7] = ["(S)pell"]
    @textdb[:battle][8] = ["(I)tem"]
    @textdb[:battle][9] = ["(R)un"]
    @textdb[:battle][0] = "ACTIVE BATTLE: IN THE WILD                                          "
    @textdb[:battle][1] = "                     ACTIVE BATTLE: ARENA"
    @textdb[:battle][2] = "DIFFICULTY: EASY"
    @textdb[:battle][3] = "DIFFICULTY: MEDIUM"
    @textdb[:battle][4] = "DIFFICULTY: HARD"

    @textdb[:badges][0] = '<{^}>'
    @textdb[:badges][1] = '<{1}>'
    @textdb[:badges][2] = '<{2}>'
    @textdb[:badges][3] = '<{3}>'
    @textdb[:badges][4] = '<{4}>'
    @textdb[:badges][5] = '<{5}>'
    @textdb[:badges][6] = '<{6}>'
    @textdb[:badges][7] = '<{7}>'
    @textdb[:badges][8] = '<{8}>'
    @textdb[:badges][9] = '<{9}>'
    @textdb[:badges][10]= '<{#}>'

    @textdb[:other][0] = "\n"
    @textdb[:other][1] = " This is your game menu. You can access stuff and things from here."
    @textdb[:other][2] = " This screen shows your detailed player stats."
    @textdb[:other][3] = " Press <ENTER> to return to the previous screen."
    @textdb[:other][4] = " ARE YOU SURE YOU WANT TO EXIT THE GAME? UNSAVED PROGRESS WILL BE LOST!"
    @textdb[:other][5] = "========================================================================================"
    @textdb[:other][6] = " Are you sure you want to Save? your old save will be overwritten."
    @textdb[:other][7] = " Press <ENTER> to continue... "
    @textdb[:other][8] = " Game Saved."
    @textdb[:other][9] = " Load your saved game?"
    @textdb[:other][10]= " Game loaded."
    @textdb[:other][11]= "███████████████████████████████████████████████████████████████████████████"
    @textdb[:other][13]= ""
    @textdb[:other][14]= "                    ▄████  ▄▄▄       ███▄ ▄███▓▓█████
                   ██▒ ▀█▒▒████▄    ▓██▒▀█▀ ██▒▓█   ▀
                  ▒██░▄▄▄░▒██  ▀█▄  ▓██    ▓██░▒███
                  ░▓█  ██▓░██▄▄▄▄██ ▒██    ▒██ ▒▓█  ▄
                  ░▒▓███▀▒ ▓█   ▓██▒▒██▒   ░██▒░▒████▒
                   ░▒   ▒  ▒▒   ▓▒█░░ ▒░   ░  ░░░ ▒░ ░
                    ░   ░   ▒   ▒▒ ░░  ░      ░ ░ ░  ░
                  ░ ░   ░   ░   ▒   ░      ░      ░
                        ░       ░  ░       ░      ░  ░

                   ▒█████   ██▒   █▓▓█████  ██▀███
                  ▒██▒  ██▒▓██░   █▒▓█   ▀ ▓██ ▒ ██▒
                  ▒██░  ██▒ ▓██  █▒░▒███   ▓██ ░▄█ ▒
                  ▒██   ██░  ▒██ █░░▒▓█  ▄ ▒██▀▀█▄
                  ░ ████▓▒░   ▒▀█░  ░▒████▒░██▓ ▒██▒
                  ░ ▒░▒░▒░    ░ ▐░  ░░ ▒░ ░░ ▒▓ ░▒▓░
                    ░ ▒ ▒░    ░ ░░   ░ ░  ░  ░▒ ░ ▒░
                  ░ ░ ░ ▒       ░░     ░     ░░   ░
                      ░ ░        ░     ░  ░   ░
                                ░                     "

    @textdb[:other][15]= "                ▓██   ██▓ ▒█████   █    ██     █     █░ ██▓ ███▄    █
                 ▒██  ██▒▒██▒  ██▒ ██  ▓██▒   ▓█░ █ ░█░▓██▒ ██ ▀█   █
                  ▒██ ██░▒██░  ██▒▓██  ▒██░   ▒█░ █ ░█ ▒██▒▓██  ▀█ ██▒
                  ░ ▐██▓░▒██   ██░▓▓█  ░██░   ░█░ █ ░█ ░██░▓██▒  ▐▌██▒
                  ░ ██▒▓░░ ████▓▒░▒▒█████▓    ░░██▒██▓ ░██░▒██░   ▓██░
                   ██▒▒▒ ░ ▒░▒░▒░ ░▒▓▒ ▒ ▒    ░ ▓░▒ ▒  ░▓  ░ ▒░   ▒ ▒
                 ▓██ ░▒░   ░ ▒ ▒░ ░░▒░ ░ ░      ▒ ░ ░   ▒ ░░ ░░   ░ ▒░
                 ▒ ▒ ░░  ░ ░ ░ ▒   ░░░ ░ ░      ░   ░   ▒ ░   ░   ░ ░
                 ░ ░         ░ ░     ░            ░     ░           ░
                 ░ ░                                                  "
    @textdb[:other][16]= "
           ▄████████ ███    █▄  ▀█████████▄  ▄██   ▄
          ███    ███ ███    ███   ███    ███ ███   ██▄
          ███    ███ ███    ███   ███    ███ ███▄▄▄███
         ▄███▄▄▄▄██▀ ███    ███  ▄███▄▄▄██▀  ▀▀▀▀▀▀███
        ▀▀███▀▀▀▀▀   ███    ███ ▀▀███▀▀▀██▄  ▄██   ███
        ▀███████████ ███    ███   ███    ██▄ ███   ███
          ███    ███ ███    ███   ███    ███ ███   ███
          ███    ███ ████████▀  ▄█████████▀   ▀█████▀
          ███    ███                                                   "
    @textdb[:other][17]= "              ▄████████    ▄████████    ▄████████ ███▄▄▄▄      ▄████████
              ███    ███   ███    ███   ███    ███ ███▀▀▀██▄   ███    ███
              ███    ███   ███    ███   ███    █▀  ███   ███   ███    ███
              ███    ███  ▄███▄▄▄▄██▀  ▄███▄▄▄     ███   ███   ███    ███
            ▀███████████ ▀▀███▀▀▀▀▀   ▀▀███▀▀▀     ███   ███ ▀███████████
              ███    ███ ▀███████████   ███    █▄  ███   ███   ███    ███
              ███    ███   ███    ███   ███    ███ ███   ███   ███    ███
              ███    █▀    ███    ███   ██████████  ▀█   █▀    ███    █▀
                           ███    ███                                     "
    @textdb[:other][18]= "     ██▀███   █    ██  ▄▄▄▄ ▓██   ██▓
    ▓██ ▒ ██▒ ██  ▓██▒▓█████▄▒██  ██▒
    ▓██ ░▄█ ▒▓██  ▒██░▒██▒ ▄██▒██ ██░
    ▒██▀▀█▄  ▓▓█  ░██░▒██░█▀  ░ ▐██▓░
    ░██▓ ▒██▒▒▒█████▓ ░▓█  ▀█▓░ ██▒▓░
    ░ ▒▓ ░▒▓░░▒▓▒ ▒ ▒ ░▒▓███▀▒ ██▒▒▒
      ░▒ ░ ▒░░░▒░ ░ ░ ▒░▒   ░▓██ ░▒░
      ░░   ░  ░░░ ░ ░  ░    ░▒ ▒ ░░
       ░        ░      ░     ░ ░
                            ░░ ░                   "
    @textdb[:other][19]= "     ▄▄▄       ██▀███  ▓█████  ███▄    █  ▄▄▄
    ▒████▄    ▓██ ▒ ██▒▓█   ▀  ██ ▀█   █ ▒████▄
    ▒██  ▀█▄  ▓██ ░▄█ ▒▒███   ▓██  ▀█ ██▒▒██  ▀█▄
    ░██▄▄▄▄██ ▒██▀▀█▄  ▒▓█  ▄ ▓██▒  ▐▌██▒░██▄▄▄▄██
     ▓█   ▓██▒░██▓ ▒██▒░▒████▒▒██░   ▓██░ ▓█   ▓██▒
     ▒▒   ▓▒█░░ ▒▓ ░▒▓░░░ ▒░ ░░ ▒░   ▒ ▒  ▒▒   ▓▒█░
      ▒   ▒▒ ░  ░▒ ░ ▒░ ░ ░  ░░ ░░   ░ ▒░  ▒   ▒▒ ░
      ░   ▒     ░░   ░    ░      ░   ░ ░   ░   ▒
          ░  ░   ░        ░  ░         ░       ░  ░
                                                   "
    @textdb[:other][20]= "                    Credits
          Game Programmed and developed by Matt Sully (@GumpNerd)
          Special Thanks: Teague Hammell
          Special Thanks: _powder_ (reddit.com)
          Special Thanks: Andrek8 (reddit.com)
          Special Thanks: Zaxero
          Special Thanks: Voxnee (twitch.tv)
          Icon Made by 'Good Ware' from www.flaticon.com"
    @textdb[:other][12]= " Version: BETA 1.0.9          Author: Matt Sully(@GumpNerd)"
  end

  def tx(section=nil, id=nil)
    return nil if section == nil
    return @textdb[section] if id == nil
    return @textdb[section][id]
  end

  def clr
    system("cls")
  end

  def battle_diff(plvl, elvl)
    res = elvl - plvl
    base = tx(:battle, 0).dup
    diff = [tx(:battle, 2).dup, tx(:battle, 3).dup, tx(:battle, 4).dup]
    if res < 0
      base << diff[0]
      return base
    elsif res == 0
      base << diff[1]
      return base
    elsif res > 0
      base << diff[2]
      return base
    end
  end

  #returns TRUE if enemy gets first strike, includes RANDOM roll
  def battle_enemy_hit_first(pspd=0, espd=0, id=0)
    enemyspd = espd
    playerspd = pspd
    res = playerspd - enemyspd
    res = 0 if res < 0
    dice = rand(0..100)
    val = false
    if res > 0 #player is faster
      val =  true if dice <= 20
      val =  false if dice > 20
    elsif res == 0 #player and enemy are same speed
      val = false if dice < 50
      val = true if dice >= 50
    else #player is slower
      val =  false if dice <= 30
      val =  true if dice > 30
    end
    return false if id == :t1 || id == :t2 || id == :t3 || id == :t4
    return val
  end

  def calc_spell_damage(range, plvl, edef, elvl, heal=false, prace=:human)
    if heal == false #attack spell
      b1 = plvl - elvl; b1 = 0 if b1 < 0
      sel = rand(range[0]..range[1])
      b2 = rand(1..10)
      res = 0
      if b1 > 0 #player higher level
        en1 = edef * 0.30; en1.to_i
        en2 = rand(0..b2)
        en3 = en1 + en2
        en4 = en3 * 0.60
        if sel > en3
          res = sel - en3
        else
          res = sel - en4
        end
      else # player same or lower level
        en1 = edef * 0.50; en1.to_i
        en2 = rand(0..b2)
        en3 = en1 + en2
        en4 = en3 * 0.60
        if sel > en3
          res = sel - en3
        else
          res = sel - en4
        end
      end
      res = res * 0.90 if res > 1 && prace == :human
      res = 1 if res <= 0
      return res.to_i
    elsif heal == true #heal spell
      lvc = plvl / 2; lvc = 0 if lvc < 0
      rn = rand(0..lvc) if lvc > 0
      rn = 0 if lvc <= 0
      rn2 = rand(range[0]..range[1])
      res = rn2 + rn
      res = res * 0.90 if res > 1 && prace == :human
      return res.to_i
    end
  end

  def calc_enemy_spell_damage(range, plvl, edef, elvl, heal=false, prace=:human)
    if heal == false #attack spell
      b1 = plvl - elvl; b1 = 0 if b1 < 0
      sel = rand(range[0]..range[1])
      b2 = rand(1..10)
      res = 0
      if b1 > 0 #enemy higher level
        en1 = edef * 0.50; en1.to_i
        b2 = rand(1..5) if elvl <= 3
        en2 = rand(0..b2)
        en3 = en1 + en2
        en4 = sel - en3
        en4 *= 0.70 if elvl <= 3
        res = en4 * 0.8; res.to_i
      else # enemy same or lower level
        en1 = edef * 0.60; en1.to_i
        b2 = rand(1..5) if elvl <= 3
        en2 = rand(0..b2)
        en3 = en1 + en2
        en4 = sel - en3
        en4 *= 0.9 if elvl <= 3
        res = en4 * 1.2; res.to_i
      end
      res = 1 if res < 1
      res = res * 0.80 if res > 1 && prace == :elf
      res = res * 1.10 if res > 1 && prace == :dwarf
      return res.to_i
    elsif heal == true #heal spell
      lvc = plvl / 2; lvc = 0 if lvc < 0
      rn = rand(0..lvc) if lvc > 0
      rn = 0 if lvc <= 0
      rn2 = rand(range[0]..range[1])
      res = rn2 + rn
      return res
    end
  end

  #current damage calc formula being used
  def calc_damage_alt2(atk, lvl, defend, lvl2, mob=false, prace=:human)
    base = atk - defend
    base = 1 if base < 1
    if mob == false
      base += rand(0..1) if lvl == 0
      base += rand(0..lvl+2) if lvl == 1
      base += rand(0..lvl+3) if lvl == 2
      base += rand(0..lvl+4) if lvl == 3
      base += rand(0..lvl+5) if lvl == 4
      base += rand(0..lvl+6) if lvl == 5
      base += rand(0..lvl+9) if lvl == 6
      base += rand(0..lvl+13) if lvl == 7
      base += rand(0..lvl+15) if lvl == 8
      base += rand(0..lvl+17) if lvl == 9
      base += rand(0..lvl+21) if lvl == 10
      if lvl >= lvl2
        base += rand(0..15) if lvl > lvl2
        base += rand(0..5) if lvl == lvl2
      end
      base = base *1.1 if base > 1 && prace == :dwarf
      base = base *0.9 if base > 1 && prace == :elf
      return base.to_i
    elsif mob
      if lvl >= lvl2
        base += rand(0..5) if lvl > lvl2
        base += rand(0..2) if lvl == lvl2
      end
    end
    return base
  end


  #alt: DMG = ATK^2 / (ATK + DEF)
  #old formula, not in use
  def calc_damage_alt(atk, lvl, defend, lvl2, mob=false)
    atksq = atk * 2
    second = atk + defend
    result = atksq / second
    result = rand(1..3) if result < 1
    rand1 = rand(1..100)
    rand2 = rand(1..100)
    rand3 = rand(1..100)
    result += rand(1..5) if rand1 > 75
    result += rand(1..5) if rand2 < 25 unless mob
    result += rand(1..3) if rand3 > 90 unless mob
    result += rand(1..3) if rand3 < 10 unless mob
    return result
  end

  #old formula, not in use
  def calc_damage(atk, lvl, defend, lvl2, mob=false)
    highleveltarget = false
    lowleveltarget = false
    stats = [atk, lvl, defend, lvl2]
    if stats[1] <= stats[3]
      highlvltarget = true
    end
    if stats[1] > stats[3]
      lowleveltarget = true
    end
    mult = rand(1..5)
    dice = rand(1..75)
    dice2 = rand(1..5)
    dice /= mult
    dice2 /= mult
    dice.to_i
    dice2.to_i
    eq = stats[0] - stats[2] + dice2 if highlvltarget == true
    eq = stats[0] - stats[2] + dice if lowleveltarget == true
    eq = 1 if eq < 1
    if mob == false
      eq += 1 if stats[1] >= 1
      eq += 2 if stats[1] >= 3
      eq += 4 if stats[1] >= 5
      eq += 6 if stats[1] >= 7
      eq += 8 if stats[1] >= 9
      eq += 20 if stats[1] == 10
    end
    return eq
  end

  #deprecated... I think?
  def calc_speed(spd, lvl, spd2, lvl2)
    base = spd - spd2
    base = 1 if base < 1
    if lvl > lvl2
      base *= 1.5
      base.to_i
    end
    if lvl < lvl2
      base *= 0.5
      base.to_i
      base = 1 if base < 1
    end
    return base
  end

  #need 0 to 10
  def populate_arena_enemies(badge_string=nil)
    return if badge_string == nil
    enemyids = []
    truekey = -1
    @textdb[:badges].each {|k,v| truekey = k if v == badge_string}
    enemyids.push(:b0, :b1) if truekey == 0
    enemyids.push(:b2, :b3) if truekey == 1
    enemyids.push(:b4, :b5) if truekey == 2
    enemyids.push(:b6, :b7) if truekey == 3
    enemyids.push(:b8, :b9) if truekey == 4
    return enemyids
  end

  def find_next_badge(string)
    truekey = 0
    @textdb[:badges].each {|k,v| truekey = k if v == string}
    truekey += 1
    return @textdb[:badges][truekey-1] if truekey > 10
    return @textdb[:badges][truekey]
  end

  def calculate_go_ratio_grade(ratio=0.0)
    grade = ""
    grade = "A+" if ratio >= 5
    grade = "A" if ratio <= 5 && ratio >= 3.75
    grade = "B" if ratio < 3.75 && ratio >= 2.25
    grade = "C" if ratio < 2.25 && ratio >= 1.25
    grade = "D" if ratio < 1.25 && ratio >= 1
    grade = "F" if ratio < 1
    return grade
  end

  def populate_weapons_db
    #             [Weapon name,              atk, spd, 2hand,  cost]
    @weapons[0] = ["Fists           ",          0,   0, false,      0]
    @weapons[1] = ["Pole            ",          2,   3, false,     10]
    @weapons[2] = ["Wooden-Sword    ",          5,   5, false,     25]
    @weapons[3] = ["Mage-Staff      ",          7,  13,  true,     80]
    @weapons[4] = ["Wooden-Club     ",          9,   5, false,     90]
    @weapons[5] = ["Iron-Hatchet    ",         17,   7, false,    220]
    @weapons[6] = ["Iron-Lance      ",         40,   2,  true,    390]

    @weapons[7] = ["Iron-Sword      ",         34,   8, false,    950]
    @weapons[8] = ["Sage-Staff      ",         25,  26,  true,   1250]
    @weapons[9] = ["Steel-Sword     ",         52,  12, false,   2500]
    @weapons[10]= ["Broadsword      ",        112,   4,  true,   7500]
    @weapons[11]= ["Sword-of-Malice ",         76,  14, false,   9001]
    @weapons[12]= ["Bastard-Sword   ",        136,  15, false,  17500]
  end

  def populate_armor_db
    #            [Armor Name,                def, spd,         cost]
    @armors[0] = ["Underwear       ",          0,   0,            0]
    @armors[1] = ["Cloth-Shirt     ",          1,   3,           10]
    @armors[2] = ["Leather-Armor   ",         12,   4,           90]
    @armors[3]=  ["Mages-Robe      ",          4,  10,          110]
    @armors[4] = ["Chainmail-Armor ",         28,   5,          420]
    @armors[5]=  ["Magikal-Robe    ",         24,  15,         1300]
    @armors[6] = ["Studded-Armor   ",         49,   6,         1500]
    @armors[7] = ["Half-Plate-Armor",         80,   5,         5000]
    @armors[8]=  ["Sages-Robe      ",         54,  32,         7550]
    @armors[9] = ["Full-Plate-Armor",        116,   7,        11000]
    @armors[10]= ["Bastard-Armor   ",        186,  10,        17500]
  end

  def populate_items_db
    #           [Item Name,              +HP,  +MP,  +PHP, +PMP, +PATK, +PDEF,     cost,    Item Description]
    @items[0]  = ["Missingo",               0,    0,     0,    0,     0,     0,        0,    "..."]
    @items[1]  = ["Mugwart-Root",          25,    0,     0,    0,     0,     0,       20,    "Heals +25 HP"]
    @items[2]  = ["Vervain-Flower",         0,   25,     0,    0,     0,     0,       45,    "Heals +25 MP"]
    @items[3]  = ["Rose-Hipp-Potion",     120,    0,     0,    0,     0,     0,       75,    "Heals +120 HP"]
    @items[4]  = ["Wolfsbane-Potion",       0,   80,     0,    0,     0,     0,      120,    "Heals +100 MP"]
    @items[5]  = ["White-Orchid-Potion",  400,    0,     0,    0,     0,     0,      300,    "Heals +400 HP"]
    @items[6]  = ["Night-Shade-Elixer",   500,  250,     0,    0,     0,     0,     1000,    "Heals +500 HP and +250 MP"]

    @items[7]  = ["Angels-Hair",            0,    0,     5,    0,     0,     0,     1500,    "After Use: Permanently increases HP up to -1 to +5"]
    @items[8]  = ["Necromancers-Eye",       0,    0,     0,    5,     0,     0,     1500,    "After Use: Permanently increases MP up to -1 to +5"]
    @items[9]  = ["Dragons-Talon",          0,    0,     0,    0,     6,     0,     2000,    "After Use: Permanently increases ATTACK up to -1 to +6"]
    @items[10] = ["Fairy-Dust",             0,    0,     0,    0,     0,     6,     2000,    "After Use: Permanently increases DEFENSE up to -1 to +6"]
    @items[11] = ["Godspeck",               0,    0,    10,   10,    10,    10,     9001,    "After Use: Permanently increases HP, MP, ATK, DEF and SPEED up to -1 to +10"]

    @items[12] = ["Speed-Reader",           0,    0,     0,    0,     0,     0,    12500,    "After Use: Permanently enables the ability to see your enemies Speed"]
    @items[13] = ["Attack-Reader",          0,    0,     0,    0,     0,     0,    12500,    "After Use: Permanently enables the ability to see your enemies Attack"]
    @items[14] = ["Defense-Reader",         0,    0,     0,    0,     0,     0,    12500,    "After Use: Permanently enables the ability to see your enemies Defense"]
    @items[15] = ["Rewards-Reader",         0,    0,     0,    0,     0,     0,    12500,    "After Use: Permanently enables the ability to see your enemies Rewards"]

    @items[16] = ["...Item16...",           0,    0,     0,    0,     0,     0,     5252,    "..............."]

    @items[17] = ["Earth Jewel",            0,    0,     2,    0,     0,     0,       35,    "After Use: Permanently increases HP up to -1 to +2"]
    @items[18] = ["Moon Jewel",             0,    0,     0,    2,     0,     0,       35,    "After Use: Permanently increases MP up to -1 to +2"]
    @items[19] = ["Fire Jewel",             0,    0,     0,    0,     3,     0,       35,    "After Use: Permanently increases ATTACK up to -1 to +3"]
    @items[20] = ["Dense Jewel",            0,    0,     0,    0,     0,     3,       35,    "After Use: Permanently increases DEFENSE up to -1 to +3"]
  end

  def populate_spells_db
    #            [Spell name,             Heal?,   [Minmax], Cost,   Description]
    @spells[0] = ["Burp!",                false,     [0, 0],    0,   "Drunkely misprounounce the heal spell and cause minor damage"]
    @spells[1] = ["Heal",                  true,    [7, 24],    4,   "Simple healing spell"]
    @spells[2] = ["Greater Heal",          true,  [45, 125],    9,   "Less simple healing spell"]
    @spells[3] = ["Tremor",               false,   [10, 30],    6,   "Sends a tremor out and throws the target"]
    @spells[4] = ["Gust",                 false,   [15, 30],    7,   "A Sharp gust of wind impacts the target"]
    @spells[5] = ["Water Talons",         false,   [15, 40],    9,   "Pull water out of the air into talons and shoot at target"]
    @spells[6] = ["Shock",                false,   [28, 40],    9,   "Electricity shoots from your mouth and strikes"]
    @spells[7] = ["Blizzard",             false,   [32, 86],   12,   "Blizzard swirls up around the target"]
    @spells[8] = ["Fireball",             false,  [75, 125],   16,   "A Fireball pops into existance and strikes"]
    @spells[9] = ["Quake",                false,  [50, 185],   10,   "Earth opens and crushes your target"]
    @spells[10]= ["Hurricane",            false,  [95, 175],   16,   "A Hurricaine hits the target, then disappears"]
    @spells[11]= ["Bolt",                 false, [125, 180],   24,   "Electricity shoots from all of your orifices and strikes"]
    @spells[12]= ["Wall of Fire",         false, [100, 256],   32,   "A Wall of Fire emerges and envelopes everything"]
    @spells[13]= ["Mega Heal",             true, [200, 320],   33,   "Complicated healing spell"]
    @spells[14]= ["Tsunami",              false, [200, 275],   42,   "A massive Tsunami appears out of thin air and drowns the target"]
    @spells[15]= ["Deathknell",           false,   [1, 800],   66,   "The target is either ripped apart, or somewhat damaged by Death himself"]
  end

  def populate_enemies_db #races: ghost(0), dwarf(1), human(2), elf(3), animal(4), demon(5)
    #              #[Enemy name,             race, lvl,  mhp,  mmp,  atk,  def,  spd,   exp,   gold, [drops],drop%,  [spells], sp%]
    @enemies[:g1] = ["Lost Spirit",             0,   0,    1,    3,    0,    0,    5,     4,      0,  [8, 7],    5,    [1, 0],  33]
    @enemies[:g2] = ["Angry Spirit",            0,   5,   56,   24,    9,    5,   99,    20,      2,  [8, 7],   20,    [1, 4],  40]
    @enemies[:g3] = ["Girl From The Ring",      0,   7,  166,   48,   33,   11,   99,    66,      6,  [8, 7],   20,    [1, 8],  40]

    @enemies[:t1] = ["Blue Itembag",            0,   1,    1,    0,    0,    0,    0,     0,      1, [2, 18], 100,     [0, 0],   0]
    @enemies[:t2] = ["Green Itembag",           0,   1,    1,    0,    0,    0,    0,     0,      1, [1, 17], 100,     [0, 0],   0]
    @enemies[:t3] = ["Red Itembag",             0,   1,    1,    0,    0,    0,    0,     0,      1, [1, 19], 100,     [0, 0],   0]
    @enemies[:t4] = ["White Itembag",           0,   1,    1,    0,    0,    0,    0,     0,      1, [1, 20], 100,     [0, 0],   0]

    @enemies[0]  =  ["Emptyness",               0,   0,    1,    0,    0,    0,    0,     0,      0,  [0, 0],    1,    [0, 0],   0]
    @enemies[1]  =  ["Butterfly",               4,   0,    7,    0,    2,    1,    6,     2,      1,  [1, 2],   25,    [0, 0],   0]
    @enemies[2]  =  ["Innocent Rabbit",         4,   1,    8,    0,    3,    1,    7,     3,      3,  [1, 2],   20,    [0, 0],   0]
    @enemies[3]  =  ["Large Rat",               4,   1,    9,    0,    4,    1,    9,     4,      3,  [1, 2],   20,    [0, 0],   0]

    @enemies[4]  =  ["Beautiful Hawk",          4,   2,   15,    0,    8,    3,   10,     7,      9, [1, 17],   10,    [0, 0],   0]
    @enemies[5]  =  ["Blacktail Deer",          4,   2,   18,    0,    8,    4,   12,     9,      5, [1, 18],   10,    [0, 0],   0]

    @enemies[6]  =  ["Adorable Fox",            4,   3,   19,    0,   12,    5,   13,    12,     15, [1, 18],   10,    [0, 0],   0]
    @enemies[7]  =  ["Angry Bird",              4,   3,   22,    0,   16,    7,   14,    18,     22, [1, 19],   15,    [0, 0],   0]

    @enemies[8]  =  ["Blazing Skull",           5,   4,   30,   10,   22,    7,   15,    26,     28, [20,19],   10,    [1, 4],  45]
    @enemies[9]  =  ["Syren",                   5,   4,   34,   16,   25,    9,   16,    34,     35, [17,18],   12,    [1, 5],  45]
    @enemies[10] =  ["Ipotane",                 4,   4,   38,   14,   26,   12,   17,    40,     30, [18,17],   15,    [1, 6],  45]

    @enemies[11] =  ["F**king Tiger",           4,   5,   50,    0,   38,   15,   19,    52,     40,  [3, 9],    8,    [0, 0],   0]
    @enemies[12] =  ["Black Zebra",             4,   5,   58,    0,   37,   20,   20,    42,     75, [3, 17],   10,    [0, 0],   0]

    @enemies[13] =  ["Giant C**t of a Rhino",   4,   6,   92,    0,   44,   36,   22,   110,     35, [20, 9],   10,    [0, 0],   0]
    @enemies[14] =  ["Shortneck Angry Giraffe", 4,   6,  110,    0,   40,   45,   26,    86,    100, [18, 7],   10,    [0, 0],   0]
    @enemies[15] =  ["Longma",                  4,   6,  120,   30,   39,   44,   30,   100,    110, [18, 6],    8,    [2, 7],  40]

    @enemies[16] =  ["Bit-too-Happy Jinn",      5,   7,  152,   42,   60,   52,   35,   186,    165, [19, 7],    9,   [2, 11],  48]
    @enemies[17] =  ["Baby Velociraptor",       4,   7,  156,   14,   64,   50,   38,   144,     90, [9, 20],    7,    [2, 0],  25]
    @enemies[18] =  ["Cute Velociraptor",       4,   7,  188,   22,   69,   58,   40,   224,    204, [9, 10],    6,    [2, 0],  25]

    @enemies[19] =  ["Electric Floating Skull", 5,   8,  196,   70,   81,   56,   32,   300,    225, [18,19],   15,   [2, 11],  40]
    @enemies[20] =  ["F**king Lion",            4,   8,  224,    0,   89,   64,   48,   310,    240, [9, 10],   12,    [0, 0],   0]

    @enemies[21] =  ["Lunatic Vagrant",         2,   9,  275,   56,  109,   86,   54,   375,    360, [3, 19],   15,    [2, 9],  25]
    @enemies[22] =  ["Land Dolphin",            4,   9,  290,   90,  113,   91,   56,   420,    420, [18, 6],   15,   [2, 11],  20]

    @enemies[23] =  ["Psycho Tom",              2,  10,  325,   75,  126,  100,   66,   500,    560, [9, 10],   15,    [2, 8],  25]
    @enemies[24] =  ["Komodo Dragon",           4,  10,  375,    0,  132,  112,   69,   525,    515, [9, 10],   15,    [0, 0],   0]

    #              #[Enemy name,             race, lvl,  mhp,  mmp,  atk,  def,  spd,   exp,   gold, [drops],drop%,  [spells], sp%]

    @enemies[:b0] = ["Rosco the Drunk",         2,   4,  120,   24,   38,   15,   15,   150,    100, [3, 10],   10,    [1, 0],  35]
    @enemies[:b1] = ["Babba-Yagga",             5,   5,  128,   28,   29,   18,   18,   120,    175,  [1, 6],   12,    [1, 6],  35]

    @enemies[:b2] = ["Big Happy Yeti",          4,   6,  244,   30,   49,   48,   32,   355,    500,  [4, 5],   30,    [1, 7],  35]
    @enemies[:b3] = ["Tiny",                    2,   6,  325,    0,   63,   52,   36,   386,    650,  [3, 9],   10,    [0, 0],   0]

    @enemies[:b4] = ["Lana",                    2,   7,  400,   86,   82,   64,   40,   550,   1000, [10, 9],   25,    [2, 6],  40]
    @enemies[:b5] = ["Sexual Harrasment Panda", 4,   7,  430,  108,   87,   70,   40,   625,   1250, [8, 10],   33,    [2, 6],  40]

    @enemies[:b6] = ["Hatchet Patrick",         2,   8,  550,    0,   91,   77,   55,   750,   1500, [10, 9],   25,    [0, 0],   0]
    @enemies[:b7] = ["Royal Mage Jimmy",        2,   8,  585,  175,   98,   80,   50,   775,   1550, [8, 11],   33,    [2, 8],  45]

    @enemies[:b8] = ["Ninja Bob",               2,   9,  850,    0,  124,   90,   60,  1250,   1850,  [7, 9],   25,    [0, 0],   0]
    @enemies[:b9] = ["Angry Lana",              2,   9,  920,  250,  132,  108,   64,  1550,   2050, [8, 11],   33,    [2,11],  30]
  end

  #key for experience_req = level (So experience_req[3] = exp for level 3)
  def populate_experience_req_db
    #                     [amount, total]
    @experience_reqd[0]  = [     0,     0]
    @experience_reqd[1]  = [    14,    14]
    @experience_reqd[2]  = [    40,    54]
    @experience_reqd[3]  = [   106,   160]
    @experience_reqd[4]  = [   214,   374]
    @experience_reqd[5]  = [   406,   780]
    @experience_reqd[6]  = [   664,  1444]
    @experience_reqd[7]  = [   996,  2440]
    @experience_reqd[8]  = [  1044,  3484]
    @experience_reqd[9]  = [  1656,  5140]
    @experience_reqd[10] = [  3004,  8144]
    @experience_reqd[11] = [  4000, 12144]
    @experience_reqd[12] = [  5550, 17694]
    @experience_reqd[13] = [  6250, 23944]
    @experience_reqd[14] = [  7500, 31444]
    @experience_reqd[15] = [  9001, 40445]
    @experience_reqd[16] = [ 11250, 51695]
    @experience_reqd[17] = [ 13500, 65195]
    @experience_reqd[18] = [ 15000, 80195] #
    @experience_reqd[19] = [ 17505, 97700]
    @experience_reqd[20] = [ 24000,121700]
    @experience_reqd[21] =[999999,1121699]

    @experience_reqh[0]  = [     0,     0]
    @experience_reqh[1]  = [    15,    15]
    @experience_reqh[2]  = [    45,    60]
    @experience_reqh[3]  = [   112,   172]
    @experience_reqh[4]  = [   232,   404]
    @experience_reqh[5]  = [   420,   824]
    @experience_reqh[6]  = [   685,  1509]
    @experience_reqh[7]  = [  1075,  2584]
    @experience_reqh[8]  = [  1250,  3834]
    @experience_reqh[9]  = [  1800,  5634]
    @experience_reqh[10] = [  3250,  8884]
    @experience_reqh[11] = [  4300, 13184]
    @experience_reqh[12] = [  5900, 19084]
    @experience_reqh[13] = [  6666, 25750]
    @experience_reqh[14] = [  8000, 33750]
    @experience_reqh[15] = [  9750, 43500]
    @experience_reqh[16] = [ 12750, 56250]
    @experience_reqh[17] = [ 14800, 71050]
    @experience_reqh[18] = [ 17500, 88550]
    @experience_reqh[19] = [ 19000,107550]
    @experience_reqh[20] = [ 28500,136050]
    @experience_reqh[21] =[999999,1121699]

    @experience_reqe[0]  = [     0,     0]
    @experience_reqe[1]  = [    16,    16]
    @experience_reqe[2]  = [    48,    64]
    @experience_reqe[3]  = [   118,   182]
    @experience_reqe[4]  = [   254,   436]
    @experience_reqe[5]  = [   455,   891]
    @experience_reqe[6]  = [   725,  1616]
    @experience_reqe[7]  = [  1150,  2766]
    @experience_reqe[8]  = [  1324,  4090]
    @experience_reqe[9]  = [  1990,  6080]
    @experience_reqe[10] = [  3450,  9530]
    @experience_reqe[11] = [  4500, 14030]
    @experience_reqe[12] = [  6250, 20280]
    @experience_reqe[13] = [  6950, 27230]
    @experience_reqe[14] = [  8420, 35650]
    @experience_reqe[15] = [ 10500, 46150]
    @experience_reqe[16] = [ 13333, 59483]
    @experience_reqe[17] = [ 15507, 74990]
    @experience_reqe[18] = [ 18510, 93500]
    @experience_reqe[19] = [ 20500,114000]
    @experience_reqe[20] = [ 31500,145500]
    @experience_reqe[21] =[999999,1145499]
  end

  #key for level_up_chart = :race, level (So level_up_chart[:dwarf][3] is stats for dwarf level 3)
  def populate_level_up_chart_db
    #  DWARFS                     [ mhp, mmp, atk, def, spd, spell]
    @level_up_chart[:dwarf][0]  = [  16,   0,   2,   1,   1,   nil]
    @level_up_chart[:dwarf][1]  = [  20,   0,   4,   2,   1,   nil]
    @level_up_chart[:dwarf][2]  = [  28,   0,   7,   4,   2,   nil]
    @level_up_chart[:dwarf][3]  = [  38,   0,   9,   6,   2,   nil]
    @level_up_chart[:dwarf][4]  = [  45,   0,  12,   7,   2,   nil]
    @level_up_chart[:dwarf][5]  = [  56,   0,  16,   8,   3,   nil]
    @level_up_chart[:dwarf][6]  = [  72,   0,  19,  11,   3,   nil]
    @level_up_chart[:dwarf][7]  = [  84,   0,  23,  15,   3,   nil]
    @level_up_chart[:dwarf][8]  = [ 106,   0,  25,  19,   3,   nil]
    @level_up_chart[:dwarf][9]  = [ 124,   0,  30,  22,   3,   nil]
    @level_up_chart[:dwarf][10] = [ 154,   0,  38,  28,   4,   nil]
    @level_up_chart[:dwarf][11] = [ 180,   0,  45,  32,   4,   nil]
    @level_up_chart[:dwarf][12] = [ 206,   0,  50,  36,   5,   nil]
    @level_up_chart[:dwarf][13] = [ 240,   0,  54,  42,   5,   nil]
    @level_up_chart[:dwarf][14] = [ 274,   0,  57,  47,   5,   nil]
    @level_up_chart[:dwarf][15] = [ 290,   0,  62,  51,   6,   nil]
    @level_up_chart[:dwarf][16] = [ 316,   0,  64,  54,   6,   nil]
    @level_up_chart[:dwarf][17] = [ 333,   0,  68,  58,   7,   nil]
    @level_up_chart[:dwarf][18] = [ 360,   0,  71,  63,   7,   nil]
    @level_up_chart[:dwarf][19] = [ 394,   0,  75,  66,   7,   nil]
    @level_up_chart[:dwarf][20] = [ 420,   0,  79,  70,   8,   nil]
    #  HUMANS                     [ mhp, mmp, atk, def, spd, spell]
    @level_up_chart[:human][0]  = [  13,   1,   1,   1,   1,   nil]
    @level_up_chart[:human][1]  = [  17,   4,   2,   2,   1,     1]
    @level_up_chart[:human][2]  = [  25,   9,   3,   4,   2,   nil]
    @level_up_chart[:human][3]  = [  30,  14,   4,   5,   2,     3]
    @level_up_chart[:human][4]  = [  39,  19,   5,   5,   3,     2]
    @level_up_chart[:human][5]  = [  48,  27,   7,   6,   3,   nil]
    @level_up_chart[:human][6]  = [  60,  36,  11,   8,   4,     7]
    @level_up_chart[:human][7]  = [  75,  45,  15,  11,   4,   nil]
    @level_up_chart[:human][8]  = [  90,  54,  18,  15,   5,     9]
    @level_up_chart[:human][9]  = [ 112,  66,  22,  18,   5,   nil]
    @level_up_chart[:human][10] = [ 120,  84,  25,  21,   6,    10]
    @level_up_chart[:human][11] = [ 136,  90,  28,  24,   6,   nil]
    @level_up_chart[:human][12] = [ 152,  98,  31,  26,   7,   nil]
    @level_up_chart[:human][13] = [ 168, 106,  34,  29,   7,    11]
    @level_up_chart[:human][14] = [ 180, 114,  37,  33,   8,   nil]
    @level_up_chart[:human][15] = [ 194, 120,  40,  36,   8,    12]
    @level_up_chart[:human][16] = [ 216, 132,  43,  39,   9,   nil]
    @level_up_chart[:human][17] = [ 230, 140,  45,  41,   9,    13]
    @level_up_chart[:human][18] = [ 256, 152,  48,  44,  10,   nil]
    @level_up_chart[:human][19] = [ 280, 162,  50,  46,  10,   nil]
    @level_up_chart[:human][20] = [ 304, 180,  54,  48,  11,    14]
    #  ELVES                      [ mhp, mmp, atk, def, spd, spell]
    @level_up_chart[:elf][0]    = [  11,   5,   1,   1,   1,     1]
    @level_up_chart[:elf][1]    = [  16,  12,   2,   2,   3,     2]
    @level_up_chart[:elf][2]    = [  21,  21,   2,   2,   3,     6]
    @level_up_chart[:elf][3]    = [  25,  34,   2,   3,   4,     3]
    @level_up_chart[:elf][4]    = [  33,  50,   3,   4,   5,     4]
    @level_up_chart[:elf][5]    = [  40,  64,   4,   4,   5,     5]
    @level_up_chart[:elf][6]    = [  50,  78,   6,   6,   6,     7]
    @level_up_chart[:elf][7]    = [  63,  92,   9,   8,   6,     8]
    @level_up_chart[:elf][8]    = [  78, 124,  11,  11,   7,     9]
    @level_up_chart[:elf][9]    = [  92, 152,  14,  13,   7,    10]
    @level_up_chart[:elf][10]   = [ 104, 184,  18,  16,   8,    11]
    @level_up_chart[:elf][11]   = [ 112, 200,  20,  18,   9,   nil]
    @level_up_chart[:elf][12]   = [ 122, 216,  24,  21,   9,    12]
    @level_up_chart[:elf][13]   = [ 130, 224,  26,  24,  10,    13]
    @level_up_chart[:elf][14]   = [ 145, 240,  27,  26,  11,   nil]
    @level_up_chart[:elf][15]   = [ 155, 264,  30,  30,  12,    14]
    @level_up_chart[:elf][16]   = [ 164, 280,  32,  33,  12,   nil]
    @level_up_chart[:elf][17]   = [ 172, 304,  35,  35,  13,    15]
    @level_up_chart[:elf][18]   = [ 184, 320,  37,  37,  14,   nil]
    @level_up_chart[:elf][19]   = [ 200, 330,  39,  39,  15,   nil]
    @level_up_chart[:elf][20]   = [ 214, 356,  42,  42,  17,   nil]
  end

  def experience_array(lvl=nil, race=:dwarf)
    if race == :dwarf
      return @experience_reqd if lvl == nil
      return @experience_reqd[lvl]
    elsif race == :human
      return @experience_reqh if lvl == nil
      return @experience_reqh[lvl]
    elsif race == :elf
      return @experience_reqe if lvl == nil
      return @experience_reqe[lvl]
    end
  end

  def level_stats_array(race=nil, lvl=nil)
    return @level_up_chart if race == nil
    return @level_up_chart[race] if lvl == nil
    return @level_up_chart[race][lvl]
  end

  def enemies_array(id=nil, value=nil)
    return @enemies if id == nil
    return @enemies[id] if value == nil
    return @enemies[id][value]
  end

  def weapons_array(id=nil, i=nil)
    return @weapons if id == nil
    return @weapons[id] if i == nil
    return @weapons[id][i]
  end

  def armor_array(id=nil, i=nil)
    return @armors if id == nil
    return @armors[id] if i == nil
    return @armors[id][i]
  end

  def items_array(id=nil, i=nil)
    return @items if id == nil
    return @items[id] if i == nil
    return @items[id][i]
  end

  def spellbook(spellid=nil, value=nil)
    return @spells if spellid == nil
    return @spells[spellid] if value == nil
    return @spells[spellid][value]
  end

end
