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

{
  GLYPH_SIZE, 
  MOUSE_BUTTON_LEFT,
  MOUSE_BUTTON_RIGHT
} = require '../constant'

font = require '../font'
gfx = require '../gfx'
renderer = require '../render'

class Button
  constructor: (canvas, color, @width, @height, @bx, @by, @text, @leftFunc, @rightFunc) ->
    @pressed = false
    @gfxButton = gfx.getButton canvas.scale, color[0], color[1], width, height, false
    @gfxButtonPressed = gfx.getButton canvas.scale, color[0], color[1], width, height, true
    @labelFont = font.getSmallFont canvas.scale, color[0], color[1], false
    @labelFontPressed = font.getSmallFont canvas.scale, color[0], color[1], true
    textWidth = @labelFont.measure text
    @tx = @bx + Math.floor((width - textWidth) / 2) + 1
    @ty = @by + Math.floor((height - GLYPH_SIZE.SMALL.HEIGHT) / 2) + 1

  mousedown: (e) ->
    return if e.button isnt MOUSE_BUTTON_LEFT and e.button isnt MOUSE_BUTTON_RIGHT
    return if e.button is MOUSE_BUTTON_RIGHT and not @rightFunc?
    return if e.button is MOUSE_BUTTON_LEFT and not @leftFunc?
    return if not e.xcomX? or not e.xcomY?
    mx = e.xcomX
    my = e.xcomY
    if mx >= @bx and mx < (@bx+@width) and my >= (@by) and my < (@by+@height)
      @pressed++
  
  mouseup: (e) ->
    return if e.button isnt MOUSE_BUTTON_LEFT and e.button isnt MOUSE_BUTTON_RIGHT
    return if e.button is MOUSE_BUTTON_RIGHT and not @rightFunc?
    return if e.button is MOUSE_BUTTON_LEFT and not @leftFunc?
    if @pressed > 0
      @pressed--
      @leftFunc?() if e.button is MOUSE_BUTTON_LEFT
      @rightFunc?() if e.button is MOUSE_BUTTON_RIGHT

  render: (canvas) ->
    buttonGraphic = if @pressed > 0 then @gfxButtonPressed else @gfxButton
    buttonFont = if @pressed > 0 then @labelFontPressed else @labelFont
    renderer.drawGraphic canvas, buttonGraphic, @bx, @by
    renderer.drawText canvas, buttonFont, @text, @tx, @ty

exports.Button = Button

#----------------------------------------------------------------------------
# end of button.coffee
