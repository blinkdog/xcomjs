# newLoadQuitGame.coffee
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

NEW_GAME_LABEL_ID = 780
LOAD_SAVED_GAME_LABEL_ID = 781
QUIT_LABEL_ID = 801

{
  COLOR_GREEN,
  COLOR_YELLOW,
  SAMPLE_BUTTON_PUSH
} = require '../constant'

font = require '../font'
gfx = require '../gfx'
renderer = require '../render'
sound = require '../sound'
{getGeoscapeText} = require '../text'

{Button} = require '../gui/button'
{Game} = require '../state/game'

selectDifficultyActivity = require('./selectDifficulty').activity
loadGameActivity = require('./loadSavedGame').activity

lastScale = 0
newGameButton = null
loadSavedGameButton = null
quitButton = null
nextActivity = null
buttonPushSample = null

createGui = (canvas) ->
  newGameLabel = getGeoscapeText NEW_GAME_LABEL_ID
  newGameButton = new Button canvas, COLOR_GREEN, 192, 20, 64, 90, newGameLabel, ->
    window.GAME = new Game()
    nextActivity = selectDifficultyActivity
    sound.playSample buttonPushSample

  loadSavedGameLabel = getGeoscapeText LOAD_SAVED_GAME_LABEL_ID
  loadSavedGameButton = new Button canvas, COLOR_GREEN, 192, 20, 64, 118, loadSavedGameLabel, ->
    nextActivity = loadGameActivity
    sound.playSample buttonPushSample

  quitLabel = getGeoscapeText QUIT_LABEL_ID
  quitButton = new Button canvas, COLOR_GREEN, 192, 20, 64, 146, quitLabel, ->
    nextActivity = null
    sound.playSample buttonPushSample
    window.location.href = 'https://github.com/blinkdog/xcomjs'

  lastScale = canvas.scale

activity =
  name: "New/Load/Quit Game"
  
  enter: ->
    # by default, this will be the next activity
    nextActivity = activity
    buttonPushSample = sound.getGeoscapeSample SAMPLE_BUTTON_PUSH

  leave: ->

  mousedown: (e) ->
    newGameButton?.mousedown e
    loadSavedGameButton?.mousedown e
    quitButton?.mousedown e
  
  mousemove: (e) ->

  mouseup: (e) ->
    newGameButton?.mouseup e
    loadSavedGameButton?.mouseup e
    quitButton?.mouseup e

  render: (timestamp, canvas) ->
    # create the GUI resources, if we need them
    createGui canvas if canvas.scale isnt lastScale
    createGui canvas if not newGameButton?
    createGui canvas if not loadSavedGameButton?
    createGui canvas if not quitButton?
    # clear the canvas to black
    renderer.clearCanvas canvas
    # draw the window background
    background = gfx.getBackgroundImage canvas.scale, 0, 0
    renderer.drawBackground canvas, background, 32, 20, 256, 160
    # draw the window border
    windowBorder = gfx.getWindowBorder canvas.scale, 0, 134, 256, 160
    renderer.drawGraphic canvas, windowBorder, 32, 20
    # draw the title text
      # 145, 45, UFO
      # 127, 61, Enemy Unknown
    titleFontSmall = font.getSmallFont canvas.scale, COLOR_YELLOW[0], COLOR_YELLOW[1], false
    titleFontLarge = font.getLargeFont canvas.scale, COLOR_YELLOW[0], COLOR_YELLOW[1], false
    renderer.drawCenterText canvas, titleFontLarge, "xcomjs", 45
    renderer.drawCenterText canvas, titleFontSmall, "Browser Defense", 61
    # draw the language selection buttons
    newGameButton.render canvas
    loadSavedGameButton.render canvas
    quitButton.render canvas
  
  update: (timestamp) -> nextActivity

# export this activity to others
exports.activity = activity

#----------------------------------------------------------------------------
# end of newLoadQuitGame.coffee
