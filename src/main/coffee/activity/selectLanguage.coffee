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

{MOUSE_BUTTON_LEFT} = require '../constant'

font = require '../font'
gfx = require '../gfx'
renderer = require '../render'

pushed = [false, false, false]

activity =
  name: "Select Language"
  
  enter: ->

  leave: ->

  mousedown: (e) ->
    if e.button is MOUSE_BUTTON_LEFT
      if e.xcomX? and e.xcomY?
        mx = e.xcomX
        my = e.xcomY
        if mx >= 64 and mx <= 256
          pushed[0] = true if my >= 90 and my <= 110
          pushed[1] = true if my >= 118 and my <= 138
          pushed[2] = true if my >= 146 and my <= 166
  
  mousemove: (e) ->

  mouseup: (e) ->
    if e.button is MOUSE_BUTTON_LEFT
      pushed[i] = false for i in [0..2]

  render: (timestamp, canvas) ->
    # clear the canvas to black
    renderer.clearCanvas canvas
    # draw the window background
    background = gfx.getBackgroundImage canvas.scale, 0, 0
    renderer.drawBackground canvas, background, 32, 20, 256, 160
    # draw the window border
    windowBorder = gfx.getWindowBorder canvas.scale, 0, 134, 256, 160
    renderer.drawGraphic canvas, windowBorder, 32, 20
    # draw the language selection buttons
    button = gfx.getButton canvas.scale, 0, 134, 192, 20
    pushedButton = gfx.getButton canvas.scale, 0, 134, 192, 20, true
    if pushed[0]
      renderer.drawGraphic canvas, pushedButton, 64, 90
    else
      renderer.drawGraphic canvas, button, 64, 90
    if pushed[1]
      renderer.drawGraphic canvas, pushedButton, 64, 118
    else
      renderer.drawGraphic canvas, button, 64, 118
    if pushed[2]
      renderer.drawGraphic canvas, pushedButton, 64, 146
    else
      renderer.drawGraphic canvas, button, 64, 146
    # draw the labels on the buttons
    buttonFont = font.getSmallFont canvas.scale, 0, 134
    pushedButtonFont = font.getSmallFont canvas.scale, 0, 134, true
    if pushed[0]
      renderer.drawCenterText canvas, pushedButtonFont, "ENGLISH", 96
    else
      renderer.drawCenterText canvas, buttonFont, "ENGLISH", 96
    if pushed[1]
      renderer.drawCenterText canvas, pushedButtonFont, "DEUTSCHE", 124
    else
      renderer.drawCenterText canvas, buttonFont, "DEUTSCHE", 124
    if pushed[2]
      renderer.drawCenterText canvas, pushedButtonFont, "FRANCAIS", 152
    else
      renderer.drawCenterText canvas, buttonFont, "FRANCAIS", 152
  
  update: (timestamp) -> this

# export this activity to others
exports.activity = activity

#----------------------------------------------------------------------------
# end of selectLanguage.coffee
