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



@experience_req[0]  = [     0,     0]
@experience_req[1]  = [    16,    16]
@experience_req[2]  = [    56,    72]
@experience_req[3]  = [   124,   196]
@experience_req[4]  = [   250,   446]
@experience_req[5]  = [   550,   996]
@experience_req[6]  = [  1200,  2196]
@experience_req[7]  = [  1800,  3896]
@experience_req[8]  = [  2444,  6340]
@experience_req[9]  = [  3525,  9865]
@experience_req[10] = [  6225, 16090]
@experience_req[11] = [150000,166090]

@experience_req[0]  = [     0,     0]
@experience_req[1]  = [    16,    16]
@experience_req[2]  = [    50,    66]
@experience_req[3]  = [   106,   172]
@experience_req[4]  = [   220,   392]
@experience_req[5]  = [   450,   842]
@experience_req[6]  = [   908,  1750]
@experience_req[7]  = [  1250,  3000]
@experience_req[8]  = [  1750,  4750]
@experience_req[9]  = [  2500,  7250]
@experience_req[10] = [  4000, 11250]
@experience_req[11] = [150000,166090]
