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

#----------------------------------------------------------------------------

###
  Background Images
###
createBackgroundImage = (backIndex, palIndex) ->
  console.log 'createBackgroundImage %d %d', backIndex, palIndex
  # obtain the game data from X-COM
  backImg = window.XCOM.BACK[backIndex]
  backPal = window.XCOM.BACKPALS[palIndex]
  # create a canvas element to hold the image data
  canvas = document.createElement 'canvas'
  canvas.width = XCOM_SIZE.WIDTH
  canvas.height = XCOM_SIZE.HEIGHT
  context = canvas.getContext '2d'
  context.imageSmoothingEnabled = false
  pixels = context.getImageData 0, 0, XCOM_SIZE.WIDTH, XCOM_SIZE.HEIGHT
  pixelData = pixels.data
  # draw the background image
  for y in [0..XCOM_SIZE.HEIGHT-1]
    for x in [0..XCOM_SIZE.WIDTH-1]
      backPixelIndex = backImg[y][x]-224
      backPixel = backPal[backPixelIndex]
      baseIndex = (y*XCOM_SIZE.WIDTH + x) * 4
      pixelData[baseIndex] = backPixel[0]
      pixelData[baseIndex+1] = backPixel[1]
      pixelData[baseIndex+2] = backPixel[2]
      pixelData[baseIndex+3] = 255
  context.putImageData pixels, 0, 0
  return canvas

createBackgroundImageHash = (backIndex, palIndex) ->
  "#{backIndex},#{palIndex}"

createBackgroundImageMemo = _.memoize createBackgroundImage, createBackgroundImageHash

exports.getBackgroundImage = (backIndex, palIndex) ->
  createBackgroundImageMemo backIndex, palIndex

###
  Buttons
###
createButton = (palIndex, colIndex, width, height) ->
  console.log 'createButton %d %d %d %d', palIndex, colIndex, width, height
  # obtain the game data from X-COM
  palette = window.XCOM.PALETTES[palIndex]
  # create a canvas element to hold the image data
  canvas = document.createElement 'canvas'
  canvas.width = width
  canvas.height = height
  context = canvas.getContext '2d'
  context.imageSmoothingEnabled = false
  pixels = context.getImageData 0, 0, width, height
  pixelData = pixels.data
  # draw the button
  for x in [0..width-1]
    putPixel pixels, x, 0, palette[colIndex]
    putPixel pixels, x, height-1, palette[colIndex+4]
  for y in [0..height-1]
    putPixel pixels, 0, y, palette[colIndex]
    putPixel pixels, width-1, y, palette[colIndex+4]
  for x in [1..width-2]
    putPixel pixels, x, 1, palette[colIndex+1]
    putPixel pixels, x, height-2, palette[colIndex+3]
  for y in [1..height-2]
    putPixel pixels, 1, y, palette[colIndex+1]
    putPixel pixels, width-2, y, palette[colIndex+3]
  for y in [2..height-3]
    for x in [2..width-3]
      putPixel pixels, x, y, palette[colIndex+2]
  context.putImageData pixels, 0, 0
  return canvas

createButtonHash = (palIndex, colIndex, width, height) ->
  "#{palIndex},#{colIndex},#{width},#{height}"

createButtonMemo = _.memoize createButton, createButtonHash

exports.getButton = (palIndex, colIndex, width, height) ->
  createButtonMemo palIndex, colIndex, width, height

#----------------------------------------------------------------------------
# end of gfx.coffee
