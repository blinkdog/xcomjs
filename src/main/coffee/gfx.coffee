# gfx.coffee
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

_ = require 'underscore'
{
  GLYPH_SIZE,
  OVERLAY_SIZE,
  XCOM_SIZE
} = require './constant'

#----------------------------------------------------------------------------

putPixel = (pixels, x, y, rgb) ->
  baseIndex = (pixels.width*y + x) * 4
  pixelData = pixels.data
  pixelData[baseIndex] = rgb[0]
  pixelData[baseIndex+1] = rgb[1]
  pixelData[baseIndex+2] = rgb[2]
  pixelData[baseIndex+3] = 255

putScaledPixel = (scale, pixels, x, y, rgb) ->
  for sy in [0...scale]
    for sx in [0...scale]
      putPixel pixels, x*scale+sx, y*scale+sy, rgb

#----------------------------------------------------------------------------

###
  Background Images
###
createBackgroundImage = (scale, backIndex, palIndex) ->
  #console.log 'createBackgroundImage %d %d %d', scale, backIndex, palIndex
  # obtain the game data from X-COM
  backImg = window.XCOM.BACK[backIndex]
  backPal = window.XCOM.BACKPALS[palIndex]
  # create a canvas element to hold the image data
  canvas = document.createElement 'canvas'
  canvas.width = XCOM_SIZE.WIDTH*scale
  canvas.height = XCOM_SIZE.HEIGHT*scale
  context = canvas.getContext '2d'
  pixels = context.getImageData 0, 0, canvas.width, canvas.height
  # draw the background image
  for y in [0...XCOM_SIZE.HEIGHT]
    for x in [0...XCOM_SIZE.WIDTH]
      backPixelIndex = backImg[y][x]-224
      backPixel = backPal[backPixelIndex]
      putScaledPixel scale, pixels, x, y, backPixel
  context.putImageData pixels, 0, 0
  return canvas

createBackgroundImageHash = (scale, backIndex, palIndex) ->
  "#{scale},#{backIndex},#{palIndex}"

createBackgroundImageMemo = _.memoize createBackgroundImage, createBackgroundImageHash

exports.getBackgroundImage = (scale, backIndex, palIndex) ->
  createBackgroundImageMemo scale, backIndex, palIndex

###
  Buttons
###
createButton = (scale, palIndex, colIndex, width, height, pressed) ->
  #console.log 'createButton %d %d %d %d %d %d', scale, palIndex, colIndex, width, height, pressed
  # obtain the game data from X-COM
  palette = window.XCOM.PALETTES[palIndex]
  if pressed
    buttonPal = (palette[colIndex+4-i] for i in [0..4])
  else
    buttonPal = (palette[colIndex+i] for i in [0..4])
  # create a canvas element to hold the image data
  canvas = document.createElement 'canvas'
  canvas.width = width*scale
  canvas.height = height*scale
  context = canvas.getContext '2d'
  pixels = context.getImageData 0, 0, canvas.width, canvas.height
  # draw the button
  for x in [0...width]
    putScaledPixel scale, pixels, x, 0, buttonPal[0]
    putScaledPixel scale, pixels, x, height-1, buttonPal[4]
  for y in [0...height]
    putScaledPixel scale, pixels, 0, y, buttonPal[0]
    putScaledPixel scale, pixels, width-1, y, buttonPal[4]
  for x in [1...width-1]
    putScaledPixel scale, pixels, x, 1, buttonPal[1]
    putScaledPixel scale, pixels, x, height-2, buttonPal[3]
  for y in [1...height-1]
    putScaledPixel scale, pixels, 1, y, buttonPal[1]
    putScaledPixel scale, pixels, width-2, y, buttonPal[3]
  for y in [2...height-2]
    for x in [2...width-2]
      putScaledPixel scale, pixels, x, y, buttonPal[2]
  context.putImageData pixels, 0, 0
  return canvas

createButtonHash = (scale, palIndex, colIndex, width, height, pressed) ->
  "#{scale},#{palIndex},#{colIndex},#{width},#{height},#{pressed}"

createButtonMemo = _.memoize createButton, createButtonHash

exports.getButton = (scale, palIndex, colIndex, width, height, pressed) ->
  createButtonMemo scale, palIndex, colIndex, width, height, pressed

###
  Geoscape Background
###
createGeoscapeBackground = (scale) ->
  #console.log 'createGeoscapeBackground %d', scale
  # obtain the game data from X-COM
  geobordImg = window.XCOM.GEOBORD
  palette = window.XCOM.PALETTES[0]
  # create a canvas element to hold the image data
  canvas = document.createElement 'canvas'
  canvas.width = XCOM_SIZE.WIDTH*scale
  canvas.height = XCOM_SIZE.HEIGHT*scale
  context = canvas.getContext '2d'
  pixels = context.getImageData 0, 0, canvas.width, canvas.height
  # draw the background image
  for y in [0...XCOM_SIZE.HEIGHT]
    for x in [0...XCOM_SIZE.WIDTH]
      pixelIndex = geobordImg[y][x]
      pixel = palette[pixelIndex]
      putScaledPixel scale, pixels, x, y, pixel
  context.putImageData pixels, 0, 0
  return canvas

createGeoscapeBackgroundMemo = _.memoize createGeoscapeBackground

exports.getGeoscapeBackground = (scale) ->
  createGeoscapeBackgroundMemo scale

###
  Geoscape Overlay
###
createGeoscapeOverlay = (scale, language) ->
  #console.log 'createGeoscapeOverlay %d %s', scale, language
  # obtain the game data from X-COM
  overlayImg = window.XCOM.LANG1 if language is 'DEUTSCHE'
  overlayImg = window.XCOM.LANG2 if language is 'FRANCAIS'
  return null if not overlayImg?
  palette = window.XCOM.PALETTES[0]
  # create a canvas element to hold the image data
  canvas = document.createElement 'canvas'
  canvas.width = OVERLAY_SIZE.WIDTH*scale
  canvas.height = OVERLAY_SIZE.HEIGHT*scale
  context = canvas.getContext '2d'
  pixels = context.getImageData 0, 0, canvas.width, canvas.height
  # draw the background image
  for y in [0...OVERLAY_SIZE.HEIGHT]
    for x in [0...OVERLAY_SIZE.WIDTH]
      pixelIndex = overlayImg[y][x]
      pixel = palette[pixelIndex]
      putScaledPixel scale, pixels, x, y, pixel
  context.putImageData pixels, 0, 0
  return canvas

createGeoscapeOverlayHash = (scale, language) ->
  "#{scale},#{language}"

createGeoscapeOverlayMemo = _.memoize createGeoscapeOverlay, createGeoscapeOverlayHash

exports.getGeoscapeOverlay = (scale, language) ->
  createGeoscapeOverlayMemo scale, language

###
  Large Glyphs
###
createLargeGlyph = (scale, palIndex, colIndex, glyphIndex) ->
  #console.log 'createLargeGlyph %d %d %d %d', scale, palIndex, colIndex, glyphIndex
  # obtain the game data from X-COM
  palette = window.XCOM.PALETTES[palIndex]
  biglets = window.XCOM.BIGLETS[glyphIndex]
  # create a canvas element to hold the image data
  canvas = document.createElement 'canvas'
  canvas.width = GLYPH_SIZE.LARGE.WIDTH * scale
  canvas.height = GLYPH_SIZE.LARGE.HEIGHT * scale
  context = canvas.getContext '2d'
  pixels = context.getImageData 0, 0, canvas.width, canvas.height
  # draw the button
  for y in [0...GLYPH_SIZE.LARGE.HEIGHT]
    for x in [0...GLYPH_SIZE.LARGE.WIDTH]
      if biglets[y][x] isnt 0
        palIndex = colIndex + biglets[y][x] - 1
        putScaledPixel scale, pixels, x, y, palette[palIndex]
  context.putImageData pixels, 0, 0
  return canvas

createLargeGlyphHash = (scale, palIndex, colIndex, glyphIndex) ->
  "#{scale},#{palIndex},#{colIndex},#{glyphIndex}"

createLargeGlyphMemo = _.memoize createLargeGlyph, createLargeGlyphHash

exports.getLargeGlyph = (scale, palIndex, colIndex, glyphIndex) ->
  createLargeGlyphMemo scale, palIndex, colIndex, glyphIndex

###
  Small Glyphs
###
createSmallGlyph = (scale, palIndex, colIndex, glyphIndex, pressed) ->
  #console.log 'createSmallGlyph %d %d %d %d %d', scale, palIndex, colIndex, glyphIndex, pressed
  # obtain the game data from X-COM
  palette = window.XCOM.PALETTES[palIndex]
  if pressed
    buttonPal = (palette[colIndex+4-i] for i in [0..4])
  else
    buttonPal = (palette[colIndex+i] for i in [0..4])
  smallset = window.XCOM.SMALLSET[glyphIndex]
  # create a canvas element to hold the image data
  canvas = document.createElement 'canvas'
  canvas.width = GLYPH_SIZE.SMALL.WIDTH * scale
  canvas.height = GLYPH_SIZE.SMALL.HEIGHT * scale
  context = canvas.getContext '2d'
  pixels = context.getImageData 0, 0, canvas.width, canvas.height
  # draw the button
  for y in [0...GLYPH_SIZE.SMALL.HEIGHT]
    for x in [0...GLYPH_SIZE.SMALL.WIDTH]
      if smallset[y][x] isnt 0
        palIndex = smallset[y][x] - 1
        putScaledPixel scale, pixels, x, y, buttonPal[palIndex]
  context.putImageData pixels, 0, 0
  return canvas

createSmallGlyphHash = (scale, palIndex, colIndex, glyphIndex, pressed) ->
  "#{scale},#{palIndex},#{colIndex},#{glyphIndex},#{pressed}"

createSmallGlyphMemo = _.memoize createSmallGlyph, createSmallGlyphHash

exports.getSmallGlyph = (scale, palIndex, colIndex, glyphIndex, pressed) ->
  createSmallGlyphMemo scale, palIndex, colIndex, glyphIndex, pressed

###
  Window Border
###
createWindowBorder = (scale, palIndex, colIndex, width, height) ->
  #console.log 'createWindowBorder %d %d %d %d %d', scale, palIndex, colIndex, width, height
  # obtain the game data from X-COM
  palette = window.XCOM.PALETTES[palIndex]
  # create a canvas element to hold the image data
  canvas = document.createElement 'canvas'
  canvas.width = width*scale
  canvas.height = height*scale
  context = canvas.getContext '2d'
  pixels = context.getImageData 0, 0, canvas.width, canvas.height
  # draw the window border
  for x in [0...width] ## outer 3
    putScaledPixel scale, pixels, x, 0, palette[colIndex+2]
    putScaledPixel scale, pixels, x, height-1, palette[colIndex+2]
  for y in [0...height]
    putScaledPixel scale, pixels, 0, y, palette[colIndex+2]
    putScaledPixel scale, pixels, width-1, y, palette[colIndex+2]

  for x in [1...width-1] ## outer 2
    putScaledPixel scale, pixels, x, 1, palette[colIndex+1]
    putScaledPixel scale, pixels, x, height-2, palette[colIndex+1]
  for y in [1...height-1]
    putScaledPixel scale, pixels, 1, y, palette[colIndex+1]
    putScaledPixel scale, pixels, width-2, y, palette[colIndex+1]

  for x in [2...width-2] ## inner 1
    putScaledPixel scale, pixels, x, 2, palette[colIndex]
    putScaledPixel scale, pixels, x, height-3, palette[colIndex]
  for y in [2...height-2]
    putScaledPixel scale, pixels, 2, y, palette[colIndex]
    putScaledPixel scale, pixels, width-3, y, palette[colIndex]

  for x in [3...width-3] ## inner 2
    putScaledPixel scale, pixels, x, 3, palette[colIndex+1]
    putScaledPixel scale, pixels, x, height-4, palette[colIndex+1]
  for y in [3...height-3]
    putScaledPixel scale, pixels, 3, y, palette[colIndex+1]
    putScaledPixel scale, pixels, width-4, y, palette[colIndex+1]

  for x in [4...width-4] ## inner 3
    putScaledPixel scale, pixels, x, 4, palette[colIndex+2]
    putScaledPixel scale, pixels, x, height-5, palette[colIndex+2]
  for y in [4...height-4]
    putScaledPixel scale, pixels, 4, y, palette[colIndex+2]
    putScaledPixel scale, pixels, width-5, y, palette[colIndex+2]

  context.putImageData pixels, 0, 0
  return canvas

createWindowBorderHash = (scale, palIndex, colIndex, width, height) ->
  "#{scale},#{palIndex},#{colIndex},#{width},#{height}"

createWindowBorderMemo = _.memoize createWindowBorder, createWindowBorderHash

exports.getWindowBorder = (scale, palIndex, colIndex, width, height) ->
  createWindowBorderMemo scale, palIndex, colIndex, width, height

#----------------------------------------------------------------------------
# end of gfx.coffee
