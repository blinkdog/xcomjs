# sound.coffee
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

{SAMPLE_RATE} = require './constant'

###
  Utility Functions
###
audioContext = new window.AudioContext()

resample = (pcmData, pcmRate, webFrame, webRate) ->
  pcmFrame = Math.floor ((webFrame * pcmRate) / webRate)
  data = pcmData[pcmFrame]
  webData = (data - 128) / 128.0
  return webData

createSample = (sampleObj) ->
  # define some parameters
  channels = 1
  {sampleRate} = audioContext
  frameCount = sampleObj.data.length * (sampleRate / SAMPLE_RATE)
  # create the buffer to hold the sample
  sampleBuffer = audioContext.createBuffer channels, frameCount, sampleRate
  # fill the buffer with audio data
  channelData = sampleBuffer.getChannelData 0
  for i in [0...frameCount]
    channelData[i] = resample sampleObj.data, SAMPLE_RATE, i, sampleRate
  # return the sample buffer
  return sampleBuffer

###
  SAMPLE2.CAT
###
createBattlescapeSample = (index) ->
  createSample window.XCOM.SAMPLE[1][index]

createBattlescapeSampleMemo = _.memoize createBattlescapeSample

exports.getBattlescapeSample = (index) ->
  createBattlescapeSampleMemo index

###
  SAMPLE.CAT
###
createGeoscapeSample = (index) ->
  createSample window.XCOM.SAMPLE[0][index]

createGeoscapeSampleMemo = _.memoize createGeoscapeSample

exports.getGeoscapeSample = (index) ->
  createGeoscapeSampleMemo index

###
  SAMPLE3.CAT
###
createIntroSample = (index) ->
  createSample window.XCOM.SAMPLE[2][index]

createIntroSampleMemo = _.memoize createIntroSample

exports.getIntroSample = (index) ->
  createIntroSampleMemo index

###
  Play some of these nice samples
###
exports.playSample = (sample) ->
  source = audioContext.createBufferSource()
  source.buffer = sample
  source.connect audioContext.destination
  source.start()

#----------------------------------------------------------------------------
# end of sound.coffee
