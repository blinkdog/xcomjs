# font.coffee
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
gfx = require './gfx'

BIGLETS_ENCODING = [
  '!"#$%&\'('
  ')*+,-./0'
  '12345678'
  '9:;<=>?@'
  'ABCDEFGH'
  'IJKLMNOP'
  'QRSTUVWX'
  'YZ[\\]^_£'
  'abcdefgh'
  'ijklmnop'
  'qrstuvwx'
  'yz{|}~©Ç'
  'üéâäà°çê'
  'ëèïî¿ÄáÉ'
  'éíôöóûúñ'
  'ÖÜ...ßúá'
  'íóúññ.°¿'
  '...¡¡¡..'
  '.....ÑÁÍ'
  '........'
  '........'
  '.....' ].join ''

SMALLSET_ENCODING = [
  '!"#$%&\'('
  ')*+,-./0'
  '12345678'
  '9:;<=>?@'
  'ABCDEFGH'
  'IJKLMNOP'
  'QRSTUVWX'
  'YZ[\\]^_£'
  'abcdefgh'
  'ijklmnop'
  'qrstuvwx'
  'yz{|}~©Ç'
  'üéâäà.çê'
  'ëèïî¿ÄáÉ'
  'éíôöóûúñ'
  'ÖÜEIDßúá'
  'íóúññ.°¿'
  '.Ñ.¡¡¡..'
  '........'
  '........'
  '........'
  '.....' ].join ''

#----------------------------------------------------------------------------

# PMM: This could probably be written more functionally (i.e. _.reduce)
measureGlyph = (glyph) ->
  widest = 0
  for row in glyph
    for i in [0...row.length]
      if row[i] isnt 0
        widest = Math.max widest, i+1
  return widest

#----------------------------------------------------------------------------

###
  Large Fonts
###
createLargeFont = (scale, palIndex, colIndex) ->
  console.log 'createLargeFont %d %d %d %d', scale, palIndex, colIndex
  result = []
  # create all the glyphs in the font
  for i in [0...window.XCOM.BIGLETS.length]
    glyph = gfx.getLargeGlyph scale, palIndex, colIndex, i
    result.push
      glyph: glyph
      width: measureGlyph window.XCOM.BIGLETS[i]
      encodes: BIGLETS_ENCODING.charAt i
  # annotate the font
  result.encoding = BIGLETS_ENCODING
  result.spaceWidth = 11
  return result

createLargeFontHash = (scale, palIndex, colIndex) ->
  "#{scale},#{palIndex},#{colIndex}"

createLargeFontMemo = _.memoize createLargeFont, createLargeFontHash

exports.getLargeFont = (scale, palIndex, colIndex) ->
  createLargeFontMemo scale, palIndex, colIndex

###
  Small Fonts
###
createSmallFont = (scale, palIndex, colIndex) ->
  console.log 'createSmallFont %d %d %d %d', scale, palIndex, colIndex
  result = []
  # create all the glyphs in the font
  for i in [0...window.XCOM.SMALLSET.length]
    glyph = gfx.getSmallGlyph scale, palIndex, colIndex, i
    width = measureGlyph(window.XCOM.SMALLSET[i])-1
    encodes = SMALLSET_ENCODING.charAt i
    if encodes is 'L'
      width--
    result.push
      glyph: glyph
      width: width
      encodes: encodes
  # annotate the font
  result.encoding = SMALLSET_ENCODING
  result.spaceWidth = 5
  return result

createSmallFontHash = (scale, palIndex, colIndex) ->
  "#{scale},#{palIndex},#{colIndex}"

createSmallFontMemo = _.memoize createSmallFont, createSmallFontHash

exports.getSmallFont = (scale, palIndex, colIndex) ->
  createSmallFontMemo scale, palIndex, colIndex

#----------------------------------------------------------------------------
# end of font.coffee