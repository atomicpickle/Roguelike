10.times do
  print "\r#{ msg }"
  sleep 0.5
  print "\r#{ ' ' * msg.size }" # Send return and however many spaces are needed.
  sleep 0.5
end

# Bring the object back into Ruby
> my_saved_hash = JSON.parse(File.read("saved_hash.txt"))
# => {"name"=>"Dolph", "age"=>21}


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

h = { "a" => 100, "b" => 200 }
h.each {|key, value| puts "#{key} is #{value}" }

h = { "a" => 100, "b" => 200 }
h.each_key {|key| puts key }


%w[ant bear cat].all? { |word| word.length >= 3 } #=> true
%w[ant bear cat].all? { |word| word.length >= 4 } #=> false
%w[ant bear cat].all?(/t/)                        #=> false
[1, 2i, 3.14].all?(Numeric)                       #=> true
[nil, true, 99].all?                              #=> false
[].all?                                           #=> true

return if @submenu.all? { |v| v == false}

bag.each {|id, amt| pa "  (#{id}) #{Game_DB.weapons_array(id, 0)}   x #{amt}"}


require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::WARN

logger.debug("Created logger")
logger.info("Program started")
logger.warn("Nothing to do!")

path = "a_non_existent_file"

begin
  File.foreach(path) do |line|
    unless line =~ /^(\w+) = (.*)$/
      logger.error("Line in wrong format: #{line.chomp}")
    end
  end
rescue => err
  logger.fatal("Caught exception; exiting")
  logger.fatal(err)
end

logger = Logger.new('logfile.log')

Paint%['Yellow string with a %{blue_text} in it', :yellow,
  blue_text: ["blue text", :blue]
]


if id != 0
  pa  "(#{id}): #{value[0]} ATTACK: #{value[1]} SPEED: #{value[2]} TWO-HANDED", :green if value[3]
  pa "(#{id}): #{value[0]}"; pa "\033[1A ATTACK: #{value[2]}", :red, :bright; pa "\033[1A SPEED: #{value[2]}", :green, :bright if !value[3]
  pa "> COST: #{value[4]}", :green, :bright
end



if id != 0
  pa  "(#{id}): #{value[0]} ATTACK: #{value[1]} SPEED: #{value[2]} TWO-HANDED", :green if value[3]
  pa  "(#{id}): #{value[0]} ATTACK: #{value[1]} SPEED: #{value[2]}", :green if !value[3]
  pa "> COST: #{value[4]}", :green, :bright
end

 pa "(#{id}): #{value[0]}"; pa "\033[1A ATTACK: #{value[2]}", :red, :bright; pa "\033[1A SPEED: #{value[2]}", :green, :bright if !value[3]
 pa "(#{id}): #{value[0]}"; pa "^H ATTACK: #{value[1]}", :red, :bright; pa "^H SPEED: #{value[2]}", :green, :bright

string1 = "(#{id}): #{value[0]}"; str1 = string1.size
string2 = "ATTACK: #{value[1]}"; str2 = string2.size
string3 = "SPEED: #{value[2]}"; str3 = string3.size
pa string1; pa "\033[1A \033[#{str1}C #{string2}", :red, :bright; pa "\033[1A \033[#{str2}C #{string3}", :green, :bright

 - Move the cursor forward N columns:
   \033[<N>C

 10) Broad-L
#level reqs:
# Quest 0 -- level 4+
# Quest 1 -- level 1 to 3

3 == talk to tiny
4 == talk to rosco



" ██▀███   █    ██  ▄▄▄▄ ▓██   ██▓
▓██ ▒ ██▒ ██  ▓██▒▓█████▄▒██  ██▒
▓██ ░▄█ ▒▓██  ▒██░▒██▒ ▄██▒██ ██░
▒██▀▀█▄  ▓▓█  ░██░▒██░█▀  ░ ▐██▓░
░██▓ ▒██▒▒▒█████▓ ░▓█  ▀█▓░ ██▒▓░
░ ▒▓ ░▒▓░░▒▓▒ ▒ ▒ ░▒▓███▀▒ ██▒▒▒
  ░▒ ░ ▒░░░▒░ ░ ░ ▒░▒   ░▓██ ░▒░
  ░░   ░  ░░░ ░ ░  ░    ░▒ ▒ ░░
   ░        ░      ░     ░ ░
                        ░░ ░                   "
" ▄▄▄       ██▀███  ▓█████  ███▄    █  ▄▄▄
▒████▄    ▓██ ▒ ██▒▓█   ▀  ██ ▀█   █ ▒████▄
▒██  ▀█▄  ▓██ ░▄█ ▒▒███   ▓██  ▀█ ██▒▒██  ▀█▄
░██▄▄▄▄██ ▒██▀▀█▄  ▒▓█  ▄ ▓██▒  ▐▌██▒░██▄▄▄▄██
 ▓█   ▓██▒░██▓ ▒██▒░▒████▒▒██░   ▓██░ ▓█   ▓██▒
 ▒▒   ▓▒█░░ ▒▓ ░▒▓░░░ ▒░ ░░ ▒░   ▒ ▒  ▒▒   ▓▒█░
  ▒   ▒▒ ░  ░▒ ░ ▒░ ░ ░  ░░ ░░   ░ ▒░  ▒   ▒▒ ░
  ░   ▒     ░░   ░    ░      ░   ░ ░   ░   ▒
      ░  ░   ░        ░  ░         ░       ░  ░
                                               "
