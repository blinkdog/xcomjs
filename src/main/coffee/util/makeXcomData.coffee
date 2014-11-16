# makeXcomData.coffee
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

fs = require 'fs'
path = require 'path'

source = (xcomPath, filePath) ->
  dataPath = path.join xcomPath, filePath
  data = fs.readFileSync dataPath
  data.toString 'base64'

exports.run = (xcomPath, dataPath) ->
  # build the X-COM game data object
  XCOMDATA =
    GEODATA:
      BACKPALS: source xcomPath, 'GEODATA/BACKPALS.DAT'
      BIGLETS: source xcomPath, 'GEODATA/BIGLETS.DAT'
      ENGLISH: source xcomPath, 'GEODATA/ENGLISH.DAT'
      ENGLISH2: source xcomPath, 'GEODATA/ENGLISH2.DAT'
      FRENCH: source xcomPath, 'GEODATA/FRENCH.DAT'
      FRENCH2: source xcomPath, 'GEODATA/FRENCH2.DAT'
      GERMAN: source xcomPath, 'GEODATA/GERMAN.DAT'
      GERMAN2: source xcomPath, 'GEODATA/GERMAN2.DAT'
      LANG1: source xcomPath, 'GEODATA/LANG1.DAT'
      LANG2: source xcomPath, 'GEODATA/LANG2.DAT'
      PALETTES: source xcomPath, 'GEODATA/PALETTES.DAT'
      SMALLSET: source xcomPath, 'GEODATA/SMALLSET.DAT'
    GEOGRAPH:
      BACK: (source xcomPath, "GEOGRAPH/BACK#{("0"+i).substr(-2)}.SCR" for i in [1..17])
      GEOBORD: source xcomPath, 'GEOGRAPH/GEOBORD.SCR'
    SOUND:
      SAMPLE: source xcomPath, 'SOUND/SAMPLE.CAT'
      SAMPLE2: source xcomPath, 'SOUND/SAMPLE2.CAT'
      SAMPLE3: source xcomPath, 'SOUND/SAMPLE3.CAT'
  # write the X-COM game data object to a json file
  dataOut = fs.createWriteStream dataPath
  dataOut.write JSON.stringify XCOMDATA, null, 2
  dataOut.end()
  # compress the json file
# PMM: We aren't doing this yet, but it might be useful later.
#  gzip = require('zlib').createGzip()
#  inp = fs.createReadStream dataPath
#  out = fs.createWriteStream dataPath + '.gz'
#  inp.pipe(gzip).pipe out

#----------------------------------------------------------------------------
# end of makeXcomData.coffee
