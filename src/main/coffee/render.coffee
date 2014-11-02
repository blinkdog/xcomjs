# render.coffee
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

exports.clearCanvas = (canvas) ->
  context = canvas.getContext("2d")
  context.fillStyle = '#000000'
  context.clearRect 0, 0, canvas.width, canvas.height

exports.drawBackground = (canvas, background, x1, y1, width, height) ->
  context = canvas.getContext("2d")
  context.drawImage background,
    x1*canvas.scale, y1*canvas.scale,
    width*canvas.scale, height*canvas.scale,
    canvas.ox+x1*canvas.scale, canvas.oy+y1*canvas.scale,
    width*canvas.scale, height*canvas.scale

exports.drawGraphic = (canvas, graphic, x1, y1) ->
  context = canvas.getContext("2d")
  context.drawImage graphic,
    canvas.ox+x1*canvas.scale, canvas.oy+y1*canvas.scale

exports.drawText = drawText = (canvas, xcomFont, text, x1, y1) ->
  context = canvas.getContext("2d")
  for char in text
    if char is ' '
      x1 = x1 + xcomFont.spaceWidth
    else
      charIndex = xcomFont.encoding.indexOf char
      fontObj = xcomFont[charIndex]
      context.drawImage fontObj.glyph,
        canvas.ox+x1*canvas.scale, canvas.oy+y1*canvas.scale
      x1 = x1 + fontObj.width

exports.drawCenterText = (canvas, font, text, y1) ->
  width = font.measure text
  x1 = Math.floor((320 - width) / 2) + 1
  drawText canvas, font, text, x1, y1

#----------------------------------------------------------------------------
# end of render.coffee
