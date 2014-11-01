# xcomjs.coffee
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

{XCOM_SIZE} = require './constant'

toFillStyle = (rgb) ->
  r = rgb[0]
  g = rgb[1]
  b = rgb[2]
  rs = "00" + r.toString 16
  gs = "00" + g.toString 16
  bs = "00" + b.toString 16
  rs = rs.substr -2
  gs = gs.substr -2
  bs = bs.substr -2
  "##{rs}#{gs}#{bs}"

resize = ->
  # determine how large the window is
  { innerHeight, innerWidth } = window
  # resize the canvas to fit
  canvas = $("#canvas")[0]
  canvas.width = innerWidth
  canvas.height = innerHeight
  canvas.getContext("2d").imageSmoothingEnabled = false
  # figure out where X-COM is going to display on the canvas
  canvas.scale = Math.floor Math.min innerHeight / XCOM_SIZE.HEIGHT, innerWidth / XCOM_SIZE.WIDTH
  canvas.ox = Math.floor((canvas.width - (XCOM_SIZE.WIDTH * canvas.scale)) / 2)
  canvas.oy = Math.floor((canvas.height - (XCOM_SIZE.HEIGHT * canvas.scale)) / 2)
  # clean the canvas
  canvas.getContext("2d").fillStyle = '#000000' # clear to black
  canvas.getContext("2d").fillRect 0, 0, canvas.width, canvas.height
  canvas.getContext("2d").fillStyle = '#ff00ff' # magic pink
  canvas.getContext("2d").fillRect canvas.ox, canvas.oy, XCOM_SIZE.WIDTH * canvas.scale, XCOM_SIZE.HEIGHT * canvas.scale

# TODO: Refactor this away
drawPalettes = ->
  canvas = $("#canvas")[0]
  # draw some stuff on the canvas to prove we got the palettes
  for palIndex in [0..4]
    for colIndex in [0..255]
      fillStyle = toFillStyle window.XCOM.PALETTES[palIndex][colIndex]
      canvas.getContext("2d").fillStyle = fillStyle
      dx = canvas.ox+canvas.scale*colIndex
      dy = canvas.oy+canvas.scale*40*palIndex
      dw = canvas.scale
      dh = canvas.scale*40
      canvas.getContext("2d").fillRect dx, dy, dw, dh

# TODO: Refactor this away
clearCanvas = ->
  canvas = $("#canvas")[0]
  context = canvas.getContext("2d")
  context.fillStyle = '#000000'
  context.clearRect 0, 0, canvas.width, canvas.height

# TODO: Refactor this away
drawBackground = ->
  canvas = $("#canvas")[0]
  context = canvas.getContext("2d")
  background = require('./gfx').getBackgroundImage canvas.scale, 0, 0
#  context.drawImage background, canvas.ox, canvas.oy
  context.drawImage background, 32*canvas.scale, 20*canvas.scale, 256*canvas.scale, 160*canvas.scale, canvas.ox+32*canvas.scale, canvas.oy+20*canvas.scale, 256*canvas.scale, 160*canvas.scale

# TODO: Refactor this away
drawWindowBorder = ->
  canvas = $("#canvas")[0]
  context = canvas.getContext("2d")
  windowBorder = require('./gfx').getWindowBorder canvas.scale, 0, 134, 256, 160
  context.drawImage windowBorder, canvas.ox+32*canvas.scale, canvas.oy+20*canvas.scale

# TODO: Refactor this away
drawButtons = ->
  canvas = $("#canvas")[0]
  context = canvas.getContext("2d")
  button = require('./gfx').getButton canvas.scale, 0, 134, 192, 20
  context.drawImage button, canvas.ox+64*canvas.scale, canvas.oy+90*canvas.scale
  context.drawImage button, canvas.ox+64*canvas.scale, canvas.oy+118*canvas.scale
  context.drawImage button, canvas.ox+64*canvas.scale, canvas.oy+146*canvas.scale

# TODO: Refactor this away
drawAllText = -> # actually, not quite ALL the text...
  gfx = require './gfx'
  canvas = $("#canvas")[0]
  context = canvas.getContext("2d")
  # draw large glyphs
  for y in [0...8]
    for x in [0...20]
      largeGlyph = gfx.getLargeGlyph canvas.scale, 0, 139, y*20+x
      context.drawImage largeGlyph, canvas.ox+x*16*canvas.scale, canvas.oy+y*16*canvas.scale
  # draw small glyphs
  for y in [0...4]
    for x in [0...40]
      smallGlyph = gfx.getSmallGlyph canvas.scale, 0, 139, y*40+x
      context.drawImage smallGlyph, canvas.ox+x*8*canvas.scale, canvas.oy+128*canvas.scale+y*9*canvas.scale

# TODO: Refactor this away
drawSomeText = ->
  gfx = require './gfx'
  canvas = $("#canvas")[0]
  context = canvas.getContext("2d")
  # draw small glyphs
  for y in [0...17]
    for x in [0...10]
      smallGlyph = gfx.getSmallGlyph canvas.scale, 0, 139, y*10+x
      context.drawImage smallGlyph, canvas.ox+x*8*canvas.scale, canvas.oy+y*9*canvas.scale
  for x in [0...3]
    smallGlyph = gfx.getSmallGlyph canvas.scale, 0, 139, 170+x
    context.drawImage smallGlyph, canvas.ox+x*8*canvas.scale, canvas.oy+17*9*canvas.scale

installShimJQ = ->
  window.$ = (selector) ->
    if selector is "#canvas"
      return [ document.getElementById("canvas") ]
    alert "Unknown selector #{selector}"

exports.run = ->
  # shim jQuery if needed
  if not window.$
    installShimJQ()
  # add the X-COM game data objects
  window.XCOM = require './xcom'
  # manually resize the canvas once
  resize()
  # if the user resizes the browser, then resize the canvas to match
  window.addEventListener 'resize', resize
  # let's draw an image to show that we can do it
  clearCanvas()
  drawBackground()
  drawWindowBorder()
  drawButtons()
#  drawAllText()
#  drawSomeText()
#  smallFont = require('./font').getSmallFont canvas.scale, 0, 134
#  console.log smallFont
  canvas = $("#canvas")[0]
  largeFont = require('./font').getLargeFont canvas.scale, 0, 139
  smallFont = require('./font').getSmallFont canvas.scale, 0, 139
  render = require './render'
  render.drawText canvas, largeFont, "UFO", 145, 45
  render.drawText canvas, smallFont, "Enemy Unknown", 127, 61

  smallGreenFont = require('./font').getSmallFont canvas.scale, 0, 134
  render.drawText canvas, smallGreenFont, "New Game", 139, 96
  render.drawText canvas, smallGreenFont, "Load Saved Game", 122, 124
  render.drawText canvas, smallGreenFont, "Quit", 152, 152

#----------------------------------------------------------------------------
# end of xcomjs.coffee
