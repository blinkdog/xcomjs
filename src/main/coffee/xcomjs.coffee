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

{XCOM_SIZE} = require './constant'
font = require './font'
gfx = require './gfx'
render = require './render'

resize = ->
  # determine how large the window is
  { innerHeight, innerWidth } = window
  # resize the canvas to fit
  canvas = $("#canvas")[0]
  canvas.width = innerWidth
  canvas.height = innerHeight
  canvas.getContext("2d").imageSmoothingEnabled = false
  # figure out where X-COM is going to display on the canvas
  canvas.scale = Math.floor Math.min innerHeight / XCOM_SIZE.HEIGHT, innerWidth / XCOM_SIZE.WIDTH
  canvas.ox = Math.floor((canvas.width - (XCOM_SIZE.WIDTH * canvas.scale)) / 2)
  canvas.oy = Math.floor((canvas.height - (XCOM_SIZE.HEIGHT * canvas.scale)) / 2)
  # clean the canvas
  canvas.getContext("2d").fillStyle = '#000000' # clear to black
  canvas.getContext("2d").fillRect 0, 0, canvas.width, canvas.height
  canvas.getContext("2d").fillStyle = '#ff00ff' # magic pink
  canvas.getContext("2d").fillRect canvas.ox, canvas.oy, XCOM_SIZE.WIDTH * canvas.scale, XCOM_SIZE.HEIGHT * canvas.scale

installShimJQ = ->
  window.$ = (selector) ->
    if selector is "#canvas"
      return [ document.getElementById("canvas") ]
    alert "Unknown selector #{selector}"

exports.run = ->
  # shim jQuery if needed
  if not window.$
    installShimJQ()
  # add the X-COM game data objects
  window.XCOM = require './xcom'
  # manually resize the canvas once
  resize()
  # if the user resizes the browser, then resize the canvas to match
  window.addEventListener 'resize', resize
  # let's draw a language selection screen to show that we can do it
  canvas = $("#canvas")[0]
  # clear the canvas to black
  render.clearCanvas canvas
  # draw the window background
  background = gfx.getBackgroundImage canvas.scale, 0, 0
  render.drawBackground canvas, background, 32, 20, 256, 160
  # draw the window border
  windowBorder = gfx.getWindowBorder canvas.scale, 0, 134, 256, 160
  render.drawGraphic canvas, windowBorder, 32, 20
  # draw the language selection buttons
  button = gfx.getButton canvas.scale, 0, 134, 192, 20
  render.drawGraphic canvas, button, 64, 90
  render.drawGraphic canvas, button, 64, 118
  render.drawGraphic canvas, button, 64, 146
  # draw the labels on the buttons
  buttonFont = font.getSmallFont canvas.scale, 0, 134
  render.drawCenterText canvas, buttonFont, "ENGLISH", 96
  render.drawCenterText canvas, buttonFont, "DEUTSCHE", 124
  render.drawCenterText canvas, buttonFont, "FRANCAIS", 152

#----------------------------------------------------------------------------
# end of xcomjs.coffee
