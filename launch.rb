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
$game_log = Logger.new('debug.log')
$game_log.level = Logger::ERROR
begin
  Game = Game_Main.new
rescue => err
  $game_log.fatal("Fatal error, exiting")
  $game_log.fatal(err)
  $game_log.close
  puts "FATAL ERROR. debug.log written. Press any key to exit."
  key = gets
end
