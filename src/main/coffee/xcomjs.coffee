# xcomjs.coffee
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

XCOM_SIZE =
  width: 320
  height: 200

toFillStyle = (rgb) ->
  r = rgb[0]
  g = rgb[1]
  b = rgb[2]
  rs = "00" + r.toString 16
  gs = "00" + g.toString 16
  bs = "00" + b.toString 16
  rs = rs.substr -2
  gs = gs.substr -2
  bs = bs.substr -2
  "##{rs}#{gs}#{bs}"

resize = ->
  # determine how large the window is
  { innerHeight, innerWidth } = window
  # resize the canvas to fit
  canvas = $("#canvas")[0]
  canvas.width = innerWidth
  canvas.height = innerHeight
  # figure out where X-COM is going to display on the canvas
  canvas.scale = Math.floor Math.min innerHeight / XCOM_SIZE.height, innerWidth / XCOM_SIZE.width
  canvas.ox = Math.floor((canvas.width - (XCOM_SIZE.width * canvas.scale)) / 2)
  canvas.oy = Math.floor((canvas.height - (XCOM_SIZE.height * canvas.scale)) / 2)
  # clean the canvas
  canvas.getContext("2d").fillStyle = '#000000' # clear to black
  canvas.getContext("2d").fillRect 0, 0, canvas.width, canvas.height
  canvas.getContext("2d").fillStyle = '#ff00ff' # magic pink
  canvas.getContext("2d").fillRect canvas.ox, canvas.oy, XCOM_SIZE.width * canvas.scale, XCOM_SIZE.height * canvas.scale
  # draw some stuff on the canvas to prove we got the palettes
  for palIndex in [0..4]
    for colIndex in [0..255]
      fillStyle = toFillStyle window.XCOM.PALETTES[palIndex][colIndex]
      canvas.getContext("2d").fillStyle = fillStyle
      dx = canvas.ox+canvas.scale*colIndex
      dy = canvas.oy+canvas.scale*40*palIndex
      dw = canvas.scale
      dh = canvas.scale*40
      canvas.getContext("2d").fillRect dx, dy, dw, dh

exports.run = ->
  # add the X-COM game data objects
  window.XCOM = require './xcom'
  # manually resize the canvas once
  resize()
  # if the user resizes the browser, then resize the canvas to match
  window.addEventListener 'resize', resize

#----------------------------------------------------------------------------
# end of xcomjs.coffee
