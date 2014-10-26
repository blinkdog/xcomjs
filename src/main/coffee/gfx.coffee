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

createBackgroundImage = (backIndex, palIndex) ->
  console.log 'createBackgroundImage %d %d', backIndex, palIndex
  # obtain the game data from X-COM
  backImg = window.XCOM.BACK[backIndex]
  backPal = window.XCOM.BACKPALS[palIndex]
  # create a canvas element corresponding to this
  canvas = document.createElement 'canvas'
  canvas.width = XCOM_SIZE.WIDTH
  canvas.height = XCOM_SIZE.HEIGHT
  context = canvas.getContext '2d'
  context.imageSmoothingEnabled = false
  pixels = context.getImageData 0, 0, XCOM_SIZE.WIDTH, XCOM_SIZE.HEIGHT
  pixelData = pixels.data
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

#----------------------------------------------------------------------------
# end of gfx.coffee
