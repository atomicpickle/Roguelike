
# @questarray[1] = "description"

# Required enemies:
# @questarray[2] = [{:enemy => amt}, {enemy => amt}]

# pack = [@quests[:name][id], @quests[:details][id], @quests[:require][id], @quests[:rewards][id]]
# pack = ["Name", "details", req[{},{}], rew[{},{}], "complete_msg"]

#level reqs:
# Quest 0 -- level 4+
# Quest 1 -- level 1 to 3



class Quest
  #
  attr_reader :name
  attr_reader :details
  attr_reader :rewards
  attr_reader :comptext
  attr_reader :progress

  def initialize(id)
    @questarray = Game_DB.read_quest_array(id)
    @name     = @questarray[0]
    @details  = @questarray[1]
    @required = @questarray[2]
    @rewards  = @questarray[3]
    @comptext = @questarray[4]

    @progress = {}
    @progress[:enemy] = {}
    @progress[:item] = {}
    @complete = false
    setup_progress
  end

  # [{:enemy => [3, 10]}, {:item => [1, 1]}]
  def setup_progress
    n = 0
    @required.each do |i|
      if i.key?(:enemy)
        id = i[:enemy][0]
        @progress[:enemy][id] = [0, i[:enemy][1]]
      elsif i.key?(:item)
        id = i[:item][0]
        @progress[:item][id] = [0, i[:item][1]]
      end
      n += 1
    end
  end

  def is_needed?(type=:item, id=0)
    retval = false
    if type == :enemy
      if @progress[:enemy].size > 0
        @progress[:enemy].each do |k,v|
          retval = true if k == id && v[0] < v[1]
        end
      end
    elsif type == :item
      if @progress[:item].size > 0
        @progress[:item].each do |k,v|
          retval = true if k == id && v[0] < v[1]
        end
      end
    end
    return retval
  end

  def read_current_progress
    string = ""
    enemy = ""
    item = ""
    if @progress[:enemy].size > 0
      @progress[:enemy].each do |k, v|
        enemy = Game_DB.enemies_array(k, 0)
        str1 = "#{enemy}: #{v[0]}/#{v[1]}\n"
        string << str1
      end
    end
    if @progress[:item].size > 0
      @progress[:item].each do |k, v|
        item = Game_DB.items_array(k, 0)
        str2 = "#{item}: #{v[0]}/#{v[1]}\n"
        string << str2
      end
    end
    return string
  end



  def iterate_progress(type=:symb, id=0, amount=1)
    if type == :enemy
      if @progress[:enemy][id][0] >= @progress[:enemy][id][1]
        return
      else
        @progress[:enemy][id][0] += amount
      end
    elsif type == :item
      if @progress[:item][id][0] >= @progress[:item][id][1]
        return
      else
        @progress[:item][id][0] += amount
      end
    end
    check_if_complete
  end

  def check_if_complete
    iterate = false
    iterate2 = false
    if @progress[:enemy].size > 0
      @progress[:enemy].each {|k,v| iterate = true if v[0] >= v[1]}
      @progress[:enemy].each {|k,v| iterate = false if v[0] < v[1]}
    end
    if @progress[:item].size > 0
      @progress[:item].each {|k,v| iterate2 = true if v[0] >= v[1]}
      @progress[:item].each {|k,v| iterate2 = false if v[0] < v[1]}
    end
    @complete = true if iterate && @progress[:item].size <= 0
    @complete = true if iterate && iterate2
    @complete = true if iterate2 && @progress[:enemy].size <= 0
    return @complete
  end

  def complete?(val=true)
    return @complete if val
    return @comptext if !val
  end

end
