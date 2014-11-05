# selectLanguage.coffee
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

{COLOR_GREEN} = require '../constant'

gfx = require '../gfx'
renderer = require '../render'

{Button} = require '../gui/button'

lastScale = 0
englishButton = null
germanButton = null
frenchButton = null

createGui = (canvas) ->
  englishButton = new Button canvas, COLOR_GREEN, 192, 20, 64, 90, 'ENGLISH', -> alert 'ENGLISH'
  germanButton = new Button canvas, COLOR_GREEN, 192, 20, 64, 118, 'DEUTSCHE', -> alert 'DEUTSCHE'
  frenchButton = new Button canvas, COLOR_GREEN, 192, 20, 64, 146, 'FRANCAIS', -> alert 'FRANCAIS'
  lastScale = canvas.scale

activity =
  name: "Select Language"
  
  enter: ->

  leave: ->

  mousedown: (e) ->
    englishButton?.mousedown e
    germanButton?.mousedown e
    frenchButton?.mousedown e
  
  mousemove: (e) ->

  mouseup: (e) ->
    englishButton?.mouseup e
    germanButton?.mouseup e
    frenchButton?.mouseup e

  render: (timestamp, canvas) ->
    # create the GUI resources, if we need them
    createGui canvas if canvas.scale isnt lastScale
    createGui canvas if not englishButton?
    createGui canvas if not germanButton?
    createGui canvas if not frenchButton?
    # clear the canvas to black
    renderer.clearCanvas canvas
    # draw the window background
    background = gfx.getBackgroundImage canvas.scale, 0, 0
    renderer.drawBackground canvas, background, 32, 20, 256, 160
    # draw the window border
    windowBorder = gfx.getWindowBorder canvas.scale, 0, 134, 256, 160
    renderer.drawGraphic canvas, windowBorder, 32, 20
    # draw the language selection buttons
    englishButton.render canvas
    germanButton.render canvas
    frenchButton.render canvas
  
  update: (timestamp) -> this

# export this activity to others
exports.activity = activity

#----------------------------------------------------------------------------
# end of selectLanguage.coffee
