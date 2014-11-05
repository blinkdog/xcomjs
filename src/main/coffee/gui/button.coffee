# button.coffee
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

{GLYPH_SIZE, MOUSE_BUTTON_LEFT} = require '../constant'

font = require '../font'
gfx = require '../gfx'
renderer = require '../render'

class Button
  constructor: (canvas, color, @width, @height, @bx, @by, @text, @callback) ->
    @pressed = false
    @gfxButton = gfx.getButton canvas.scale, color[0], color[1], width, height, false
    @gfxButtonPressed = gfx.getButton canvas.scale, color[0], color[1], width, height, true
    @labelFont = font.getSmallFont canvas.scale, color[0], color[1], false
    @labelFontPressed = font.getSmallFont canvas.scale, color[0], color[1], true
    textWidth = @labelFont.measure text
    @tx = @bx + Math.floor((width - textWidth) / 2) + 1
    @ty = @by + Math.floor((height - GLYPH_SIZE.SMALL.HEIGHT) / 2) + 1

  mousedown: (e) ->
    return if e.button isnt MOUSE_BUTTON_LEFT
    return if not e.xcomX? or not e.xcomY?
    mx = e.xcomX
    my = e.xcomY
    if mx >= @bx and mx < (@bx+@width) and my >= (@by) and my < (@by+@height)
      @pressed=true
  
  mouseup: (e) ->
    return if e.button isnt MOUSE_BUTTON_LEFT
    if @pressed
      @pressed = false
      @callback?()

  render: (canvas) ->
    buttonGraphic = if @pressed then @gfxButtonPressed else @gfxButton
    buttonFont = if @pressed then @labelFontPressed else @labelFont
    renderer.drawGraphic canvas, buttonGraphic, @bx, @by
    renderer.drawText canvas, buttonFont, @text, @tx, @ty

exports.Button = Button

#----------------------------------------------------------------------------
# end of button.coffee
