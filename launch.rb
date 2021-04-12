require 'rubygems'
require 'bundler/setup'
require 'paint'
require 'paint/pa'
require 'json'
require 'yaml'
require 'logger'
require_relative 'Game_DB'
require_relative 'Player'
require_relative 'Enemy'
require_relative 'Main'
include Game_DB
Game_DB.populate_database
File.delete("debug.log") if File.exists?("debug.log")
$game_log = Logger.new('debug.log')
$game_log.level = Logger::ERROR
begin
  Game = Game_Main.new
rescue => err
  $game_log.fatal("Fatal error, exiting")
  $game_log.fatal(err)
  $game_log.close
  puts "FATAL ERROR. debug.log written. If you want to save this file you must \n move it somewhere else before starting the game again."
  puts "Press <ENTER> to exit."
  key = gets
end
