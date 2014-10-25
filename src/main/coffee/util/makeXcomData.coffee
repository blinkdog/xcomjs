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
      PALETTES_DAT: source xcomPath, 'GEODATA/PALETTES.DAT'
  # write the X-COM game data object to a json file
  dataOut = fs.createWriteStream dataPath
  dataOut.write JSON.stringify XCOMDATA, null, 2
  dataOut.end()

#----------------------------------------------------------------------------
# end of makeXcomData.coffee
