class Enemy
  attr_accessor :id
#[Enemy name(0),race(1), lvl(2),  mhp(3),  mmp(4),  atk(5),  def(6),  spd(7),   exp(8),
# gold(9),  [drops](10), drop%(11), [spells](12), sp%(13)]
  def initialize(id=0)
    @readarray = Game_DB.enemies_array(id)
    @id = id
    @name = @readarray[0]
    @race = @readarray[1]
    @level = @readarray[2]
    @hp = @readarray[3]; @mhp = @readarray[3]
    @mp = @readarray[4]; @mmp = @readarray[4]
    @attack = @readarray[5]
    @defense = @readarray[6]
    @speed = @readarray[7]
    @exp = @readarray[8]
    @gold = @readarray[9]
    @drops = @readarray[10]
    @dropchance = @readarray[11]
    @spells = @readarray[12]
    @spellchance = @readarray[13]
    @alive = true
    @turn = false
  end

  def alive?
    @alive = false if @hp <= 0
    @alive = true if @hp > 0
    return @alive
  end

  def turn(turn)
    @turn = turn
  end

  def get_valid_spells
    var = @spells
    can_heal = knows_heal_spells?
    hppct = 100 * @hp / @mhp; hppct.to_i
    var[0] = 0 if hppct >= 75 #disable heal spells if health over 75%
    var.each {|spell| spell = 0 if Game_DB.spellbook(spell, 3) > @mp}
    return var
  end

  def knows_heal_spells?
    #return true if @spells.any? {|spell| spell == 1 || spell == 2 || spell == 13}
    retval = false
    @spells.each {|s|
     val = Game_DB.spell_heals?(s)
     retval = true if val == true}
    return retval
  end

  def enemy_casting?
    var = rand(1..100)
    if var <= @spellchance
      return true
    else
      return true if var > 95 unless @spellchance == 0
      return false
    end
  end

  def dropinfo(read_chance=false)
    return @drops if !read_chance
    return @dropchance if read_chance
  end

  #races: ghost(0), dwarf(1), human(2), elf(3), animal(4), demon(5)
  #stats symbols :race :lvl :hp :mhp :mp :mmp :atk :def :spd :exp :gold :drops :droprate :spells :spellchance
  def read_stat(stat=:race)
    if stat == :race
      retval = ""
      retval = "Ghost" if @race == 0
      retval = "Dwarf" if @race == 1
      retval = "Human" if @race == 2
      retval = "Elf" if @race == 3
      retval = "Animal" if @race == 4
      retval = "Demon" if @race == 5
      return retval
    end
    return @level if stat == :lvl || stat == :level
    return @hp if stat == :hp
    return @mhp if stat == :mhp
    return @mp if stat == :mp
    return @mmp if stat == :mmp
    return @attack if stat == :atk
    return @defense if stat  == :def
    return @speed if stat == :spd
    return @exp if stat == :exp
    return @gold if stat == :gold
    return @drops if stat == :drops #array
    return @dropchance if stat == :droprate
    return @spells if stat == :spells #array
    return @spellchance if stat == :spellchance
    return nil
  end

  def read_name
    return @name
  end

  #raw, basic damage no checks
  def damage(amount)
    @hp -= amount
    @hp = 0 if @hp < 0
  end

  def healHP(amount)
    @hp = @mhp if @hp + amount >= @mhp
    @hp += amount if @hp + amount < @mhp
  end

  def useMP(amount)
    @mp -= amount
    @mp = 0 if @mp < 0
  end


end
