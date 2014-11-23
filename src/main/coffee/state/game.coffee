# game.coffee
# Copyright 2014 Patrick Meade.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#----------------------------------------------------------------------------

_ = require 'underscore'
moment = require 'moment'

{
  DIFFICULTY_BEGINNER
} = require '../constant'

GAME_OBJ_VERSION = 1

NEW_GAME =
  date: moment().utc().startOf('month').add(1, 'months').valueOf()
  difficulty: DIFFICULTY_BEGINNER
  nightmare: false
  version: GAME_OBJ_VERSION

class Game
  constructor: (json = "{}") ->
    try
      jsonObj = JSON.parse json
    catch e
      jsonObj = {}
    _.defaults @, jsonObj
    _.defaults @, NEW_GAME
    @importOlder() if @version < GAME_OBJ_VERSION

  importOlder: ->
    @version = GAME_OBJ_VERSION

exports.GAME_OBJ_VERSION = GAME_OBJ_VERSION
exports.Game = Game

#----------------------------------------------------------------------------
# end of game.coffee
