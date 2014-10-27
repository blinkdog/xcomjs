# xcom.coffee
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

{GLYPH_SIZE} = require './constant'

###
  GEOGRAPH/BACKxx.DAT | xx = [01..17]
###
BACK = (new Buffer back, 'base64' for back in window.DATA.GEOGRAPH.BACK)

reframeBack = (back) ->
  result = []
  for i in [0..199]
    row = []
    for j in [0..319]
      row.push back[i*320+j]
    result.push row
  return result

exports.BACK = (reframeBack back for back in BACK)

###
  GEODATA/BACKPALS.DAT
###
BACKPALS = new Buffer window.DATA.GEODATA.BACKPALS, 'base64'
BACKPAL_SIZE = 16*3

backpalAt = (start) ->
  result = []
  for i in [0..15]
    result.push [
      # multiplied by 4 to convert VGA colors to browser colors
      BACKPALS[start+i*3] << 2,
      BACKPALS[start+i*3+1] << 2,
      BACKPALS[start+i*3+2] << 2]
  return result

exports.BACKPALS = (backpalAt BACKPAL_SIZE*i for i in [0..7])

###
  GEODATA/BIGLETS.DAT
###
BIGLETS = new Buffer window.DATA.GEODATA.BIGLETS, 'base64'
BIGLETS_SIZE = GLYPH_SIZE.LARGE.WIDTH * GLYPH_SIZE.LARGE.HEIGHT

bigletAt = (start) ->
  result = []
  for i in [0...GLYPH_SIZE.LARGE.HEIGHT]
    row = []
    for j in [0...GLYPH_SIZE.LARGE.WIDTH]
      row.push BIGLETS[start+i*GLYPH_SIZE.LARGE.WIDTH+j]
    result.push row
  return result

exports.BIGLETS = (bigletAt BIGLETS_SIZE*i for i in [0...BIGLETS.length/BIGLETS_SIZE])

###
  GEODATA/PALETTES.DAT
###
PALETTES = new Buffer window.DATA.GEODATA.PALETTES, 'base64'
PALETTE_SIZE = 256*3+6

paletteAt = (start) ->
  result = []
  for i in [0..255]
    result.push [
      # multiplied by 4 to convert VGA colors to browser colors
      PALETTES[start+i*3] << 2,
      PALETTES[start+i*3+1] << 2,
      PALETTES[start+i*3+2] << 2]
  return result

exports.PALETTES = (paletteAt PALETTE_SIZE*i for i in [0..4])

###
  GEODATA/BIGLETS.DAT
###
SMALLSET = new Buffer window.DATA.GEODATA.SMALLSET, 'base64'
SMALLSET_SIZE = GLYPH_SIZE.SMALL.WIDTH * GLYPH_SIZE.SMALL.HEIGHT

smallsetAt = (start) ->
  result = []
  for i in [0...GLYPH_SIZE.SMALL.HEIGHT]
    row = []
    for j in [0...GLYPH_SIZE.SMALL.WIDTH]
      row.push SMALLSET[start+i*GLYPH_SIZE.SMALL.WIDTH+j]
    result.push row
  return result

exports.SMALLSET = (smallsetAt SMALLSET_SIZE*i for i in [0...SMALLSET.length/SMALLSET_SIZE])

#----------------------------------------------------------------------------
# end of xcom.coffee
