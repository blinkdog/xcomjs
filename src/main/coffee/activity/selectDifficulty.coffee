# selectDifficulty.coffee
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

DIFFICULTY_LABEL_ID = 782

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

selectSiteForNewBaseActivity = require('./selectSiteForNewBase').activity

lastScale = 0
difficultyButtons = null
nextActivity = null
buttonPushSample = null

setGameDifficulty = (difficultyLevel, difficultyLabel) ->
  alert "Difficulty Level #{difficultyLevel}: #{difficultyLabel}"

createDifficultyButton = (canvas, index) ->
  buttonLabel = getGeoscapeText DIFFICULTY_LABEL_ID + 1 + index
  difficultyButton = new Button canvas, COLOR_GREEN, 160, 18, 80, 55+25*index, buttonLabel, ->
    setGameDifficulty index+1, buttonLabel
    nextActivity = selectSiteForNewBaseActivity
    sound.playSample buttonPushSample

createGui = (canvas) ->
  difficultyButtons = (createDifficultyButton canvas, index for index in [0...5])
  lastScale = canvas.scale

activity =
  name: "Select Difficulty Level"
  
  enter: ->
    nextActivity = activity
    buttonPushSample = sound.getGeoscapeSample SAMPLE_BUTTON_PUSH

  leave: ->

  mousedown: (e) ->
    button.mousedown e for button in difficultyButtons
  
  mousemove: (e) ->

  mouseup: (e) ->
    button.mouseup e for button in difficultyButtons

  render: (timestamp, canvas) ->
    # create the GUI resources, if we need them
    createGui canvas if canvas.scale isnt lastScale
    createGui canvas if not difficultyButtons?
    # clear the canvas to black
    renderer.clearCanvas canvas
    # draw the window background
    background = gfx.getBackgroundImage canvas.scale, 0, 0
    renderer.drawBackground canvas, background, 64, 10, 192, 180
    # draw the window border
    windowBorder = gfx.getWindowBorder canvas.scale, COLOR_GREEN[0], COLOR_GREEN[1], 192, 180
    renderer.drawGraphic canvas, windowBorder, 64, 10
    # draw the window title
    titleFontSmall = font.getSmallFont canvas.scale, COLOR_YELLOW[0], COLOR_YELLOW[1], false
    titleText = getGeoscapeText DIFFICULTY_LABEL_ID
    renderer.drawCenterText canvas, titleFontSmall, titleText, 30
    # draw the language selection buttons
    button.render canvas for button in difficultyButtons
  
  update: (timestamp) -> nextActivity

# export this activity to others
exports.activity = activity

#----------------------------------------------------------------------------
# end of selectDifficulty.coffee
