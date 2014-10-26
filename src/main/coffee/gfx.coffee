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
{XCOM_SIZE} = require './constant'

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
  console.log 'createBackgroundImage %d %d %d', scale, backIndex, palIndex
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
createButton = (scale, palIndex, colIndex, width, height) ->
  console.log 'createButton %d %d %d %d %d', scale, palIndex, colIndex, width, height
  # obtain the game data from X-COM
  palette = window.XCOM.PALETTES[palIndex]
  # create a canvas element to hold the image data
  canvas = document.createElement 'canvas'
  canvas.width = width*scale
  canvas.height = height*scale
  context = canvas.getContext '2d'
  pixels = context.getImageData 0, 0, canvas.width, canvas.height
  # draw the button
  console.log 'Drawing 0/4 Horiz'
  for x in [0...width]
    putScaledPixel scale, pixels, x, 0, palette[colIndex]
    putScaledPixel scale, pixels, x, height-1, palette[colIndex+4]
  console.log 'Drawing 0/4 Vert'
  for y in [0...height]
    putScaledPixel scale, pixels, 0, y, palette[colIndex]
    putScaledPixel scale, pixels, width-1, y, palette[colIndex+4]
  console.log 'Drawing 1/3 Horiz'
  for x in [1...width-1]
    putScaledPixel scale, pixels, x, 1, palette[colIndex+1]
    putScaledPixel scale, pixels, x, height-2, palette[colIndex+3]
  console.log 'Drawing 1/3 Vert'
  for y in [1...height-1]
    putScaledPixel scale, pixels, 1, y, palette[colIndex+1]
    putScaledPixel scale, pixels, width-2, y, palette[colIndex+3]
  console.log 'Drawing 2 Fill'
  for y in [2...height-2]
    for x in [2...width-2]
      putScaledPixel scale, pixels, x, y, palette[colIndex+2]
  context.putImageData pixels, 0, 0
  return canvas

createButtonHash = (scale, palIndex, colIndex, width, height) ->
  "#{scale},#{palIndex},#{colIndex},#{width},#{height}"

createButtonMemo = _.memoize createButton, createButtonHash

exports.getButton = (scale, palIndex, colIndex, width, height) ->
  createButtonMemo scale, palIndex, colIndex, width, height

#----------------------------------------------------------------------------
# end of gfx.coffee
