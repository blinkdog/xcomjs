# sample.coffee
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

###
  PMM: This is kind of a rough draft for the sample parsing code in
       xcom.coffee; it is still useful as an extractor. Just change
       the variable FILENAME below, and it will spit out all the WAVE
       files in the .CAT file.
###

FILENAME = 'SAMPLE.CAT'

fs = require 'fs'

data = fs.readFileSync FILENAME
firstOffset = data.readUInt32LE 0
numEntries = firstOffset >> 3 # / 8

readSample = (index) ->
  offset = data.readUInt32LE i*8
  length = data.readUInt32LE i*8+4
  numHeaderBytes = data[offset]
  header = data.slice offset, offset+numHeaderBytes+1
  soundData = data.slice offset+numHeaderBytes+1, offset+length+numHeaderBytes+1
  result =
    offset: offset
    length: length
    header: header
    data: soundData

samples = (readSample i for i in [0...numEntries])

process.stdout.write "Length: " + data.length + "\n"
process.stdout.write "First Offset: " + firstOffset + "\n"
process.stdout.write "Num Entries: " + numEntries + "\n"
count = 0
for sample in samples
  process.stdout.write "[" + ("000"+count).substr(-3) + "] "
  process.stdout.write "Offset:" + sample.offset + " Length:" + sample.length + " Data Length:" + sample.data.length
  process.stdout.write "\t" + sample.data.slice(0x24, 0x28).toString() + "\n"
  fs.writeFileSync 'extract'+("000"+count).substr(-3)+'.wav', sample.data
  count++

#----------------------------------------------------------------------------
# end of sample.coffee
