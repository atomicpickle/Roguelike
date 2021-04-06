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
  @experience_req = {}
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
    @textdb[:intro][6] = " Its time to start your journey through Ruby Arena... Wake up!"
    @textdb[:intro][7]  = " You wake up on the side of town square. Your head hurts. \n Your whole body hurts. You have no recent memory of how you \n got here. You stand up, foggy and in pain, and look around."

    @textdb[:common][0]  = " You are standing in the middle of Draclix City. The city is \n bustling with activity all around you."
    @textdb[:common][1]  = " To your NORTH, you notice a large Arena. A large banner    \n reads 'ARENA: FIGHT TO THE DEATH! PROVE YOUR WORTH! GET RICH!'"
    @textdb[:common][2]  = " To your WEST, you notice a large tavern that appears to be \n quite busy. A few drunk patrons lean against the taverns walls."
    @textdb[:common][3]  = " To your EAST, you notice a large marketplace. It seems you   \n can buy almost anything within these shops."
    @textdb[:common][4]  = " To your SOUTH is the town exit, you see Surgalic Forest.  \n various sounds come from Surgalic Forest which gives you some    \n various forms of anxiety."

    @textdb[:common][5]  = " You are standing in Surgalic Forest. The deeper you go, the more \n strange the sounds get. Surely if you venture in, you will \n find something you can kill, or something that will eat you."
    @textdb[:common][6]  = " To your NORTH, you see the city gates and the entrance to  \n Dracilix City. A Sentinal stares at you from the gates."
    @textdb[:common][7]  = " All other directions seemed covered in overgrowth. Will you \n look around the Forest, or go NORTH back to the city?"

    @textdb[:common][8]  = " You stand at the enterance to the Arena. An angry looking man \n guards the main enterance. He takes one look at you, laughs \n and tells you to come back when you got some meat on you."
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

    @textdb[:cmd][0] = ["(N)orth"]
    @textdb[:cmd][1] = ["(W)est"]
    @textdb[:cmd][2] = ["(E)ast"]
    @textdb[:cmd][3] = ["(S)outh"]


    @textdb[:cmd][4] = ["(1) Buy"]
    @textdb[:cmd][5] = ["(2) Sell"]
    @textdb[:cmd][103] = ["(3) Exit"]

    @textdb[:cmd][6] = ["(L)ook (A)round"]

    @textdb[:cmd][7]  = ["(1) Menu"]
    @textdb[:cmd][8]  = ["(1) Player Stats"]
    @textdb[:cmd][9]  = ["(2) Inventory"]
    @textdb[:cmd][101]= ["(1) Use"]
    @textdb[:cmd][102]= ["(2) Back"]
    @textdb[:cmd][10] = ["(3) Spells"]
    @textdb[:cmd][11] = ["(4) Back to Game"]
    @textdb[:cmd][12] = ["(5) Save Game"]
    @textdb[:cmd][13] = ["(0) Exit Game"]

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
    @textdb[:battle][1] = "ACTIVE BATTLE: ARENA"
    @textdb[:battle][2] = "DIFFICULTY: EASY"
    @textdb[:battle][3] = "DIFFICULTY: MEDIUM"
    @textdb[:battle][4] = "DIFFICULTY: HARD"

    @textdb[:badges][0] = '<{^}>'
    @textdb[:badges][1] = '<{1}>'
    @textdb[:badges][3] = '<{2}>'
    @textdb[:badges][4] = '<{3}>'
    @textdb[:badges][5] = '<{4}>'
    @textdb[:badges][6] = '<{5}>'
    @textdb[:badges][7] = '<{6}>'
    @textdb[:badges][8] = '<{7}>'
    @textdb[:badges][9] = '<{8}>'
    @textdb[:badges][10]= '<{9}>'
    @textdb[:badges][11]= '<{#}>'

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
          Special Thanks: Teague Padriac
          Special Thanks: _powder_ (reddit.com)
          Icon Made by 'Good Ware' from www.flaticon.com"
    @textdb[:other][12]= " Version: Alpha.1.21.04.05.b            Author: Matt Sully(@GumpNerd)"
  end

  def tx(section, id)
    return nil if section == nil || id == nil
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
  def battle_enemy_hit_first(pspd=0, espd=0)
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
    return val
  end

  def calc_spell_damage(range, plvl, edef, elvl, heal=false)
    if heal == false #attack spell
      b1 = plvl - elvl; b1 = 0 if b1 < 0
      sel = rand(range[0]..range[1])
      b2 = rand(1..10)
      res = 0
      if b1 > 0 #player higher level
        en1 = edef * 0.30; en1.to_i
        en2 = rand(0..b2)
        en3 = en1 + en2
        res = sel - en3
      else # player same or lower level
        en1 = edef * 0.50; en1.to_i
        en2 = rand(0..b2)
        en3 = en1 + en2
        res = sel - en3
      end
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
      res = res * 0.70 if res > 1 && prace == :elf
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
  def calc_damage_alt2(atk, lvl, defend, lvl2, mob=false)
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

  def populate_weapons_db
    #             [Weapon name,              atk, spd, 2hand,  cost]
    @weapons[0] = ["Fists        ",            0,   0, false,      0]
    @weapons[1] = ["Pole         ",            2,   3, false,     10]
    @weapons[2] = ["Wooden Sword ",            5,   5, false,     20]
    @weapons[3] = ["Mage-Staff   ",            7,  13,  true,     80]
    @weapons[4] = ["Wooden Club  ",            9,   5, false,     80]
    @weapons[5] = ["Iron Hatchet ",            17,  7, false,    220]
    @weapons[6] = ["Iron Lance   ",            36,  2,  true,    375]
    @weapons[7] = ["Iron Sword   ",            32,  8, false,    950]
    @weapons[8] = ["Sage-Staff   ",            20, 26,  true,   1250]
    @weapons[9] = ["Steel Sword  ",            46,  8, false,   2500]
    @weapons[10]= ["Broadsword   ",            82,  3,  true,   8000]
    @weapons[11]= ["Bastard Sword",           175, 13, false,  12500]
  end

  def populate_armor_db
    #            [Armor Name,                def, spd,         cost]
    @armors[0] = ["Underwear    ",             0,   0,            0]
    @armors[1] = ["Cloth Shirt",               1,   3,           10]
    @armors[2] = ["Leather Armor",            12,   4,           90]
    @armors[3]=  ["Mage's Robe",               4,  10,          110]
    @armors[4] = ["Chainmail Armor",          28,   5,          420]
    @armors[5]=  ["Magikal Robe",             24,  15,         1300]
    @armors[6] = ["Studded Armor",            49,   6,         1500]
    @armors[7] = ["Half Plate Armor",         80,   5,         5000]
    @armors[8]=  ["Sage's Robe",              54,  32,         7550]
    @armors[9] = ["Bastard Armor",           186,  10,        11500]
  end

  def populate_items_db
    #           [Item Name,              +HP,  +MP,  +PHP, +PMP, +PATK, +PDEF,     cost,    Item Description]
    @items[0]  = ["Missingo",               0,    0,     0,    0,     0,     0,        0,    "..."]
    @items[1]  = ["Mugwart Root",          25,    0,     0,    0,     0,     0,       20,    "Heals +25 HP"]
    @items[2]  = ["Vervain Flower",         0,   25,     0,    0,     0,     0,       45,    "Heals +25 MP"]
    @items[3]  = ["Rose-Hipp Potion",     120,    0,     0,    0,     0,     0,       75,    "Heals +120 HP"]
    @items[4]  = ["Wolfsbane Potion",       0,   80,     0,    0,     0,     0,      120,    "Heals +100 MP"]
    @items[5]  = ["White Orchid Potion",  400,    0,     0,    0,     0,     0,      300,    "Heals +400 HP"]
    @items[6]  = ["Night-Shade Elixer",   500,  250,     0,    0,     0,     0,     1000,    "Heals +500 HP and +250 MP"]
    @items[7]  = ["Angels Tear",            0,    0,     5,    0,     0,     0,     2500,    "Permanently increases HP up to -1 to +5"]
    @items[8]  = ["Necromancer's Eye",      0,    0,     0,    5,     0,     0,     3000,    "Permanently increases MP up to -1 to +5"]
    @items[9]  = ["Dragon's Testicle",      0,    0,     0,    0,     6,     0,     3500,    "Permanently increases ATTACK up to -1 to +6"]
    @items[10] = ["Fairy Dust",             0,    0,     0,    0,     0,     6,     3500,    "Permanently increases DEFENSE up to -1 to +6"]
    @items[11] = ["Godsperm",               0,    0,    10,   10,    10,    10,     9001,    "Permanently increases HP, MP, ATK, DEF up to -1 to +10"]
    @items[12] = ["Speed Reader",           0,    0,     0,    0,     0,     0,    12500,    "After Use: Permanently enables the ability to see your enemies speed"]
    @items[13] = ["Attack Reader",          0,    0,     0,    0,     0,     0,    12500,    "After Use: Permanently enables the ability to see your enemies speed"]
    @items[14] = ["Defense Reader",         0,    0,     0,    0,     0,     0,    12500,    "After Use: Permanently enables the ability to see your enemies speed"]
    @items[15] = ["Rewards Reader",         0,    0,     0,    0,     0,     0,    12500,    "After Use: Permanently enables the ability to see your enemies speed"]
  end

  def populate_spells_db
    #            [Spell name,             Heal?,   [Minmax], Cost,   Description]
    @spells[0] = ["...",                  false,     [0, 0],    0,   "..."]
    @spells[1] = ["Heal",                  true,    [7, 24],    4,   "Simple healing spell"]
    @spells[2] = ["Greater Heal",          true,  [45, 125],    9,   "Less simple healing spell"]
    @spells[3] = ["Tremor",               false,   [5,  40],    6,   "Sends a tremor out and throws the target"]
    @spells[4] = ["Gust",                 false,   [6,  50],    7,   "A Sharp gust of wind impacts the target"]
    @spells[5] = ["Water Talons",         false,   [7,  60],    9,   "Pull water out of the air into talons and shoot at target"]
    @spells[6] = ["Shock",                false,   [18, 33],    9,   "Electricity shoots from your mouth and strikes"]
    @spells[7] = ["Blizzard",             false,   [32, 86],   12,   "Blizzard swirls up around the target"]
    @spells[8] = ["Fireball",             false,  [75, 125],   16,   "A Fireball pops into existance and strikes"]
    @spells[9] = ["Quake",                false,   [1, 150],   10,   "Earth opens and crushes your target"]
    @spells[10]= ["Hurricane",            false,  [45, 250],   16,   "A Hurricaine hits the target, then disappears"]
    @spells[11]= ["Bolt",                 false, [114, 166],   24,   "Electricity shoots from all of your orifices and strikes"]
    @spells[12]= ["Wall of Fire",         false,  [88, 333],   32,   "A Wall of Fire emerges and envelopes everything"]
  end

  def populate_enemies_db #races: ghost(0), dwarf(1), human(2), elf(3), animal(4), demon(5)
    #                #[Enemy name,             race, lvl,  mhp,  mmp,  atk,  def,  spd,   exp,   gold, [drops],drop%,  [spells], sp%]
    @enemies[:g1] = ["Lost Spirit",             0,   0,    1,    3,    0,    0,    5,     4,      0,  [8, 7],    5,    [1, 0],  33]
    @enemies[:g2] = ["Angry Spirit",            0,   5,   33,   24,    5,    0,   15,    10,      0,  [8, 7],   10,    [1, 4],  40]
    @enemies[:g3] = ["Girl From The Ring",      0,   7,  166,   48,   22,    9,   19,    66,      6,  [8, 7],   10,    [1, 8],  40]

    @enemies[0]  =  ["Emptyness",               0,   0,    1,    0,    0,    0,    0,     0,      0,  [0, 0],    1,    [0, 0],   0]
    @enemies[1]  =  ["Butterfly",               4,   0,    7,    0,    2,    1,    6,     2,      1,  [1, 2],   25,    [0, 0],   0]
    @enemies[2]  =  ["Innocent Rabbit",         4,   1,    8,    0,    2,    1,    7,     3,      3,  [1, 2],   20,    [0, 0],   0]
    @enemies[3]  =  ["Large Rat",               4,   1,    9,    0,    4,    1,    9,     4,      3,  [1, 2],   20,    [0, 0],   0]
    @enemies[4]  =  ["Beautiful Hawk",          4,   2,   15,    0,    8,    3,   10,     7,      9,  [1, 2],   10,    [0, 0],   0]
    @enemies[5]  =  ["Blacktail Deer",          4,   2,   18,    0,    8,    4,   12,     9,      5,  [1, 2],   10,    [0, 0],   0]
    @enemies[6]  =  ["Adorable Fox",            4,   3,   19,    0,   12,    5,   13,    12,     15,  [1, 2],   10,    [0, 0],   0]
    @enemies[7]  =  ["Angry Bird",              4,   3,   22,    0,   14,    6,   14,    18,     22,  [1, 2],   10,    [0, 0],   0]
    @enemies[8]  =  ["Blazing Skull",           5,   4,   30,   10,   18,    6,   15,    26,     28, [10, 9],    5,    [1, 4],  45]
    @enemies[9]  =  ["Syren",                   5,   4,   34,   16,   20,    9,   16,    34,     35,  [6, 5],    5,    [1, 5],  45]
    @enemies[10] =  ["Ipotane",                 4,   4,   38,   14,   22,   12,   17,    40,     30,  [6, 7],    5,    [1, 6],  45]
    @enemies[11] =  ["F**king Tiger",           4,   5,   50,    0,   29,   15,   19,    52,     40,  [3, 9],    8,    [0, 0],   0]
    @enemies[12] =  ["Black Zebra",             4,   5,   58,    0,   25,   20,   20,    42,     75,  [3, 7],    8,    [0, 0],   0]
    @enemies[13] =  ["Giant C**t of a Rhino",   4,   6,   92,    0,   39,   36,   22,   110,     35, [10, 9],    5,    [0, 0],   0]
    @enemies[14] =  ["Shortneck Angry Giraffe", 4,   6,  110,    0,   30,   45,   26,    86,    100,  [8, 7],    5,    [0, 0],   0]
    @enemies[15] =  ["Longma",                  4,   6,  120,   30,   31,   44,   30,   100,    110,  [8, 6],   10,    [2, 7],  40]
    @enemies[16] =  ["Gay Horny Jinn",          5,   7,  152,   42,   44,   52,   35,   186,    165,  [9, 7],   15,   [2, 11],  48]
    @enemies[17] =  ["Cute Velociraptor",       4,   7,  192,   22,   49,   58,   40,   224,    204, [9, 10],   10,    [2, 0],  25]
    @enemies[18] =  ["Electric Floating Skull", 5,   8,  256,   70,   54,   50,   32,   300,    225,  [8, 9],   12,   [2, 11],  40]

    @enemies[:b0] = ["Rosco the Drunk",         2,   4,  112,   24,   24,   15,   15,   150,    100, [3, 10],   10,    [1, 0],  25]
    @enemies[:b4] = ["Babba-Yagga",             5,   5,  100,   28,   30,   15,   13,   120,    175,  [1, 6],   12,    [1, 3],  30]
    @enemies[:b5] = ["Big Gay Yeti",            4,   5,  112,   30,   32,   10,   15,   128,    180,  [4, 5],   30,    [1, 7],  35]
    @enemies[:b1] = ["Tiny",                    1,   7,  250,    0,   58,   25,   12,  1250,   2500,  [3, 9],   10,    [0, 0],   0]
    @enemies[:b2] = ["Lana",                    1,   9,  777,   86,   74,   58,   20,  3450,   7500, [10, 9],   25,    [2, 6],  40]
    @enemies[:b3] = ["Sexual Harrasment Panda", 4,  10, 1250,  108,   96,   64,   28,  7500,  10500, [8, 10],   33,    [2, 6],  40]
  end

  #key for experience_req = level (So experience_req[3] = exp for level 3)
  def populate_experience_req_db
    #                     [amount, total]
    @experience_req[0]  = [     0,     0]
    @experience_req[1]  = [    14,    14]
    @experience_req[2]  = [    40,    54]
    @experience_req[3]  = [   106,   160]
    @experience_req[4]  = [   214,   374]
    @experience_req[5]  = [   406,   780]
    @experience_req[6]  = [   664,  1444]
    @experience_req[7]  = [   996,  2440]
    @experience_req[8]  = [  1044,  3484]
    @experience_req[9]  = [  1656,  5140]
    @experience_req[10] = [  3004,  8144]
    @experience_req[11] = [150000,166090]
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
    @level_up_chart[:human][10] = [ 120,  84,  25,  21,   5,    10]
    #  ELVES                      [ mhp, mmp, atk, def, spd, spell]
    @level_up_chart[:elf][0]    = [  11,   5,   1,   1,   1,     1]
    @level_up_chart[:elf][1]    = [  16,  12,   2,   2,   3,     2]
    @level_up_chart[:elf][2]    = [  21,  21,   2,   2,   3,     6]
    @level_up_chart[:elf][3]    = [  25,  34,   2,   3,   4,     3]
    @level_up_chart[:elf][4]    = [  33,  50,   3,   4,   5,     4]
    @level_up_chart[:elf][5]    = [  40,  64,   4,   4,   5,     5]
    @level_up_chart[:elf][6]    = [  50,  78,   6,   6,   6,     8]
    @level_up_chart[:elf][7]    = [  63,  92,   9,   8,   6,     9]
    @level_up_chart[:elf][8]    = [  78, 124,  11,  11,   7,    10]
    @level_up_chart[:elf][9]    = [  92, 152,  14,  13,   7,    11]
    @level_up_chart[:elf][10]   = [ 104, 184,  18,  16,   8,    12]
  end

  def experience_array(lvl=nil)
    return @experience_req if lvl == nil
    return @experience_req[lvl]
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
