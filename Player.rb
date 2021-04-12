=begin
Commands reference (incomplete)
Player.set_name("name")
Player.set_race(:race)
Player.add_gold(value)
Player.remove_gold(value)
Player.add_exp(value)           #adds exp, then does level up checking
Player.read_stat(:stat)         #stats symbols :hp :mp :atk :def :spd, returns attack + perm added atk
Player.final_stat(:stat)        #reports final stat (atk + added_atk + Weapon + Armor)
Player.add_bonus_stat(:stat, value)
Player.add_stat(:stat, value)
Player.rem_stat(:stat, value)
Player.set_stat(:stat, value)
Player.equip_weapon(id, hand)   #hand = 1 for left, 2 for right, 3 for 2handed weapon
Player.unequip_weapon(id, hand)
Player.equip_armor(id)
Player.unequip_armor
Player.learn_spell(id)
Player.add_item(:type, id)     #item_type = :weapon, :armor, :item, item_id = key value for item in DB
Player.remove_item(:type, id)
Player.damage(:type, value) # :hp or :mp
=end
class Player
  attr_reader :playername
  attr_reader :race
  attr_reader :level
  attr_reader :gold
  attr_reader :exp
  attr_reader :damage_taken
  attr_reader :badges
  attr_reader :perm_readers
  attr_accessor :levelUP
  attr_accessor :total_damage

  def initialize
    @bag = {}
    # @bag[:weapons][key_id] = amount
    # key id is item id. amount is 0 if player has none
    @bag[:weapons] = {}
    @bag[:armor] = {}
    @bag[:items] = {}
    @equip = {}
    @equip['weapon'] = [1, 0]
    @equip['armor'] = [0]
    @spells = []
    @gold = 0
    @exp = 0
    @level = 0
    @levelUP = false
    @total_damage = 0
    @damage_taken = 0
                 #  [speed,  atk,   def, rewards]
    @perm_readers = [false, false, false, false]
    @badge_progress = {}
    @badges = []
    @curr_badge_arena = ""
    @race = :ghost
    @playername = ""
    #add extra stat vars for permanent stat bonuses
    @hp = 1; @mhp = 1
    @mp = 0; @mmp = 0
    @attack = 1
    @defense = 1
    @speed = 1
    #for added perm stats on top of level based stats
    @added_stats = {}
    @added_stats[:hp] = 0
    @added_stats[:mp] = 0
    @added_stats[:atk] = 0
    @added_stats[:def] = 0
    @added_stats[:spd] = 0
  end

  def add_badge(strings, bool=true)
    @badges.push strings unless @badges.include?(strings)
    add_badge_progress(strings) if bool
  end

  def force_badge(badge)
    curr = @badges.fetch(-1)
    @badge_progress[curr] = 5
    @badge_progress[badge] = 1
    add_badge(badge, false)
  end

  def add_next_badge
    string = @curr_badge_arena
    string = string[0]
    newbadge = ""
    newb = false
    if @badge_progress[string] >= 5
      newbadge = Game_DB.find_next_badge(string)
      @badge_progress[newbadge] = 1
      add_badge(newbadge, false)
      newb = true
    end
    return [string, false] if !newb
    return [newbadge, true] if newb
  end

  def add_badge_progress(id)
    id = id.to_s
    bool = badge_complete?(id)
    @badge_progress[id] += 1 if !bool
  end

  def badge_complete?(id)
    return true if @badge_progress[id] >= 5
    return false if @badge_progress[id] < 5
  end

  def get_current_badge
    proghash = @badge_progress.dup
    proghash.reject! {|k,v| v >= 5}
    proghash.reject! {|k,v| v == 0}
    return proghash
  end

  def read_badges(progress=false)
    return @badges if !progress
    return @badge_progress if progress
  end

  def set_current_badge_arena(string)
    @curr_badge_arena = string
  end

  def read_current_badge_arena
    return @curr_badge_arena
  end

  def read_cur_hpmp(type=:hp)
    return @hp if type == :hp
    return @mp if type == :mp
  end

   # type: :hp or :mp
  def damage(type, value)
    @hp -= value if type == :hp
    @damage_taken += value if type == :hp
    @hp = 0 if @hp < 0
    @mp -= value if type == :mp
    @mp = 0 if @mp < 0
  end

  # TYPES: :hp, :mp, :full
  def heal(type, value=0)
    if type == :hp
      mxc = @hp + value
      @hp = read_stat(:hp) if mxc >= read_stat(:hp)
      @hp += value if mxc < read_stat(:hp)
    elsif type == :mp
      mxc = @mp + value
      @mp = read_stat(:mp) if mxc >= read_stat(:mp)
      @mp += value if mxc < read_stat(:mp)
    elsif :full
      @hp = read_stat(:hp)
      @mp = read_stat(:mp)
    end
  end

  #stats symbols :hp :mp :atk :def :spd    add_bonus_stat(stat, amount)
  def use_item(id)
    remove_item(:item, id)
    array = Game_DB.items_array(id)
    if id == 1
      heal(:hp, array[1])
      pa "You used 1x #{array[0]} and recovered #{array[1]} HP!", :blue, :bright
    elsif id == 2
      heal(:mp, array[2])
      pa "You used 1x #{array[0]} and recovered #{array[2]} MP!", :blue, :bright
    elsif id == 3
      heal(:hp, array[1])
      pa "You used 1x #{array[0]} and recovered #{array[1]} HP!", :blue, :bright
    elsif id == 4
      heal(:mp, array[2])
      pa "You used 1x #{array[0]} and recovered #{array[2]} MP!", :blue, :bright
    elsif id == 5
      heal(:hp, array[1])
      pa "You used 1x #{array[0]} and recovered #{array[1]} HP!", :blue, :bright
    elsif id == 6
      heal(:hp, array[1])
      heal(:mp, array[2])
      pa "You used 1x #{array[0]} and recovered #{array[1]} HP and #{array[2]} MP!", :blue, :bright
    elsif id == 7
      res = rand(-1..array[3])
      add_bonus_stat(:hp, res)
      pa "You used 1x #{array[0]} and your MAX HP was INCREASED by #{res}!", :blue, :bright if res >= 0
      pa "You used 1x #{array[0]} and your MAX HP was DECREASED by #{res}!", :blue, :bright if res < 0
    elsif id == 8
      res = rand(-1..array[4])
      add_bonus_stat(:mp, res)
      pa "You used 1x #{array[0]} and your MAX MP was INCREASED by #{res}!", :blue, :bright if res >= 0
      pa "You used 1x #{array[0]} and your MAX MP was DECREASED by #{res}!", :blue, :bright if res < 0
    elsif id == 9
      res = rand(-1..array[5])
      add_bonus_stat(:atk, res)
      pa "You used 1x #{array[0]} and your ATTACK was INCREASED by #{res}!", :blue, :bright if res >= 0
      pa "You used 1x #{array[0]} and your ATTACK was DECREASED by #{res}!", :blue, :bright if res < 0
    elsif id == 10
      res = rand(-1..array[6])
      add_bonus_stat(:def, res)
      pa "You used 1x #{array[0]} and your DEFENSE was INCREASED by #{res}!", :blue, :bright if res >= 0
      pa "You used 1x #{array[0]} and your DEFENSE was DECREASED by #{res}!", :blue, :bright if res < 0
    elsif id == 11
      hp = rand(-1..array[3]); mp = rand(-1..array[4])
      atk = rand(-1..array[5]); deb = rand(-1..array[6]); spd = rand(-1..10)
      add_bonus_stat(:hp, hp); add_bonus_stat(:mp, mp)
      add_bonus_stat(:atk, atk); add_bonus_stat(:def, deb)
      add_bonus_stat(:spd, spd)
      pa "You used 1x #{array[0]}...", :blue, :bright
      pa "Your MAX HP was INCREASED by #{hp}", :blue, :bright if hp >= 0
      pa "Your MAX HP was DECREASED by #{hp}", :blue if hp < 0
      pa "Your MAX MP was INCREASED by #{mp}", :blue, :bright if mp >= 0
      pa "Your MAX MP was DECREASED by #{mp}", :blue if mp < 0
      pa "Your ATTACK was INCREASED by #{atk}", :blue, :bright if atk >= 0
      pa "Your ATTACK was DECREASED by #{atk}", :blue if atk < 0
      pa "Your DEFENSE was INCREASED by #{deb}", :blue, :bright if deb >= 0
      pa "Your DEFENSE was DECREASED by #{deb}", :blue if deb < 0
      pa "Your SPEED was INCREASED by #{spd}", :blue, :bright if deb >= 0
      pa "Your SPEED was DECREASED by #{spd}", :blue if deb < 0
    elsif id == 12
      add_perm_reader(0)
      pa " You used a #{array[0]}, you can now permanently see an enemies Speed in battle!", :blue, :bright
    elsif id == 13
      add_perm_reader(1)
      pa " You used a #{array[0]}, you can now permanently see an enemies Attack in battle!", :blue, :bright
    elsif id == 14
      add_perm_reader(2)
      pa " You used a #{array[0]}, you can now permanently see an enemies Defense in battle!", :blue, :bright
    elsif id == 15
      add_perm_reader(3)
      pa " You used a #{array[0]}, you can now permanently see an enemies Rewards in battle!", :blue, :bright
    elsif id == 17
      res = rand(-1..array[3])
      lvlcap = item_lvlcap?(:hp)
      if lvlcap
        pa " You need to be a higher level to boost that stat!"
        add_item(:item, id)
      else
        add_bonus_stat(:hp, res)
        pa "You used 1x #{array[0]} and your MAX HP was INCREASED by #{res}!", :blue, :bright if res >= 0
        pa "You used 1x #{array[0]} and your MAX HP was DECREASED by #{res}!", :blue, :bright if res < 0
      end
    elsif id == 18
      res = rand(-1..array[4])
      lvlcap = item_lvlcap?(:mp)
      if lvlcap
        pa " You need to be a higher level to boost that stat!"
        add_item(:item, id)
      else
        add_bonus_stat(:mp, res)
        pa "You used 1x #{array[0]} and your MAX MP was INCREASED by #{res}!", :blue, :bright if res >= 0
        pa "You used 1x #{array[0]} and your MAX MP was DECREASED by #{res}!", :blue, :bright if res < 0
      end
    elsif id == 19
      res = rand(-1..array[5])
      lvlcap = item_lvlcap?(:atk)
      if lvlcap
        pa " You need to be a higher level to boost that stat!"
        add_item(:item, id)
      else
        add_bonus_stat(:atk, res)
        pa "You used 1x #{array[0]} and your ATTACK was INCREASED by #{res}!", :blue, :bright if res >= 0
        pa "You used 1x #{array[0]} and your ATTACK was DECREASED by #{res}!", :blue, :bright if res < 0
      end
    elsif id == 20
      res = rand(-1..array[6])
      lvlcap = item_lvlcap?(:def)
      if lvlcap
        pa " You need to be a higher level to boost that stat!"
        add_item(:item, id)
      else
        add_bonus_stat(:def, res)
        pa "You used 1x #{array[0]} and your DEFENSE was INCREASED by #{res}!", :blue, :bright if res >= 0
        pa "You used 1x #{array[0]} and your DEFENSE was DECREASED by #{res}!", :blue, :bright if res < 0
      end
    end
  end

  def item_lvlcap?(stat)
    lvlcap = false
    lvlcap = true if @level <= 1 && @added_stats[stat] >= 3
    lvlcap = true if @added_stats[stat] > @level * 4
    return lvlcap
  end
  #  [speed,  atk,   def, rewards]
  def add_perm_reader(stat=0)
    @perm_readers[stat] = true
  end

  def finish_setup(race, name, lvl=0)
    set_name(name)
    set_race(race)
    lvlarray = Game_DB.level_stats_array(@race, lvl)
    set_stat(:hp, lvlarray[0])
    set_stat(:mp, lvlarray[1])
    set_stat(:atk, lvlarray[2])
    set_stat(:def, lvlarray[3])
    set_stat(:spd, lvlarray[4])
    learn_spell(lvlarray[5]) if lvlarray[5] != nil
    @hp = read_stat(:hp)
    @mp = read_stat(:mp)
    @total_damage = 0 if @total_damage == nil
    @damage_taken = 0 if @damage_taken == nil
    format_bag
    rebuild_badge_progress_array
  end

  def finish_reload
    lvlarray = Game_DB.level_stats_array(@race, @level)
    set_stat(:hp, lvlarray[0])
    set_stat(:mp, lvlarray[1])
    set_stat(:atk, lvlarray[2])
    set_stat(:def, lvlarray[3])
    set_stat(:spd, lvlarray[4])
    @total_damage = 0 if @total_damage == nil
    @damage_taken = 0 if @damage_taken == nil
    re_format_bag
    rebuild_badge_progress_array
  end

  # @bag[:weapons], @bag[:armor]
  # @bag[:weapons][key_id] = amount
  def format_bag
    all_weaps = Game_DB.weapons_array
    all_armor = Game_DB.armor_array
    all_items = Game_DB.items_array
    all_weaps.each_key {|key| @bag[:weapons][key] = 0}
    all_armor.each_key {|key| @bag[:armor][key] = 0}
    all_items.each_key {|key| @bag[:items][key] = 0}
  end

  #if new items are added after a game is saved, this will reformat the bag on game load
  def re_format_bag
    all_weaps = Game_DB.weapons_array
    all_armor = Game_DB.armor_array
    all_items = Game_DB.items_array
    all_weaps.each_key {|key| @bag[:weapons][key] = 0 unless @bag[:weapons].has_key?(key)}
    all_armor.each_key {|key| @bag[:armor][key] = 0 unless @bag[:armor].has_key?(key)}
    all_items.each_key {|key| @bag[:items][key] = 0 unless @bag[:items].has_key?(key)}
  end

  # item = :left, :right, :armor
  # Return ItemName: +xx Attack +xx Speed
  def get_equipment_text(item)
    equip = {}
    equip[:weapons] = @equip['weapon']
    equip[:armor] = @equip['armor']
    if item == :left
      name = Game_DB.weapons_array(equip[:weapons][0], 0)
      attk = Game_DB.weapons_array(equip[:weapons][0], 1)
      spd = Game_DB.weapons_array(equip[:weapons][0], 2)
      attk.to_s; spd.to_s
      stake = [name, attk, spd]
      return stake
    end
    if item == :right
      name = Game_DB.weapons_array(equip[:weapons][1], 0)
      attk = Game_DB.weapons_array(equip[:weapons][1], 1)
      spd = Game_DB.weapons_array(equip[:weapons][1], 2)
      attk.to_s; spd.to_s
      stake = [name, attk, spd]
      return stake
    end
    if item == :armor
      name = Game_DB.armor_array(equip[:armor][0], 0)
      defs = Game_DB.armor_array(equip[:armor][0], 1)
      spd = Game_DB.armor_array(equip[:armor][0], 2)
      defs.to_s; spd.to_s
      stake = [name, defs, spd]
      return stake
    end
  end

  # returns equipment ID. :lh = left hand, :rh = right, :ar = armor
  def get_equipment_id(item=:lh)
    return @equip['weapon'][0] if item == :lh
    return @equip['weapon'][1] if item == :rh
    return @equip['armor'][0] if item == :ar
  end

  def set_name(name)
    @playername = name if name.is_a? String
  end

  #races: :ghost, :dwarf, :human, :elf, :animal, :demon
  def set_race(r)
    @race = r if r.is_a? Symbol
  end

  def add_gold(amount)
    @gold += amount
  end

  def remove_gold(amount)
    @gold -= amount
    @gold = 0 if @gold < 0
  end

  def add_exp(a)
    @exp += a
    level_up_chk
  end

  # level array [ mhp, mmp, atk, def, spd, spell] 0..5
  # exp array   [amount, total] 0..1
  #stats symbols :hp :mp :atk :def :spd
  def level_up_chk
    return if @level >= 20
    lvlnext = @level + 1
    nextlvlary = Game_DB.level_stats_array(@race, lvlnext)
    expnext = Game_DB.experience_array(lvlnext, @race)
    if @exp >= expnext[1]
      level_up(true)
      set_stat(:hp, nextlvlary[0])
      set_stat(:mp, nextlvlary[1])
      set_stat(:atk, nextlvlary[2])
      set_stat(:def, nextlvlary[3])
      set_stat(:spd, nextlvlary[4])
      learn_spell(nextlvlary[5]) if nextlvlary[5] != nil
      @levelUP = true
    end
  end

  def lvl_up_override(maxlvl=0)
    return if @level >= 20
    lvlnext = @level + 1
    loop do
      nextlvlary = Game_DB.level_stats_array(@race, lvlnext)
      expnext = Game_DB.experience_array(lvlnext, @race)
      @exp = expnext[1]
      level_up(true)
      set_stat(:hp, nextlvlary[0])
      set_stat(:mp, nextlvlary[1])
      set_stat(:atk, nextlvlary[2])
      set_stat(:def, nextlvlary[3])
      set_stat(:spd, nextlvlary[4])
      learn_spell(nextlvlary[5]) if nextlvlary[5] != nil
      lvlnext += 1
      add_badge(Game_DB.tx(:badges, 0)) if @level == 4
      break if @level >= maxlvl
    end
  end

  def level_up(bool)
    @level += 1 if bool
  end

  #reports stat total (atk + added_atk)
  #stats symbols :hp :mp :atk :def :spd
  #mode :add :base :bonus
  def read_stat(stat, mode=:add)
    var = @mhp + @added_stats[stat] if stat == :hp && mode == :add
    var = @mmp + @added_stats[stat] if stat == :mp && mode == :add
    var = @attack + @added_stats[stat] if stat == :atk && mode == :add
    var = @defense + @added_stats[stat] if stat == :def && mode == :add
    var = @speed + @added_stats[stat] if stat == :spd && mode == :add
    var = @added_stats[stat] if mode == :bonus
    var = @mhp if stat == :hp && mode == :base
    var = @mmp if stat == :mp && mode == :base
    var = @attack if stat == :atk && mode == :base
    var = @defense if stat == :def && mode == :base
    var = @speed if stat == :spd && mode == :base
    return var
  end

  #reports final stat (atk + added_atk + Weapon + Armor)
  #stats symbols :hp :mp :atk :def :spd
  def final_stat(stat)
    var = read_stat(stat)
    return var unless stat == :atk || stat == :def || stat == :spd #reports max hp OR mp
    if stat == :atk
      lh = @equip['weapon'][0]
      rh = @equip['weapon'][1]
      return var if lh == 0 && rh == 0 #no equip, return attak power
      if lh != 0 #fetch left hand equip attack Power
        weap = Game_DB.weapons_array(lh)
        power = weap[1]
        left = var + power
        if !weap[3] && rh != 0 #two 1 handed weaps equipped?
          weap2 = Game_DB.weapons_array(rh)
          power2 = weap2[1]
          right = power2
          result = left + right  #return attack of both weaps
          return result
        end
        result = left
        return result #only left hand equipped or 2 handed, return attack power
      elsif rh != 0
        weap = Game_DB.weapons_array(rh)
        power = weap[1]
        right = var + power
        return right if !weap[3] #1 handed weapon only on right hand, left hand empty
      end

    end
    #return total defense stats + armor
    if stat == :def
      armor = @equip['armor'][0]
      return var if armor == 0
      fetch = Game_DB.armor_array(armor)
      armrdef = fetch[1]
      result = var + armrdef
      return result
    end
    #return total speed stats + weapon + armor
    if stat == :spd
      lh = @equip['weapon'][0]
      rh = @equip['weapon'][1]
      armor = @equip['armor'][0]
      wspd = 0; aspd = 0 #containers used for final values
      weap2chk = Game_DB.weapons_array(lh)
      if weap2chk[3] #2 handed weapon
        weap = Game_DB.weapons_array(lh)
        wspd = weap[2]
      elsif lh != 0 || rh != 0 #left or right handed, or two one handed weaps
        weap1 = 0; weap2 = 0
        weap1 = Game_DB.weapons_array(lh) unless lh == 0
        weap2 = Game_DB.weapons_array(rh) unless rh == 0
        wspd += weap1[2] unless lh == 0
        wspd += weap2[2] unless rh == 0
      end
      if armor != 0
        arm = Game_DB.armor_array(armor)
        aspd = arm[2]
      else
        aspd = 0
      end
      result = var + aspd + wspd
      return result
    end
  end


  #stats symbols :hp :mp :atk :def :spd add_bonus_stat(stat, amount)
  def add_bonus_stat(stat, amount)
    return if stat == nil || amount == nil
    @added_stats[stat] += amount
  end

  #stats symbols :hp :mp :atk :def :spd
  def add_stat(stat, amount)
    return if stat == nil
    @mhp += amount if stat == :hp
    @mmp += amount if stat == :mp
    @attack += amount if stat == :atk
    @defense += amount if stat == :def
    @speed += amount if stat == :spd
  end
  #stats symbols :hp :mp :atk :def :spd
  def rem_stat(stat, amount)
    return if stat == nil
    @mhp -= amount if stat == :hp
    @mmp -= amount if stat == :mp
    @attack -= amount if stat == :atk
    @defense -= amount if stat == :def
    @speed -= amount if stat == :spd
  end
  #stats symbols :hp :mp :atk :def :spd
  def set_stat(stat, amount)
    return if stat == nil
    @mhp = amount if stat == :hp
    @mmp = amount if stat == :mp
    @attack = amount if stat == :atk
    @defense = amount if stat == :def
    @speed = amount if stat == :spd
  end

  #spell id = key for spell db hash
  def learn_spell(spellid)
    @spells << spellid unless @spells.include? spellid
  end

  def spells_learned
    return @spells
  end

  # @bag[:weapons], @bag[:armor]
  # @bag[:weapons][key_id] = amount
  #hand = 1 for left, 2 for right, 3 for 2handed weapon
  def equip_weapon(weaponid, hand)
    return if hand <= 0 && hand >= 4 || hand == nil
    return unless @bag[:weapons][weaponid] > 0
    if hand == 1 # left hand
      unequip_weapon(hand)
      remove_item(:weapon, weaponid)
      @equip['weapon'][0] = weaponid
    elsif hand == 2 #right hand
      unequip_weapon(hand)
      remove_item(:weapon, weaponid)
      @equip['weapon'][1] = weaponid
    elsif hand == 3 #2 handed
      if Game_DB.weapons_array(@equip['weapon'][0], 3)
        unequip_weapon(hand)
      else
        unequip_weapon(1) if @equip['weapon'][0] > 0
        unequip_weapon(2) if @equip['weapon'][1] > 0
      end
      remove_item(:weapon, weaponid)
      @equip['weapon'][0] = weaponid
      @equip['weapon'][1] = weaponid
    end
  end

  #hand = 1 for left, 2 for right, 3 for 2handed weapon
  def unequip_weapon(hand)
    return if hand <= 0 && hand >= 4 || hand == nil
    if hand == 1 # left hand
      if @equip['weapon'][0] != 0
        add_item(:weapon, @equip['weapon'][0])
        @equip['weapon'][0] = 0
      end
    elsif hand == 2 #right hand
      if @equip['weapon'][1] != 0
        add_item(:weapon, @equip['weapon'][1])
        @equip['weapon'][1] = 0
      end
    elsif hand == 3 #2 handed
      if @equip['weapon'][0] != 0 && @equip['weapon'][1] != 0
        add_item(:weapon, @equip['weapon'][0])
        @equip['weapon'][0] = 0; @equip['weapon'][1] = 0
      end
    end
  end

  def equip_armor(armorid)
    unequip_armor
    remove_item(:armor, armorid)
    @equip['armor'][0] = armorid
  end

  def unequip_armor
    if @equip['armor'][0] != 0
      add_item(:armor, @equip['armor'][0])
      @equip['armor'][0] = 0
    end
  end

  # @bag[:weapons], @bag[:armor]
  # @bag[:weapons][key_id] = amount
  #item_type = :weapon, :armor, :item, item_id = key value for item in DB
  def add_item(item_type, item_id)
    return if item_type == nil || item_id == nil
    if item_type == :weapon
      @bag[:weapons][item_id] += 1
    elsif item_type == :armor
      @bag[:armor][item_id] += 1
    elsif item_type == :item
      @bag[:items][item_id] += 1
    end

  end

  #item_type = :weapon, :armor, :item, item_id = key value for item in DB
  def remove_item(item_type, item_id)
    return if item_type == nil || item_id == nil
    if item_type == :weapon
      @bag[:weapons][item_id] -= 1 unless @bag[:weapons][item_id] <= 0
    elsif item_type == :armor
      @bag[:armor][item_id] -= 1 unless @bag[:armor][item_id] <= 0
    elsif item_type == :item
      @bag[:items][item_id] -= 1 unless @bag[:items][item_id] <= 0
    end
  end

  #returns the appropriate item types, :weapons, :armor, :items
  def read_item_bag(type=:items)
    return @bag[:weapons] if type == :weapons
    return @bag[:armor] if type == :armor
    return @bag[:items] if type == :items
  end

  def rebuild_badge_progress_array
    badges = Game_DB.tx(:badges)
    badge_strings = badges.values
    badge_strings.each do |i|
      @badge_progress[i] = 0 unless @badge_progress.has_key?(i)
    end
  end





end
