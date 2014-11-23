# selectSiteForNewBase.coffee
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

SELECT_SITE_FOR_NEW_BASE_ID = 283

{
  COLOR_OTHER_GREEN
} = require '../constant'

font = require '../font'
gfx = require '../gfx'
renderer = require '../render'
text = require '../text'

{GeoscapeDate} = require '../gui/geodate'

geodate = null
lastScale = null
lastUpdate = 0

createGui = (canvas) ->
  geodate = new GeoscapeDate canvas
  lastScale = canvas.scale

activity =
  # the name of the activity
  name: "Select Site for New Base"
  
  # called before this activity begins
  enter: ->
    #alert @name
  
  # called after this activity is finished
  leave: ->
  
  # called when the user presses a mouse button
  mousedown: (e) ->
  
  # called when the user moves the mouse
  mousemove: (e) ->
  
  # called when the user releases a mouse button
  mouseup: (e) ->
  
  # called by the game engine to draw the display
  render: (timestamp, canvas) ->
    createGui canvas if canvas.scale isnt lastScale
    # clear the canvas to black
    renderer.clearCanvas canvas
    # draw the geoscape background and necessary overlays
    renderer.drawGeoscapeBackground canvas
    # draw the window background
    background = gfx.getBackgroundImage canvas.scale, 0, 0
    renderer.drawBackground canvas, background, 0, 0, 256, 28
    # draw the window border
    windowBorder = gfx.getWindowBorder canvas.scale, COLOR_OTHER_GREEN[0], COLOR_OTHER_GREEN[1], 256, 28
    renderer.drawGraphic canvas, windowBorder, 0, 0
    # draw the window title
    titleFontSmall = font.getSmallFont canvas.scale, COLOR_OTHER_GREEN[0], COLOR_OTHER_GREEN[1], false
    titleText = text.getGeoscapeText SELECT_SITE_FOR_NEW_BASE_ID
    renderer.drawText canvas, titleFontSmall, titleText, 8, 10
    # draw the geoscape date
    geodate.render canvas, window.GAME
  
  # called by the game engine to update logic/state
  update: (timestamp) ->
    # 5 sec
    #window.GAME.date += 5000
    # 1 min
    #window.GAME.date += 60000
    # 5 min
    #window.GAME.date += 300000
    # 30 min
    #window.GAME.date += 1800000
    # 1 hour
    #window.GAME.date += 3600000
    # 1 day
    window.GAME.date += 86400000
    this

# export this activity to others
exports.activity = activity

#----------------------------------------------------------------------------
# end of selectSiteForNewBase.coffee
