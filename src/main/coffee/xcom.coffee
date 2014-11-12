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
cp437 = require './cp437'

#----------------------------------------------------------------------------

parseStrings = (buffer) ->
  result = []
  string = ""
  for byte in buffer
    if byte is 0
      result.push string
      string = ""
    else
      string += String.fromCharCode cp437.toUnicode byte
  return result

#----------------------------------------------------------------------------

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
  GEODATA/ENGLISH.DAT
  GEODATA/ENGLISH2.DAT
  GEODATA/FRENCH.DAT
  GEODATA/FRENCH2.DAT
  GEODATA/GERMAN.DAT
  GEODATA/GERMAN2.DAT
###
ENGLISH = new Buffer window.DATA.GEODATA.ENGLISH, 'base64'
exports.ENGLISH = parseStrings ENGLISH

ENGLISH2 = new Buffer window.DATA.GEODATA.ENGLISH2, 'base64'
exports.ENGLISH2 = parseStrings ENGLISH2

FRENCH = new Buffer window.DATA.GEODATA.FRENCH, 'base64'
exports.FRENCH = parseStrings FRENCH

FRENCH2 = new Buffer window.DATA.GEODATA.FRENCH2, 'base64'
exports.FRENCH2 = parseStrings FRENCH2

GERMAN = new Buffer window.DATA.GEODATA.GERMAN, 'base64'
exports.GERMAN = parseStrings GERMAN

GERMAN2 = new Buffer window.DATA.GEODATA.GERMAN2, 'base64'
exports.GERMAN2 = parseStrings GERMAN2

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

###
  SOUND/SAMPLE.CAT
  SOUND/SAMPLE2.CAT
  SOUND/SAMPLE3.CAT
###
SAMPLE = new Buffer window.DATA.SOUND.SAMPLE, 'base64'
SAMPLE2 = new Buffer window.DATA.SOUND.SAMPLE2, 'base64'
SAMPLE3 = new Buffer window.DATA.SOUND.SAMPLE3, 'base64'

numSamples = (buffer) ->
  # divide the offset of the first file by 8
  # the result is the number of 8 byte table entries
  # i.e.: the number of samples in the file
  buffer.readUInt32LE(0) >> 3

parseSample = (buffer, index) ->
  offset = buffer.readUInt32LE i*8
  length = buffer.readUInt32LE i*8+4
  numHeaderBytes = buffer[offset]
  header = buffer.slice offset, offset+numHeaderBytes+1
  soundFile = buffer.slice offset+numHeaderBytes+1, offset+length+numHeaderBytes+1
  soundData = soundFile.slice 0x2c
  result =
    offset: offset
    length: length
    header: header
    file: soundFile
    data: soundData

SAMPLE = [
  (parseSample SAMPLE, i for i in [0...numSamples SAMPLE])
  (parseSample SAMPLE2, i for i in [0...numSamples SAMPLE2])
  (parseSample SAMPLE3, i for i in [0...numSamples SAMPLE3])
]

exports.SAMPLE = SAMPLE

#----------------------------------------------------------------------------
# end of xcom.coffee
