# gameTest.coffee
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

should = require 'should'

{
  GAME_OBJ_VERSION,
  Game
} = require '../../lib/state/game'

describe 'Game', ->
  it 'should be OK', ->
    Game.should.be.ok

  describe 'new games', ->
    it 'should create a new game when passed nothing', ->
      newGame = new Game()
      newGame.should.be.ok

    it 'should create a new game when passed {}', ->
      newGame = new Game "{}"
      newGame.should.be.ok

    it 'should have a version property', ->
      newGame = new Game "{}"
      newGame.should.have.property 'version'
      newGame.version.should.be.above 0

  describe 'loaded games', ->
    describe 'invalid games', ->
      it 'should create a valid Game when passed invalid JSON', ->
        invalidGame = new Game "[1, 2, 3,]"
        invalidGame.should.be.ok
        invalidGame.version.should.equal GAME_OBJ_VERSION
      
    describe 'old version saved game', ->
      oldVersion =
        version: GAME_OBJ_VERSION-1
  
      loadedGame = new Game JSON.stringify oldVersion, null, 2

      it 'should create a Game when passed JSON', ->
        loadedGame.should.be.ok

      it 'should update the version property', ->
        loadedGame.should.have.property 'version'
        loadedGame.version.should.equal GAME_OBJ_VERSION

#----------------------------------------------------------------------------
# end of gameTest.coffee
