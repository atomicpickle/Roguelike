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
