require 'paint'
require 'paint/pa'
require 'json'
require 'yaml'
puts "Require paint \n Require paint/pa \n Require json \n Require yaml"
require_relative 'Game_DB'
require_relative 'Player'
require_relative 'Enemy'
puts "Checking for relative scripts Game_DB, Player, Enemy"

include Game_DB
puts "Populating Game database..."
Game_DB.populate_database

# color text conventions
# :green = standard text
# :cyan = standard choice
# :green, :bright = selected item, action performed
# :red, physical attack, or input error
puts "loading..."


class Game_Main

  def initialize
    clr
    Paint.mode = 256
    # only used for setup. maybe not needed
    @character_base = {}
    @character_base[:race] = []
    @character_base[:name] = []
    # location variables (current, last) used to remember last location for menu usage
    @location = [:town, :town]
    # used as player class object
    @player = 0
    # used for writing stats on screen via draw_stats_main method
    @stats = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    # stores wandering enemies when player is hunting
    @enemies = {}
    @enemies[:wandering] = []
    @enemies[:amount] = 0
    # if true, player is actively hunting
    @hunting = false
    # if t rue, player is in a battle
    @battle = false
    # used as enemy class object for battles
    @enemy = 0
    @enemyturn = false
    # hit first did the enemy hit a first strike attack?
    @enemyhitfirst = false
    # used for update method function
    @update = false
    # Used to navigate the player menu [stats, bag, spells, save game, exit game]
    @submenu = [false, false, false, false, false]
    # used to navigate item menu [weapons, armor, items]
    @itemmenu = [false, false, false]
    @shopmenu = [false, false, false]
    startup_titlecard
  end

  def process_game_file_save
    File.delete("splayer.save") if File.exists?("splayer.save")
    File.delete("sworld.save") if File.exists?("sworld.save")
    save_file = File.new("splayer.save", "w")
    save_file.write @player.to_yaml
    save_file.close
    save_file = File.new("sworld.save", "w")
    save_file.write @location.to_json
    save_file.close
    pa "#{Game_DB.tx(:other, 8)}", :green, :bright
    pa "#{Game_DB.tx(:other, 7)}"
    key = gets
  end

  def process_game_load_file
    yaml_player = YAML.load(File.read("splayer.save"))
    locdata = JSON.parse(File.read("sworld.save"))
    locdata[0] = locdata[0].to_sym
    locdata[1] = locdata[1].to_sym
    @location = locdata
    @player = Player.new
    @player = yaml_player
    @player.finish_reload
    pa "SAVE FILE LOADED! Player Name: #{@player.playername}, Race: #{@player.race}, Level: #{@player.level}, Gold: #{@player.gold}", :cyan
    pa "#{Game_DB.tx(:other, 7)}"
    key = gets
    @location[0] = @location[1]
    @update = true
    update
  end

  def spawn_player
    clr
    draw_stats_main
    pa "#{Game_DB.tx(:intro, 7)}", :green
    location_draw(@location[0])
    update
  end

  def update
    if @update
      @update = false
      clr
      draw_stats_main
      @hunting = false if @location[0] != :forest
      location_draw(@location[0]) unless @battle
      battle_draw if @battle
    end
  end

  # :red, :blue, :level, :green
  def draw_flash(color=:red, ticks=6)
    flashbar = Game_DB.tx(:other, 11)
    flasher = 0
    if color == :red
      ticks.times do
        clr
        draw_stats_main
        flasher += 1
        pa "\n"
        pa "\n"
        pa "\n"
        pa "\r#{flashbar}", :red, :bright if flasher.even?
        pa "\r#{flashbar}", :red if flasher.even?
        pa "\r#{flashbar}", :red if flasher.even?
        pa "\r#{flashbar}", :red if flasher.even?
        pa "\n"
        pa "\n"
        pa "\r#{flashbar}", :red if flasher.odd?
        pa "\r#{flashbar}", :red if flasher.odd?
        pa "\r#{flashbar}", :red if flasher.odd?
        pa "\r#{flashbar}", :red, :bright if flasher.odd?
        sleep 0.01
      end
      clr
      draw_stats_main
    elsif color == :blue
      ticks.times do
        clr
        draw_stats_main
        flasher += 1
        pa "\n"
        pa "\n"
        pa "\n"
        pa "\r#{flashbar}", :blue, :bright if flasher.even?
        pa "\r#{flashbar}", :blue if flasher.even?
        pa "\r#{flashbar}", :blue if flasher.even?
        pa "\r#{flashbar}", :blue if flasher.even?
        pa "\n"
        pa "\n"
        pa "\r#{flashbar}", :blue if flasher.odd?
        pa "\r#{flashbar}", :blue if flasher.odd?
        pa "\r#{flashbar}", :blue if flasher.odd?
        pa "\r#{flashbar}", :blue, :bright if flasher.odd?
        sleep 0.01
      end
      clr
      draw_stats_main
    elsif color == :level
      ticks.times do
        clr
        draw_stats_main
        flasher += 1
        pa "\n"
        pa "\n"
        pa "\n"
        pa "\r#{flashbar}", :green if flasher.even?
        pa "\r#{flashbar}", :green if flasher.even?
        pa "\r#{flashbar}", :green if flasher.even?
        pa "\r#{flashbar}", :green if flasher.even?
        pa "\n"
        pa "\n"
        pa "\r#{flashbar}", :blue if flasher.even?
        pa "\r#{flashbar}", :blue if flasher.odd?
        pa "\r#{flashbar}", :blue if flasher.odd?
        pa "\r#{flashbar}", :blue if flasher.odd?
        sleep 0.01
      end
      clr
      draw_stats_main
    elsif color == :green
      ticks.times do
        clr
        draw_stats_main
        flasher += 1
        pa "\n"
        pa "\n"
        pa "\n"
        pa "\r#{flashbar}", :green, :bright if flasher.even?
        pa "\r#{flashbar}", :green if flasher.even?
        pa "\r#{flashbar}", :green if flasher.even?
        pa "\r#{flashbar}", :green if flasher.even?
        pa "\n"
        pa "\n"
        pa "\r#{flashbar}", :green if flasher.odd?
        pa "\r#{flashbar}", :green if flasher.odd?
        pa "\r#{flashbar}", :green if flasher.odd?
        pa "\r#{flashbar}", :green, :bright if flasher.odd?
        sleep 0.01
      end
      clr
      draw_stats_main
    end
  end

  def start_battle(enemy_id)
    @battle = true
    @location[1] = @location[0]
    @location[0] = :battle
    @update = true
    @enemy = Enemy.new(enemy_id)
    update
  end

  def battle_draw(arena=false)
    if !arena
      #wild battle
      rating = Game_DB.battle_diff(@player.level, @enemy.read_stat(:lvl))
      diff = wild_enemy_difficulty
      if diff == 0
        pa "#{Game_DB.tx(:other, 5)}", :green
        pa " #{rating}", :green
        pa "#{Game_DB.tx(:other, 5)}", :green
      elsif diff == 1
        pa "#{Game_DB.tx(:other, 5)}", :yellow
        pa " #{rating}", :yellow
        pa "#{Game_DB.tx(:other, 5)}", :yellow
      elsif diff == 2
        pa "#{Game_DB.tx(:other, 5)}", :red
        pa " #{rating}", :red
        pa "#{Game_DB.tx(:other, 5)}", :red
      end
    else
      #arena battle
      pa "#{Game_DB.tx(:other, 5)}", :red
      pa "                  #{Game_DB.tx(:battle, 1)}", :red, :bright
      pa "#{Game_DB.tx(:other, 5)}", :red
    end
    pa "#{Game_DB.tx(:other, 0)}"
    pa "Enemy Stats: ", :red
    pa "NAME: #{@enemy.read_name}", :red, :bright
    pa "LEVEL: #{@enemy.read_stat(:lvl)}", :red, :bright
    pa "RACE: #{@enemy.read_stat(:race)}", :red, :bright
    pa "HP: #{@enemy.read_stat(:hp)}/#{@enemy.read_stat(:mhp)}", :red, :bright
    pa "MP: #{@enemy.read_stat(:mp)}/#{@enemy.read_stat(:mmp)}", :red, :bright
    pa "#{Game_DB.tx(:other, 0)}"
    pa "#{Game_DB.tx(:other, 0)}"
    pa "#{Game_DB.tx(:other, 0)}"
    pa "#{Game_DB.tx(:other, 0)}"
    pa "#{Game_DB.tx(:other, 0)}"
    pa "#{Game_DB.tx(:other, 0)}"
    process_battle_input
    update
  end

  def wild_enemy_difficulty
    res = @enemy.read_stat(:lvl) - @player.level
    return 0 if res < 0
    return 1 if res == 0
    return 2 if res > 0
  end

  def process_battle_input
    pa "  #{Game_DB.tx(:battle, 6)}    #{Game_DB.tx(:battle, 7)}    #{Game_DB.tx(:battle, 8)}    #{Game_DB.tx(:battle, 9)}", :cyan
    loop do
      @update = true
      key = gets.chomp.downcase
      case key
      when "a"  #attack
        enemyfs = Game_DB.battle_enemy_hit_first(@enemy.read_stat(:spd), @player.final_stat(:spd))
        process_battle_attack(enemyfs)
        process_battle_attack
        break
      when "s"  #spell
        enemyfs = Game_DB.battle_enemy_hit_first(@enemy.read_stat(:spd), @player.final_stat(:spd))
        spellid = spell_selection
        break if spellid == 0
        process_battle_attack(enemyfs, true, spellid)
        process_battle_attack(false, true, spellid)
        break
      when "i" #item
        item = use_item_battle
        if item == 0 #no item used
          break
        else # item was used
          process_battle_attack
          break
        end
        break
      when "r" #run
        process_battle_escape
        break
      end
    end
  end

  def use_item_battle
    clr
    draw_stats_main
    bag = @player.read_item_bag(:items)
    pa "#{Game_DB.tx(:other, 0)}"
    pa "ITEMS"
    pa "Inventory:"
    bag.each {|id, amt| pa "  (#{id}) #{Game_DB.items_array(id, 0)} x #{amt} #{Game_DB.items_array(id, 8)}" if amt > 0}
    pa "#{Game_DB.tx(:other, 0)}"
    pa "Use which item? (choose number or 0 to cancel)"
    pa "You can use items even if you dont need them."
    pa "#{Game_DB.tx(:other, 0)}"
    key = 0
    loop do
      key = gets.chomp.to_i
      break if bag.key?(key) == false
      break if key == 0
      if bag.key?(key) && bag[key] > 0
        draw_flash(:green, 6)
        @player.use_item(key)
        key = gets
        @enemyturn = true
        break
      end
    end
    return key
  end

  #return spell id
  def spell_selection
    spells = @player.spells_learned
    return nil if spells.length < 1
    clr
    draw_stats_main
    spells.each do |e|
      pa "(#{e}): #{Game_DB.spellbook(e, 0)}"
      pa "   > Cost: #{Game_DB.spellbook(e, 3)} MP"
      pa "   > Info: #{Game_DB.spellbook(e, 4)}"
    end
    pa "Select a spell by using its (ID). Press (0) to cancel."
    loop do
      key = gets.chomp.to_i
      if spells.include?(key)
        #matching spell selected
        return key
      elsif key == 0
        return 0
      end
    end
  end

  def process_battle_attack(enemy_first_strike=false, player_spell=false, spellid=0)
    return if @enemy == 0
    efs = enemy_first_strike
    if @enemyturn == true || efs == true #force turn true on first strike attack ????
      # enemy attacks:
      en_casting = @enemy.enemy_casting?
      if efs == true
        #enemy attacks first!
        if en_casting #enemy casting a spell
          en_spells = @enemy.get_valid_spells
          en_healing = rand(1..2) if en_spells[0] > 0
          en_healing = 2 if en_spells[0] == 0
          if en_healing == 1 #enemy Heals
            draw_flash(:green, 6)
            spcost = Game_DB.spellbook(en_spells[0], 3)
            sprange = Game_DB.spellbook(en_spells[0], 2)
            amount = Game_DB.calc_enemy_spell_damage(sprange, @enemy.read_stat(:lvl), @player.final_stat(:def), @player.level, true)
            @enemy.healHP(amount)
            @enemy.useMP(spcost)
            pa "#{Game_DB.tx(:other, 0)}"
            pa "#{Game_DB.tx(:other, 0)}"
            pa "             #{@enemy.read_name} out maneuvers YOU and STRIKES FIRST!!!", :green
            pa "#{Game_DB.tx(:other, 0)}"
            pa "#{Game_DB.tx(:other, 0)}"
            pa "#{Game_DB.tx(:other, 0)}"
            pa "             #{@enemy.read_name} cast the spell #{Game_DB.spellbook(en_spells[0], 0)} and healed #{amount} HP!!!!", :green
            pa "             #{Game_DB.spellbook(en_spells[0], 4)}", :green
          else #enemy doesnt heal, uses attack spell
            draw_flash(:blue, 6)
            spcost = Game_DB.spellbook(en_spells[1], 3)
            sprange = Game_DB.spellbook(en_spells[1], 2)
            amount = Game_DB.calc_enemy_spell_damage(sprange, @enemy.read_stat(:lvl), @player.final_stat(:def), @player.level, false)
            @player.damage(:hp, amount)
            @enemy.useMP(spcost)
            pa "#{Game_DB.tx(:other, 0)}"
            pa "#{Game_DB.tx(:other, 0)}"
            pa "             #{@enemy.read_name} out maneuvers YOU and STRIKES FIRST!!!", :green
            pa "#{Game_DB.tx(:other, 0)}"
            pa "#{Game_DB.tx(:other, 0)}"
            pa "#{Game_DB.tx(:other, 0)}"
            pa "             #{@enemy.read_name} cast the spell #{Game_DB.spellbook(en_spells[1], 0)} and did #{amount} damage!!!!", :red, :bright
            pa "             #{Game_DB.spellbook(en_spells[1], 4)}", :red, :bright
          end
        else #enemy using physical attack
          draw_flash(:red, 6)
          pa "#{Game_DB.tx(:other, 0)}"
          pa "#{Game_DB.tx(:other, 0)}"
          pa "             #{@enemy.read_name} out maneuvers YOU and STRIKES FIRST!!!", :red
          amount = Game_DB.calc_damage_alt2(@enemy.read_stat(:atk), @enemy.read_stat(:lvl), @player.final_stat(:def), @player.level, true)
          @player.damage(:hp, amount)
          pa "#{Game_DB.tx(:other, 0)}"
          pa "#{Game_DB.tx(:other, 0)}"
          pa "#{Game_DB.tx(:other, 0)}"
          pa "             SMACK!!! #{@enemy.read_name} attacked YOU and did #{amount} damage!!!", :red
        end
        pa "#{Game_DB.tx(:other, 0)}"
        pa "#{Game_DB.tx(:other, 0)}"
        pa "#{Game_DB.tx(:other, 0)}"
        pa "                      #{Game_DB.tx(:other, 7)}"
        key = gets
        @enemyturn = false
        @enemyhitfirst = true
      else
        if en_casting #enemy casting a spell
          en_spells = @enemy.get_valid_spells
          en_healing = rand(1..2) if en_spells[0] > 0
          en_healing = 2 if en_spells[0] == 0
          if en_healing == 1 #enemy heals
            draw_flash(:green, 6)
            spcost = Game_DB.spellbook(en_spells[0], 3)
            sprange = Game_DB.spellbook(en_spells[0], 2)
            amount = Game_DB.calc_enemy_spell_damage(sprange, @enemy.read_stat(:lvl), @player.final_stat(:def), @player.level, true)
            @enemy.healHP(amount)
            @enemy.useMP(spcost)
            pa "#{Game_DB.tx(:other, 0)}"
            pa "#{Game_DB.tx(:other, 0)}"
            pa "#{Game_DB.tx(:other, 0)}"
            pa "             #{@enemy.read_name} cast the spell #{Game_DB.spellbook(en_spells[0], 0)} and healed #{amount} HP!!!!", :green
            pa "             #{Game_DB.spellbook(en_spells[0], 4)}", :green
          else #enemy attack spell
            draw_flash(:blue, 6)
            spcost = Game_DB.spellbook(en_spells[1], 3)
            sprange = Game_DB.spellbook(en_spells[1], 2)
            amount = Game_DB.calc_enemy_spell_damage(sprange, @enemy.read_stat(:lvl), @player.final_stat(:def), @player.level, false)
            @player.damage(:hp, amount)
            @enemy.useMP(spcost)
            pa "#{Game_DB.tx(:other, 0)}"
            pa "#{Game_DB.tx(:other, 0)}"
            pa "#{Game_DB.tx(:other, 0)}"
            pa "             #{@enemy.read_name} cast the spell #{Game_DB.spellbook(en_spells[1], 0)} and did #{amount} damage!!!!", :red, :bright
            pa "             #{Game_DB.spellbook(en_spells[1], 4)}", :red, :bright
          end
        else #enemy attacks
          draw_flash(:red, 2)
          amount = Game_DB.calc_damage_alt2(@enemy.read_stat(:atk), @enemy.read_stat(:lvl), @player.final_stat(:def), @player.level, true)
          @player.damage(:hp, amount)
          pa "#{Game_DB.tx(:other, 0)}"
          pa "#{Game_DB.tx(:other, 0)}"
          pa "#{Game_DB.tx(:other, 0)}"
          pa "             SMACK!!! #{@enemy.read_name} attacked YOU and did #{amount} damage!!!", :red
        end
        pa "#{Game_DB.tx(:other, 0)}"
        pa "#{Game_DB.tx(:other, 0)}"
        pa "#{Game_DB.tx(:other, 0)}"
        pa "                      #{Game_DB.tx(:other, 7)}"
        key = gets
        @enemyturn = false
      end
    else
      # player attacks!
      if player_spell == false
        #player attacking active enemy
        draw_flash(:red, 2)
        playeratk = @player.final_stat(:atk)
        playerlvl = @player.level
        enemydef = @enemy.read_stat(:def)
        enemylvl = @enemy.read_stat(:lvl)
        amount = Game_DB.calc_damage_alt2(playeratk, playerlvl, enemydef, enemylvl)
        @enemy.damage(amount)
        @player.total_damage += amount
        pa "#{Game_DB.tx(:other, 0)}"
        pa "#{Game_DB.tx(:other, 0)}"
        pa "#{Game_DB.tx(:other, 0)}"
        pa "             SMACK!!! YOU attacked #{@enemy.read_name} and did #{amount} damage!!!", :red
      else
        # player casting spell!
        # calc_spell_damage(range, plvl, edef, elvl, heal=false)
        healing = false
        curmp = @player.read_cur_hpmp(:mp)
        spcost = Game_DB.spellbook(spellid, 3)
        sprange = Game_DB.spellbook(spellid, 2)
        healing = true if spellid == 1 || spellid == 2
        if spcost <= curmp
          amount = Game_DB.calc_spell_damage(sprange, @player.level, @enemy.read_stat(:def), @enemy.read_stat(:lvl), healing)
          @enemy.damage(amount) if !healing
          @player.heal(:hp, amount) if healing
          @player.damage(:mp, Game_DB.spellbook(spellid, 3))
          pa "#{Game_DB.tx(:other, 0)}"
          pa "#{Game_DB.tx(:other, 0)}"
          pa "#{Game_DB.tx(:other, 0)}"
          if healing
            draw_flash(:green, 6)
            pa "             You cast the spell #{Game_DB.spellbook(spellid, 0)} and healed #{amount} HP!!!!", :green
            pa "             #{Game_DB.spellbook(spellid, 4)}", :green
          else
            draw_flash(:blue, 6)
            pa "             You cast the spell #{Game_DB.spellbook(spellid, 0)} and did #{amount} damage!!!!", :red, :bright
            pa "             #{Game_DB.spellbook(spellid, 4)}", :red, :bright
          end
        else
           pa "              You try to cast a spell without enough MP and waste your turn!", :magenta, :bright
        end
      end
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "                      #{Game_DB.tx(:other, 7)}"
      key = gets
      @enemyturn = true unless @enemyhitfirst
      @enemyhitfirst = false
    end
    process_alive_checking
  end

  def process_battle_escape
    clr
    draw_stats_main
    pspd = @player.final_stat(:spd)
    espd = @enemy.read_stat(:spd)
    odds = 115 if espd > pspd
    odds = 65 if espd <= pspd
    res = rand(0..odds)
    escape = true if res <= 50
    escape = false if res > 50
    if escape == true
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "            You attempt to run! #{@enemy.read_name} blocks your path!", :blue, :bright
      key = gets
      @enemyturn = true
      process_battle_attack
    else
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "            You attempt to run! You out maneuver #{@enemy.read_name} and escape!", :blue, :bright
      key = gets
      @battle = false
      @enemy = 0
      @enemyturn = false
      @hunting = false
      @location[0] = @location[1]
    end
  end

  def process_alive_checking
    clr
    draw_stats_main
    if @player.read_cur_hpmp(:hp) <= 0
      #player dead!
      pa "#{Game_DB.tx(:other, 14)}", :red
      pa "#{Game_DB.tx(:other, 0)}"
      pa "                  Name: #{@player.playername}, Race: #{@player.race}, Level: #{@player.level}", :red, :bright
      pa "                  Total Damage Done:  #{@player.total_damage}", :red
      pa "                  Total Damage Taken: #{@player.damage_taken}", :red
      key = gets
      exit
    elsif @enemy.alive? == false
      #enemy dead!
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 15)}", :green
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "                          You have defeated #{@enemy.read_name}!!!", :cyan
      pa "                          You have gained #{@enemy.read_stat(:exp)} Experience Points!", :green
      pa "                          You have gained #{@enemy.read_stat(:gold)} Gold!", :yellow
      pa "#{Game_DB.tx(:other, 0)}"
      dropinfo = @enemy.dropinfo
      dropchance = @enemy.dropinfo(true)
      dice = rand(1..100); dice2 = rand(1..10)
      if dice <= dropchance
        id = dropinfo[0] if dice2 <= 7
        id = dropinfo[1] if dice2 > 7
        @player.add_item(:item, id)
        pa "                    #{@enemy.read_name} dropped an item! You found 1x #{Game_DB.items_array(id, 0)}", :yellow, :bright
      end
      pa "#{Game_DB.tx(:other, 0)}"
      pa "                           #{Game_DB.tx(:other, 7)}"
      user_cur = Game_DB.level_stats_array(@player.race, @player.level)
      user_new = Game_DB.level_stats_array(@player.race, @player.level+1)
      @player.add_exp(@enemy.read_stat(:exp))
      @player.add_gold(@enemy.read_stat(:gold))
      key = gets
      if @player.levelUP
        @player.levelUP = false
        draw_flash(:level, 10)
        pa "#{Game_DB.tx(:other, 0)}"
        pa "                    YOU HAVE LEVELED UP!!!"
        pa "                    Level:   #{@player.level-1} => #{@player.level}", :blue, :bright
        pa "                    Max HP:  #{user_cur[0]} => #{user_new[0]}", :green
        pa "                    Max MP:  #{user_cur[1]} => #{user_new[1]}", :magenta
        pa "                    Attack:  #{user_cur[2]} => #{user_new[2]}", :red, :bright
        pa "                    Defense: #{user_cur[3]} => #{user_new[3]}", :green, :bright
        pa "                    Speed:   #{user_cur[4]} => #{user_new[4]}", :yellow, :bright
        pa "#{Game_DB.tx(:other, 0)}"
        if user_new[5] != nil #new spell learned
          spname = Game_DB.spellbook(user_new[5], 0)
          pa "                    You learned the spell #{spname}!", :yellow
        end
        if @player.level == 4
          pa "#{Game_DB.tx(:other, 0)}"
          pa "                    You have reached level 4! You have earned your Arena entry badge!!!", :yellow
          pa "                    You are now able to compete in the Arena.", :yellow
          @player.add_badge(Game_DB.tx(:badges, 0))
        end
        pa "#{Game_DB.tx(:other, 0)}"
        pa "                           #{Game_DB.tx(:other, 7)}"
        key = gets
      end
      @battle = false
      @enemy = 0
      @enemyturn = false
      @hunting = false
      @location[0] = @location[1]
    end
  end

  def calculate_enemies
    @enemies[:wandering].clear
    @hunting = true
    plvl = @player.level
    enemy_lib = Game_DB.enemies_array
    lvlmax = plvl + 3
    valid_enemies = enemy_lib.select { |k, v| v[2] <= lvlmax }
    valid_enemies.reject! { |k,v| k == 0}
    valid_enemies.reject! { |k,v| k.is_a? Symbol}
    enemies_keys = valid_enemies.keys
    enemies_keys.each do |i|
      break if @enemies[:wandering].length >= 5
      dice = rand(1..100)
      @enemies[:wandering] << i if valid_enemies[i][2] == plvl-1 && dice <= 50
      @enemies[:wandering] << i if valid_enemies[i][2] == plvl && dice <= 75
      @enemies[:wandering] << i if valid_enemies[i][2] == plvl+1 && dice > 75
      @enemies[:wandering] << i if valid_enemies[i][2] == plvl+1 && dice <= 75
      @enemies[:wandering] << i if valid_enemies[i][2] == plvl+1 && dice <= 50
      @enemies[:wandering] << i if valid_enemies[i][2] == lvlmax-1 && dice <= 50
      @enemies[:wandering] << i if valid_enemies[i][2] == lvlmax-1 && dice >= 75
      @enemies[:wandering] << i if valid_enemies[i][2] == lvlmax && dice <= 50
    end
    @enemies[:amount] = @enemies[:wandering].length
  end

  # level hp/mhp mp/mhp     experience/exp. needed     gold
  # #stats symbols :hp :mp :atk :def :spd
  #[lvl, hp, mhp, mp, mmp, exp, expneed, gold, name]
  def draw_stats_main
    lvl1 = @player.level + 1
    expneed = Game_DB.experience_array(lvl1)
    @stats[0] = @player.level
    @stats[1] = @player.read_cur_hpmp(:hp)
    @stats[2] = @player.final_stat(:hp)
    @stats[3] = @player.read_cur_hpmp(:mp)
    @stats[4] = @player.final_stat(:mp)
    @stats[5] = @player.exp
    @stats[6] = expneed[1]
    @stats[7] = @player.gold
    @stats[8] = @player.playername
    exppct = 100 * @player.exp / expneed[1]
    exppct = exppct.to_i
    hppct = @stats[1].to_f / @stats[2].to_f * 100.to_i
    bgcolor = :black
    bgcolor = :red if hppct <= 30
    pa "#{Game_DB.tx(:other, 5)}"
    pa "NAME: #{@stats[8]}   LEVEL: #{@stats[0]}    HP: #{@stats[1]}/#{@stats[2]}     MP: #{@stats[3]}/#{@stats[4]}   EXP: #{@stats[5]}/#{@stats[6]}(#{exppct}%)   GOLD: #{@stats[7]}", :white, bgcolor
    pa "#{Game_DB.tx(:other, 5)}"
  end

  def clr
    system("cls")
  end
  #locations: :town, :arena, :tavern, :shop, :forest, :menu
  def location_draw(area=:town)
    if area == :town
      pa "#{Game_DB.tx(:common, 0)}", :green
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:common, 1)}", :green, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:common, 2)}", :green, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:common, 3)}", :green, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:common, 4)}", :green, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:cmd, 0)}", :cyan
      pa "#{Game_DB.tx(:cmd, 1)}", :cyan
      pa "#{Game_DB.tx(:cmd, 2)}", :cyan
      pa "#{Game_DB.tx(:cmd, 3)}", :cyan
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:cmd, 7)}", :cyan
      process_input
      update
    end
    if area == :tavern
      price = @player.level * 3 + 3
      pa "#{Game_DB.tx(:common, 11)}", :green
      pa " The Bartender offers you a room to sleep in for #{price} Gold.", :magenta, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:common, 12)}", :green, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:cmd, 27)} for #{price} Gold", :cyan
      pa "#{Game_DB.tx(:cmd, 2)}", :cyan
      process_input
      update
    end
    if area == :arena
      pa "#{Game_DB.tx(:common, 8)}", :green
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:common, 9)}", :green, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:cmd, 3)}", :cyan
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:cmd, 7)}", :cyan
      process_input
      update
    end
    if area == :forest
      pa "#{Game_DB.tx(:common, 5)}", :green
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:common, 6)}", :green, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:common, 7)}", :green, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:common, 10)}", :green  if @hunting
      pa "#{Game_DB.tx(:other, 0)}" if @hunting
      print_hunt_results if @hunting
      pa "#{Game_DB.tx(:other, 0)}" if @hunting
      pa "#{Game_DB.tx(:cmd, 0)}", :cyan
      pa "#{Game_DB.tx(:cmd, 6)}", :cyan
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:cmd, 7)}", :cyan
      process_input
      update
    end
    if area == :menu
      draw_sub_menu
      process_item_menu if @itemmenu.any? {|v| v == true}
      pa "          #{Game_DB.tx(:other, 1)}", :magenta
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "                  #{Game_DB.tx(:cmd, 8)}", :magenta, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      pa "                  #{Game_DB.tx(:cmd, 9)}", :magenta, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      pa "                  #{Game_DB.tx(:cmd, 10)}", :magenta, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      pa "                  #{Game_DB.tx(:cmd, 11)}", :magenta, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      pa "                  #{Game_DB.tx(:cmd, 12)}", :magenta, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      pa "                  #{Game_DB.tx(:cmd, 13)}", :magenta, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      process_input
      update
    end
    if area == :shop  #shopmenu[false, false, false]
      process_shop_menu if @shopmenu.any? {|v| v == true}
      pa "#{Game_DB.tx(:common, 13)}", :green
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:common, 14)}", :green, :bright
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:common, 15)}", :cyan
      pa "#{Game_DB.tx(:common, 16)}", :cyan
      pa "#{Game_DB.tx(:common, 17)}", :cyan
      pa "#{Game_DB.tx(:cmd, 1)}", :cyan
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:cmd, 7)}", :cyan
      process_input
      update
    end
  end

  def print_hunt_results
    i = 2
    @enemies[:wandering].each do |e|
      break if i > 6
      pa "(#{i}): '#{Game_DB.enemies_array(e, 0)}', Level: #{Game_DB.enemies_array(e, 2)}", :blue, :bright if @player.level > Game_DB.enemies_array(e, 2)
      pa "(#{i}): '#{Game_DB.enemies_array(e, 0)}', Level: #{Game_DB.enemies_array(e, 2)}", :red, :bright if @player.level == Game_DB.enemies_array(e, 2)
      pa "(#{i}): '#{Game_DB.enemies_array(e, 0)}', Level: #{Game_DB.enemies_array(e, 2)}", :red if @player.level < Game_DB.enemies_array(e, 2)
      i += 1
    end
  end

  def process_shop_menu
    if @shopmenu[0] #============================   weapons shop   ===============================
      loop do
        clr
        draw_stats_main
        pa "#{Game_DB.tx(:common, 18)}", :green
        pa "#{Game_DB.tx(:other, 0)}"
        pa "#{Game_DB.tx(:other, 0)}"
        pa "#{Game_DB.tx(:cmd, 4)}", :cyan
        pa "#{Game_DB.tx(:cmd, 5)}", :cyan
        pa "#{Game_DB.tx(:cmd, 103)}", :cyan
        key = gets.chomp.to_i
        case key
        when 1 #buy
          clr
          draw_stats_main
          shopbag = Game_DB.weapons_array
          bagkeys = shopbag.keys
          bagkeys.delete_if {|i| i == 0}
          shopbag.each {|id, value| pa  "(#{id}): #{value[0]}, ATTACK: #{value[1]}, SPEED: #{value[2]}, 2-HANDED: #{value[3]}\n   > COST: #{value[4]}", :green unless id == 0 }
          pa "#{Game_DB.tx(:other, 0)}"
          pa "#{Game_DB.tx(:common, 22)}", :green, :bright
          loop do
            key = gets.chomp.to_i
            if bagkeys.include?(key)
              if @player.gold >= shopbag[key][4]
                @player.remove_gold(shopbag[key][4])
                @player.add_item(:weapon, key)
                pa "#{Game_DB.tx(:other, 0)}"
                pa " You purchased #{shopbag[key][0]} for #{shopbag[key][4]} gold! Dont forget to equip it!", :green, :bright
                key = gets
                break
              else
                pa " You don't have enough gold!", :red
                break
              end
            elsif key == 0
              @shopmenu[0] = false
              break
            end
          end
        when 2 #sell
          clr
          draw_stats_main
          pbag = @player.read_item_bag(:weapons)
          pbag.delete_if{|k, v| k == 0}
          pbagkeys = pbag.keys
          fullbag = Game_DB.weapons_array
          pbag.each {|k, v| pa "(#{k}): #{fullbag[k][0]}, SELL PRICE: #{fullbag[k][4]/2.to_i}", :green unless pbag[k] == 0}
          pa "#{Game_DB.tx(:other, 0)}"
          pa "#{Game_DB.tx(:common, 23)}", :green, :bright
          loop do
            key = gets.chomp.to_i
            if pbagkeys.include?(key)
              amt = fullbag[key][4] / 2; amt = amt.to_i
              @player.add_gold(amt)
              @player.remove_item(:weapon, key)
              pa "#{Game_DB.tx(:other, 0)}"
              pa "You sold #{fullbag[key][0]} for a mere #{amt} Gold. You feel somewhat cheated...", :green, :bright
              key = gets
              break
            elsif key == 0
              @shopmenu[0] = false
              break
            end
          end
        when 3 #exit
          @shopmenu[0] = false
          break
        end
      end
    elsif @shopmenu[1] #==========================   armor shop   ==================================
      loop do
        clr
        draw_stats_main
        pa "#{Game_DB.tx(:common, 19)}", :green
        pa "#{Game_DB.tx(:other, 0)}"
        pa "#{Game_DB.tx(:other, 0)}"
        pa "#{Game_DB.tx(:cmd, 4)}", :cyan
        pa "#{Game_DB.tx(:cmd, 5)}", :cyan
        pa "#{Game_DB.tx(:cmd, 103)}", :cyan
        key = gets.chomp.to_i
        case key
        when 1 #buy
          clr
          draw_stats_main
          shopbag = Game_DB.armor_array
          bagkeys = shopbag.keys
          bagkeys.delete_if {|i| i == 0}
          shopbag.each {|id, value| pa  "(#{id}): #{value[0]},  DEFENSE: #{value[1]}, SPEED: #{value[2]}\n   > COST: #{value[3]}", :green unless id == 0 }
          pa "#{Game_DB.tx(:other, 0)}"
          pa "#{Game_DB.tx(:common, 22)}", :green, :bright
          loop do
            key = gets.chomp.to_i
            if bagkeys.include?(key)
              if @player.gold >= shopbag[key][3]
                @player.remove_gold(shopbag[key][3])
                @player.add_item(:armor, key)
                pa "#{Game_DB.tx(:other, 0)}"
                pa " You purchased #{shopbag[key][0]} for #{shopbag[key][3]} gold! Dont forget to equip it!", :green, :bright
                key = gets
                break
              else
                pa " You don't have enough gold!", :red
                break
              end
            elsif key == 0
              @shopmenu[1] = false
              break
            end
          end
        when 2 #sell
          clr
          draw_stats_main
          pbag = @player.read_item_bag(:armor)
          pbag.delete_if{|k, v| k == 0}
          pbagkeys = pbag.keys
          fullbag = Game_DB.armor_array
          pbag.each {|k, v| pa "(#{k}): #{fullbag[k][0]}, SELL PRICE: #{fullbag[k][3]/2.to_i}", :green unless pbag[k] == 0}
          pa "#{Game_DB.tx(:other, 0)}"
          pa "#{Game_DB.tx(:common, 23)}", :green, :bright
          loop do
            key = gets.chomp.to_i
            if pbagkeys.include?(key)
              amt = fullbag[key][3] / 2; amt = amt.to_i
              @player.add_gold(amt)
              @player.remove_item(:armor, key)
              pa "#{Game_DB.tx(:other, 0)}"
              pa "You sold #{fullbag[key][0]} for a mere #{amt} Gold. You feel somewhat cheated...", :green, :bright
              key = gets
              break
            elsif key == 0
              @shopmenu[1] = false
              break
            end
          end
        when 3 #exit
          @shopmenu[1] = false
          break
        end
      end
    elsif @shopmenu[2] #================================   commons shop   ================================
      loop do
        clr
        draw_stats_main
        pa "#{Game_DB.tx(:common, 20)}", :green
        pa "#{Game_DB.tx(:other, 0)}"
        pa "#{Game_DB.tx(:other, 0)}"
        pa "#{Game_DB.tx(:cmd, 4)}", :cyan
        pa "#{Game_DB.tx(:cmd, 5)}", :cyan
        pa "#{Game_DB.tx(:cmd, 103)}", :cyan
        key = gets.chomp.to_i
        case key
        when 1 #buy
          clr
          draw_stats_main
          shopbag = Game_DB.items_array
          bagkeys = shopbag.keys
          bagkeys.delete_if {|i| i == 0}
          shopbag.each {|id, value| pa  "(#{id}): #{value[0]}, #{value[8]}\n   > COST: #{value[7]}", :green unless id == 0 }
          pa "#{Game_DB.tx(:other, 0)}"
          pa "#{Game_DB.tx(:common, 22)}", :green, :bright
          loop do
            key = gets.chomp.to_i
            if bagkeys.include?(key)
              if @player.gold >= shopbag[key][7]
                @player.remove_gold(shopbag[key][7])
                @player.add_item(:item, key)
                pa "#{Game_DB.tx(:other, 0)}"
                pa " You purchased #{shopbag[key][0]} for #{shopbag[key][7]} gold!", :green, :bright
                key = gets
                break
              else
                pa " You don't have enough gold!", :red
                break
              end
            elsif key == 0
              @shopmenu[2] = false
              break
            end
          end
        when 2 #sell
          clr
          draw_stats_main
          pbag = @player.read_item_bag(:items)
          pbag.delete_if{|k, v| k == 0}
          pbagkeys = pbag.keys
          fullbag = Game_DB.items_array
          pbag.each {|k, v| pa "(#{k}): #{fullbag[k][0]}, Amount Owned: x#{v}\n    > SELL PRICE: #{fullbag[k][7]/2.to_i} Gold", :green unless pbag[k] == 0}
          pa "#{Game_DB.tx(:other, 0)}"
          pa "#{Game_DB.tx(:common, 23)}", :green, :bright
          loop do
            key = gets.chomp.to_i
            if pbagkeys.include?(key)
              amt = fullbag[key][7] / 2; amt = amt.to_i
              @player.add_gold(amt)
              @player.remove_item(:item, key)
              pa "#{Game_DB.tx(:other, 0)}"
              pa "You sold #{fullbag[key][0]} for a mere #{amt} Gold. You feel somewhat cheated...", :green, :bright
              key = gets
              break
            elsif key == 0
              @shopmenu[2] = false
              break
            end
          end
        when 3 #exit
          @shopmenu[2] = false
          break
        end
      end
    end
    clr
    draw_stats_main
  end

  #N, W, E, S, 1(menu)
  #locations: :town, :arena, :tavern, :shop, :forest, :menu
  def process_input(area=@location[0])
    if area == :town
      loop do
        @update = true
        key = gets.chomp.downcase
        keyb = key.to_i #for number check
        case key
        when "n"
          @location[1] = @location[0]
          @location[0] = :arena
          break
        when "w"
          @location[1] = @location[0]
          @location[0] = :tavern
          break
        when "e"
          @location[1] = @location[0]
          @location[0] = :shop
          break
        when "s"
          @location[1] = @location[0]
          @location[0] = :forest
          break
        end
        if keyb == 1
          @location[1] = @location[0]
          @location[0] = :menu
          break
        end
      end
    elsif area == :shop
      loop do
        @update = true
        key = gets.chomp.downcase
        keyb = key.to_i #number input
        case key
        when "w" #back to town
          @location[1] = @location[0]
          @location[0] = :town
          break
        end
        if keyb == 1
          @location[1] = @location[0]
          @location[0] = :menu
          break
        elsif keyb == 3 #open weapons shop
          @shopmenu[0] = true
          break
        elsif keyb == 4 #open armor shop
          @shopmenu[1] = true
          break
        elsif keyb == 5 #open commons shop
          @shopmenu[2] = true
          break
        end
      end
    elsif area == :arena
      loop do
        @update = true
        key = gets.chomp.downcase
        keyb = key.to_i #for number check
        case key
        when "s"
          @location[1] = @location[0]
          @location[0] = :town
          break
        end
        if keyb == 1
          @location[1] = @location[0]
          @location[0] = :menu
          break
        end
      end
    elsif area == :forest
      loop do
        if !@hunting
          @update = true
          key = gets.chomp.downcase
          keyb = key.to_i #for number check
          case key
          when "n"
            @location[1] = @location[0]
            @location[0] = :town
            break
          when "l"
            calculate_enemies
            break
          when "a"
            calculate_enemies
            break
          end
          if keyb == 1
            @location[1] = @location[0]
            @location[0] = :menu
            break
          end
        end
        if @hunting # 2, 3, 4, 5, 6, (0..5) = selection limit
          @update = true
          key = gets.chomp.downcase
          keyb = key.to_i #for number check
          keys = @enemies[:wandering]
          length = @enemies[:wandering].length
          case key
          when "n"
            @location[1] = @location[0]
            @location[0] = :town
            break
          when "l"
            calculate_enemies
            break
          when "a"
            calculate_enemies
            break
          end
          if keyb == 1
            @location[1] = @location[0]
            @location[0] = :menu
            break
          end
          case keyb
          when 2 #enemy 1
            start_battle(@enemies[:wandering][0]) unless @enemies[:wandering][0] == nil
            break
          when 3 #enemy 2
            start_battle(@enemies[:wandering][1]) unless @enemies[:wandering][1] == nil
            break
          when 4 #enemy 3
            start_battle(@enemies[:wandering][2]) unless @enemies[:wandering][2] == nil
            break
          when 5 #enemy 4
            start_battle(@enemies[:wandering][3]) unless @enemies[:wandering][3] == nil
            break
          when 6 #enemy 5
            start_battle(@enemies[:wandering][4]) unless @enemies[:wandering][4] == nil
            break
          end
        end
      end
    elsif area == :tavern
      loop do
        @update = true
        key = gets.chomp.downcase
        keyi = key.to_i
        case key
        when "e"
          @location[1] = @location[0]
          @location[0] = :town
          break
        end
        if keyi == 2
          clr
          draw_stats_main
          price = @player.level * 3 + 3
          price = 20 if price > 20
          if price > @player.gold #not enough gold
            pa "#{Game_DB.tx(:other, 0)}"
            pa " You don't have enough gold to afford a room here.", :green
            pa "#{Game_DB.tx(:other, 0)}"
          else
            @player.heal(:full)
            @player.remove_gold(price)
            pa "#{Game_DB.tx(:other, 0)}"
            pa " You went to sleep. You woke up and your wounds are magically healed.", :green
            pa "#{Game_DB.tx(:other, 0)}"
          end
          pa "#{Game_DB.tx(:other, 7)}"
          key = gets
          break
        end
      end
    elsif area == :menu # @submenu = [stats, bag, spells, save game, exit game]
      loop do
        @update = true
        key = gets.chomp.to_i
        case key
        when 0
          @submenu[4] = true
          break
        when 1
          @submenu[0] = true
          break
        when 2
          @submenu[1] = true
          break
        when 3
          @submenu[2] = true
          break
        when 4 #exit menu go back to last location
          @location[0] = @location[1]
          break
        when 5
          @submenu[3] = true
          break
        end
      end
    end

  end

        #      [    0,   1,     2,          3,         4,]
  # @submenu = [stats, bag, spells, save game, exit game]
  def draw_sub_menu
    return if @submenu.all? { |v| v == false}
    clr
    draw_stats_main
    equiptextdata = {}
    equiptextdata[:left] = @player.get_equipment_text(:left)
    equiptextdata[:right] = @player.get_equipment_text(:right)
    equiptextdata[:armor] = @player.get_equipment_text(:armor)
    if @submenu[0] #player stats display
      spells = @player.spells_learned
      sp_names = []
      spells.each {|i| sp_names.push Game_DB.spellbook(i, 0) }
      names_conc = ""
      sp_names.each {|i| names_conc << i + ", "}
      b_names = ""
      if @player.badges.size > 0
        @player.badges.each {|i| b_names << i + "  "}
      end
      pa "                  Name:           #{@player.playername}", :blue, :bright
      pa "                  Race:           #{@player.race}", :blue, :bright
      pa "                  Level:          #{@player.level}", :blue, :bright
      pa "                  Exp:            #{@player.exp}/#{@stats[6]}", :blue, :bright
      pa "                  HP:             #{@stats[1]}/#{@stats[2]}", :blue, :bright
      pa "                  MP:             #{@stats[3]}/#{@stats[4]}", :blue, :bright
      pa "                  Base Strength:  #{@player.read_stat(:atk, :base)}", :red, :bright
      pa "                  Bonus Strength: #{@player.read_stat(:atk, :bonus)}", :red, :bright
      pa "                  Attack Power:   #{@player.final_stat(:atk)}", :red, :bright
      pa "                  Base Defense:   #{@player.read_stat(:def, :base)}", :green, :bright
      pa "                  Bonus Defense:  #{@player.read_stat(:def, :bonus)}", :green, :bright
      pa "                  Defense Power:  #{@player.final_stat(:def)}", :green, :bright
      pa "                  Base Speed:     #{@player.read_stat(:spd, :base)}", :yellow, :bright
      pa "                  Bonus Speed:    #{@player.read_stat(:spd, :bonus)}", :yellow, :bright
      pa "                  Total Speed:    #{@player.final_stat(:spd)}", :yellow, :bright
      pa "                  Spells Known:   #{names_conc}", :yellow, :bright
      pa "                  Equipment:", :magenta
      pa "                    Left Hand:   #{equiptextdata[:left][0]} +#{equiptextdata[:left][1]} Attack, +#{equiptextdata[:left][2]} Speed", :magenta, :bright
      pa "                    Right Hand:  #{equiptextdata[:right][0]} +#{equiptextdata[:right][1]} Attack, +#{equiptextdata[:right][2]} Speed", :magenta, :bright
      pa "                    Armor:       #{equiptextdata[:armor][0]} +#{equiptextdata[:armor][1]} Defense, +#{equiptextdata[:armor][2]} Speed", :magenta, :bright
      pa "                  Badges: ", :yellow
      pa "                         #{b_names}", :yellow
      pa "                  Total Damage Done:  #{@player.total_damage}", :red
      pa "                  Total Damage Taken: #{@player.damage_taken}", :green
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 3)}"
      key = gets
      @submenu[0] = false
    elsif @submenu[1] #player inventory
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:cmd, 18)}"
      pa "#{Game_DB.tx(:cmd, 19)}"
      pa "#{Game_DB.tx(:cmd, 20)}"
      pa "#{Game_DB.tx(:cmd, 26)}"
      @submenu[1] = false
      loop do
        key = gets.chomp.to_i
        case key
        when 1
          #open weapons screen
          @itemmenu[0] = true
          break
        when 2
          #open armor screen
          @itemmenu[1] = true
          break
        when 3
          #open items screen
          @itemmenu[2] = true
          break
        when 4
          #back to main menu
          @submenu[1] = false
          break
        end
      end
    elsif @submenu[2] #player Spells
      if @player.spells_learned.size < 1
        pa " Kind of hard to cast a spell when you don't know any...", :green
        key = gets
      else
        #spells known
        spellid = spell_selection
        sparray = Game_DB.spellbook[spellid]
        curmp = @player.read_cur_hpmp(:mp)
        cost = sparray[3]
        if spellid != 0
          if spellid == 1 || spellid == 2
            #heal
            if cost <= curmp
              draw_flash(:green, 6); healing = false
              sprange = Game_DB.spellbook(spellid, 2)
              amount = Game_DB.calc_spell_damage(sprange, @player.level, 0, 0, true)
              @player.heal(:hp, amount)
              @player.damage(:mp, Game_DB.spellbook(spellid, 3))
              pa " You cast the spell #{Game_DB.spellbook(spellid, 0)} and healed #{amount} HP!!!!", :green
            else
              pa " You try to cast the spell but don't have enough mp!", :magenta, :bright
            end
          else
            #damage
            pa " Would sure be a waste to cast that spell with no target...", :green
          end
          key = gets
        end
      end
      @submenu[2] = false
    elsif @submenu[3] #player save game
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 6)}", :red
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:cmd, 16)}"
      pa "#{Game_DB.tx(:cmd, 17)}"
      loop do
        key = gets.chomp.to_i
        case key
        when 1
          #save game file
          process_game_file_save
          @submenu[3] = false
          break
        when 2
          #dont save
          @submenu[3] = false
          break
        end
      end
    elsif @submenu[4] #player exit game
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 4)}", :red
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:cmd, 16)}"
      pa "#{Game_DB.tx(:cmd, 17)}"
      loop do
        key = gets.chomp.to_i
        case key
        when 1
          exit
        when 2
          @submenu[4] = false
          break
        end
      end
    end
    clr
    draw_stats_main
  end

  def process_item_menu
    clr
    draw_stats_main
    equiptextdata = {}
    equiptextdata[:left] = @player.get_equipment_text(:left)
    equiptextdata[:right] = @player.get_equipment_text(:right)
    equiptextdata[:armor] = @player.get_equipment_text(:armor)
    bag ={}
    if @itemmenu[0] #weapons screen selected
      bag = @player.read_item_bag(:weapons)
      pa "#{Game_DB.tx(:other, 0)}"
      pa "WEAPONS"
      pa "Equipped:"
      pa "    LEFT:  #{equiptextdata[:left][0]}, +#{equiptextdata[:left][1]} Attack, +#{equiptextdata[:left][2]} Speed"
      pa "    RIGHT: #{equiptextdata[:right][0]}, +#{equiptextdata[:right][1]} Attack, +#{equiptextdata[:right][2]} Speed"
      pa "Inventory: "
      bag.each {|id, amt| pa "  (#{id}) #{Game_DB.weapons_array(id, 0)}   x #{amt}" if amt > 0}
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:cmd, 21)}" #1 equip, 2 unequip, 4 back
      pa "#{Game_DB.tx(:cmd, 22)}"
      pa "#{Game_DB.tx(:cmd, 26)}"
      loop do
        key = gets.chomp.to_i
        case key
        when 1 #equip
          clr
          draw_stats_main
          pa "#{Game_DB.tx(:other, 0)}"
          pa "WEAPONS"
          pa "Equipped:"
          pa "    LEFT:  #{equiptextdata[:left][0]}, +#{equiptextdata[:left][1]} Attack, +#{equiptextdata[:left][2]} Speed"
          pa "    RIGHT: #{equiptextdata[:right][0]}, +#{equiptextdata[:right][1]} Attack, +#{equiptextdata[:right][2]} Speed"
          pa "Inventory: "
          bag.each {|id, amt| pa "  (#{id}) #{Game_DB.weapons_array(id, 0)}   x #{amt}" if amt > 0}
          pa "#{Game_DB.tx(:other, 0)}"
          pa "Equip which weapon? (choose number, or (0) to cancel)"
          loop do
            key = gets.chomp.to_i
            break if bag.key?(key) == false
            break if key == 0
            if bag.key?(key) && bag[key] > 0
              id = key
              twohd = Game_DB.weapons_array(id, 3)
              oldtwohd = Game_DB.weapons_array(@player.get_equipment_id(:lh), 3)
              pa "(1) Left hand or (2) Right hand?     (0): Cancel"
              key = gets.chomp.to_i
              if key == 1
                @player.unequip_weapon(3) if oldtwohd
                @player.equip_weapon(id, 1) unless twohd
                @player.equip_weapon(id, 3) if twohd
                pa "Weapon #{@player.get_equipment_text(:left)[0]} has been equipped!"
                key = gets
              elsif key == 2
                @player.unequip_weapon(3) if oldtwohd
                @player.equip_weapon(id, 2) unless twohd
                @player.equip_weapon(id, 3) if twohd
                pa "Weapon #{@player.get_equipment_text(:right)[0]} has been equipped!"
                key = gets
              else
                break
              end
              break
            end
          end
          break
        when 2 #unequip
          clr
          draw_stats_main
          pa "#{Game_DB.tx(:other, 0)}"
          pa "WEAPONS"
          pa "Equipped:"
          pa "    LEFT:  #{equiptextdata[:left][0]}, +#{equiptextdata[:left][1]} Attack, +#{equiptextdata[:left][2]} Speed"
          pa "    RIGHT: #{equiptextdata[:right][0]}, +#{equiptextdata[:right][1]} Attack, +#{equiptextdata[:right][2]} Speed"
          pa "Inventory: "
          bag.each {|id, amt| pa "  (#{id}) #{Game_DB.weapons_array(id, 0)}   x #{amt}" if amt > 0}
          pa "#{Game_DB.tx(:other, 0)}"
          pa "Unequip which weapon? (1) Left hand or (2) Right hand?     (0): Cancel"
          twohd = Game_DB.weapons_array(@player.get_equipment_id(:lh), 3)
          loop do
            key = gets.chomp.to_i
            break if key == 0
            break if key > 2
            if key == 1
              if @player.get_equipment_id(:lh) != 0
                @player.unequip_weapon(1)
                @player.unequip_weapon(2) if twohd
                pa "You unequipped your weapon from your Left hand and placed it in your bag"
              else
                pa "You can't unequip your Fists..."
              end
              key = gets
              break
            elsif key == 2
              if @player.get_equipment_id(:rh) != 0
                @player.unequip_weapon(2)
                @player.unequip_weapon(1) if twohd
                pa "You unequipped your weapon from your Right hand and placed it in your bag"
              else
                pa "You can't unequip your Fists..."
              end
              key = gets
              break
            end
          end
          break
        when 4 #cancel/Back
          @itemmenu[0] = false
          break
        end
      end
      @itemmenu[0] = false
    elsif @itemmenu[1] #armor screen selected
      bag = @player.read_item_bag(:armor)
      pa "#{Game_DB.tx(:other, 0)}"
      pa "ARMOR"
      pa "Equipped:"
      pa "    BODY:  #{equiptextdata[:armor][0]}, +#{equiptextdata[:armor][1]} Defense, +#{equiptextdata[:armor][2]} Speed"
      pa "Inventory: "
      bag.each {|id, amt| pa "  (#{id}) #{Game_DB.armor_array(id, 0)}   x #{amt}" if amt > 0}
      pa "#{Game_DB.tx(:other, 0)}"
      pa "#{Game_DB.tx(:cmd, 21)}" #1 equip, 2 unequip, 4 back
      pa "#{Game_DB.tx(:cmd, 22)}"
      pa "#{Game_DB.tx(:cmd, 26)}"
      loop do
        key = gets.chomp.to_i
        case key
        when 1 #equip armor
          clr
          draw_stats_main
          pa "#{Game_DB.tx(:other, 0)}"
          pa "ARMOR"
          pa "Equipped:"
          pa "    BODY:  #{equiptextdata[:armor][0]}, +#{equiptextdata[:armor][1]} Defense, +#{equiptextdata[:armor][2]} Speed"
          pa "Inventory: "
          bag.each {|id, amt| pa "  (#{id}) #{Game_DB.armor_array(id, 0)}   x #{amt}" if amt > 0}
          pa "#{Game_DB.tx(:other, 0)}"
          pa "Equip which Armor? (choose numer, or (0 to cancel))"
          loop do
            key = gets.chomp.to_i
            break if bag.key?(key) == false
            break if key == 0
            if bag.key?(key) && bag[key] > 0
              @player.equip_armor(key)
              pa "Armor #{@player.get_equipment_text(:armor)[0]} has been equipped!"
              key = gets
              break
            end
          end
          break
        when 2 #unequip armor
          clr
          draw_stats_main
          pa "#{Game_DB.tx(:other, 0)}"
          pa "ARMOR"
          pa "Equipped:"
          pa "    BODY:  #{equiptextdata[:armor][0]}, +#{equiptextdata[:armor][1]} Defense, +#{equiptextdata[:armor][2]} Speed"
          pa "Inventory: "
          bag.each {|id, amt| pa "  (#{id}) #{Game_DB.armor_array(id, 0)}   x #{amt}" if amt > 0}
          pa "#{Game_DB.tx(:other, 0)}"
          pa "Unequip your armor? Are you sure?"
          pa "#{Game_DB.tx(:other, 0)}"
          pa "#{Game_DB.tx(:cmd, 16)}" # 1 = yes, 2 = no
          pa "#{Game_DB.tx(:cmd, 17)}"
          loop do
            key = gets.chomp.to_i
            break if key == 2 || key != 1
            if key == 1
              if @player.get_equipment_id(:ar) != 0
                @player.unequip_armor
                pa "You unequipped your armor and placed it in your bag"
              else
                pa "You cant unequip your underwear."
              end
              key = gets
              break
            end
          end
          break
        when 4 #back
          @itemmenu[1] = false
          break
        end
      end
      @itemmenu[1] = false
    elsif @itemmenu[2] #items screen selected
      clr
      draw_stats_main
      bag = @player.read_item_bag(:items)
      pa "#{Game_DB.tx(:other, 0)}"
      pa "ITEMS"
      pa "Inventory:"
      bag.each {|id, amt| pa "  (#{id}) #{Game_DB.items_array(id, 0)} x #{amt} #{Game_DB.items_array(id, 8)}" if amt > 0}
      pa "#{Game_DB.tx(:other, 0)}"
      pa "Use which item? (choose number or 0 to cancel)"
      pa "You can use items even if you dont need them."
      pa "#{Game_DB.tx(:other, 0)}"
      loop do
        key = gets.chomp.to_i
        break if bag.key?(key) == false
        break if key == 0
        if bag.key?(key) && bag[key] > 0
          draw_flash(:green, 6)
          @player.use_item(key)
          key = gets
          break
        end
      end
      @itemmenu[2] = false
    end
    clr
    draw_stats_main
  end

  def startup_race_select
    pa "#{Game_DB.tx(:intro, 0)}", :green
    pa "#{Game_DB.tx(:other, 0)}"
    pa "#{Game_DB.tx(:other, 0)}"
    pa "#{Game_DB.tx(:other, 0)}"
    pa "#{Game_DB.tx(:other, 0)}"
    pa "#{Game_DB.tx(:intro, 1)}", :cyan
    pa "#{Game_DB.tx(:intro, 2)}", :cyan
    pa "#{Game_DB.tx(:intro, 3)}", :cyan
    loop do
      race = gets.chomp.to_i
      case race
      when 1 #dwarf
        @character_base[:race] = ["Dwarf", :dwarf]
        pa "You have selected #{@character_base[:race][0]}", :green, :bright
        break
      when 2 #human
        @character_base[:race] = ["Human", :human]
        pa "You have selected #{@character_base[:race][0]}", :green, :bright
        break
      when 3 #elf
        @character_base[:race] = ["Elf", :elf]
        pa "You have selected #{@character_base[:race][0]}", :green, :bright
        break
      end
    end
  end

  def startup_name_select
    pa "#{Game_DB.tx(:intro, 4)}", :green
    loop do
      name = gets.chomp
        if name.length > 20 || name.length <= 0
            pa "#{Game_DB.tx(:intro, 5)}", :red
            pa "#{Game_DB.tx(:intro, 4)}", :green
        else
          @character_base[:name] = name
          break
        end
    end
    pa "Your name is set to #{@character_base[:name]}", :green, :bright
  end

  def startup_finishing
    pa " Your race is #{@character_base[:race][0]}." + " You go by the name of #{@character_base[:name]}", :green, :bright
    pa "#{Game_DB.tx(:intro, 6)}", :green
    pa "#{Game_DB.tx(:other, 0)}"
    pa "#{Game_DB.tx(:other, 0)}"
    pa "#{Game_DB.tx(:other, 7)}", :green
    key = gets
  end

  def create_character
    @player = Player.new
    r = @character_base[:race][1]
    n = @character_base[:name]
    @player.finish_setup(r, n)
  end

  def startup_titlecard
    flasher = 0
    rnd = rand(1..11)
    text1 = Game_DB.tx(:other, 16) if rnd.even?
    text2 = Game_DB.tx(:other, 17) if rnd.even?
    text1 = Game_DB.tx(:other, 18) if rnd.odd?
    text2 = Game_DB.tx(:other, 19) if rnd.odd?
    10.times do
      clr
      flasher += 1
      pa "\r#{text1}", :red if flasher.even?
      pa "\r#{text1}", :red, :bright if flasher.odd?
      pa "\n"
      pa "\r#{text2}", :red if flasher.odd?
      pa "\r#{text2}", :red, :bright if flasher.even?
      sleep 0.01
      pa "\r#{ ' ' *text2.size}"
      sleep 0.01
    end
    clr
    pa "#{text1}", :red
    pa "\n"
    pa "#{text2}", :red
    pa "#{Game_DB.tx(:other, 12)}", :red, :bright
    pa "\n"
    pa "#{Game_DB.tx(:cmd, 14)}", :cyan
    pa "#{Game_DB.tx(:cmd, 15)}", :cyan
    loop do
      key = gets.chomp.downcase
      case key
      when "n"
        #new game
        startup_race_select
        startup_name_select
        startup_finishing
        create_character
        spawn_player
        break
      when "l"
        #load game
        pa "Load your save file? Are you sure?", :green, :bright
        pa "#{Game_DB.tx(:cmd, 16)}", :cyan
        pa "#{Game_DB.tx(:cmd, 17)}", :cyan
        loop do
          key = gets.chomp.to_i
          case key
          when 1
            #load saved game
            process_game_load_file
          when 2
            #dont load
            break
          end
        end

      end
    end
  end



end

Game = Game_Main.new
