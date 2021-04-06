require 'rubygems'
require 'bundler/setup'
require 'paint'
require 'paint/pa'
require 'json'
require 'yaml'
require_relative 'Game_DB'
require_relative 'Player'
require_relative 'Enemy'
require_relative 'Main'
include Game_DB
Game_DB.populate_database
Game = Game_Main.new
