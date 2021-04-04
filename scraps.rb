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
