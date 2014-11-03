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

drawAnimationFrame = (timestamp) ->
  # do some frame and timing bookkeeping
  if window.DEBUG_OVERLAY?
    deltaTime = Math.floor(timestamp - window.DEBUG_OVERLAY.lastTime)
    window.DEBUG_OVERLAY.lastTime = Math.floor timestamp
    window.DEBUG_OVERLAY.fpsCount++
    window.DEBUG_OVERLAY.fpsTime += deltaTime
    if window.DEBUG_OVERLAY.fpsTime >= 1000
      window.DEBUG_OVERLAY.lastFps = window.DEBUG_OVERLAY.fpsCount
      window.DEBUG_OVERLAY.fpsTime -= 1000
      window.DEBUG_OVERLAY.fpsCount = 0
  # if we clicked somewhere important
  pushed0 = false
  pushed1 = false
  pushed2 = false
  if window.DEBUG_OVERLAY.xDownX?
    mx = window.DEBUG_OVERLAY.xDownX
    my = window.DEBUG_OVERLAY.xDownY
    if mx >= 64 and mx <= 256
      pushed0 = true if my >= 90 and my <= 110
      pushed1 = true if my >= 118 and my <= 138
      pushed2 = true if my >= 146 and my <= 166
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
  pushedButton = gfx.getButton canvas.scale, 0, 134, 192, 20, true
  if pushed0
    render.drawGraphic canvas, pushedButton, 64, 90
  else
    render.drawGraphic canvas, button, 64, 90
  if pushed1
    render.drawGraphic canvas, pushedButton, 64, 118
  else
    render.drawGraphic canvas, button, 64, 118
  if pushed2
    render.drawGraphic canvas, pushedButton, 64, 146
  else
    render.drawGraphic canvas, button, 64, 146
  # draw the labels on the buttons
  buttonFont = font.getSmallFont canvas.scale, 0, 134
  pushedButtonFont = font.getSmallFont canvas.scale, 0, 134, true
  if pushed0
    render.drawCenterText canvas, pushedButtonFont, "ENGLISH", 96
  else
    render.drawCenterText canvas, buttonFont, "ENGLISH", 96
  if pushed1
    render.drawCenterText canvas, pushedButtonFont, "DEUTSCHE", 124
  else
    render.drawCenterText canvas, buttonFont, "DEUTSCHE", 124
  if pushed2
    render.drawCenterText canvas, pushedButtonFont, "FRANCAIS", 152
  else
    render.drawCenterText canvas, buttonFont, "FRANCAIS", 152
  # render the DEBUG_OVERLAY
  if window.DEBUG_OVERLAY?
    {xcomX, xcomY, lastFps, xDownX, xDownY} = window.DEBUG_OVERLAY
    displayText = "FPS:#{('000'+lastFps).substr(-3)} "
    displayText += "X:#{('000'+xcomX).substr(-3)} "
    displayText += "Y:#{('000'+xcomY).substr(-3)} "
    if window.DEBUG_OVERLAY.xDownX?
      displayText += "MX:#{('000'+xDownX).substr(-3)} "
      displayText += "MY:#{('000'+xDownY).substr(-3)} "
    displayText = displayText.trim()
    buttonFont = font.getSmallFont canvas.scale, 0, 134
    background = gfx.getBackgroundImage canvas.scale, 0, 0
    render.drawBackground canvas, background, 0, 0, 320, 9
    render.drawText canvas, buttonFont, displayText, 0, 0
  # draw another animation frame when it is time
  requestAnimationFrame drawAnimationFrame

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
  # create a DBEUG_OVERLAY object
  window.DEBUG_OVERLAY =
    fpsCount: 0
    fpsTime: 0
    lastFps: 0
    lastTime: 0
    mouseX: 0
    mouseY: 0
    xcomX: 0
    xcomY: 0
  # let's draw a language selection screen to show that we can do it
  canvas = $("#canvas")[0]
  canvas.addEventListener 'mousemove', (e) ->
    window.DEBUG_OVERLAY ?= {}
    window.DEBUG_OVERLAY.mouseX = e.clientX
    window.DEBUG_OVERLAY.mouseY = e.clientY
    xcomX = Math.floor (e.clientX - canvas.ox) / canvas.scale
    xcomY = Math.floor (e.clientY - canvas.oy) / canvas.scale
    xcomX = Math.max 0, xcomX
    xcomY = Math.max 0, xcomY
    xcomX = Math.min xcomX, 319
    xcomY = Math.min xcomY, 199
    window.DEBUG_OVERLAY.xcomX = xcomX
    window.DEBUG_OVERLAY.xcomY = xcomY
  canvas.addEventListener 'mousedown', (e) ->
    window.DEBUG_OVERLAY ?= {}
    window.DEBUG_OVERLAY.downX = e.clientX
    window.DEBUG_OVERLAY.downY = e.clientY
    xcomX = Math.floor (e.clientX - canvas.ox) / canvas.scale
    xcomY = Math.floor (e.clientY - canvas.oy) / canvas.scale
    xcomX = Math.max 0, xcomX
    xcomY = Math.max 0, xcomY
    xcomX = Math.min xcomX, 319
    xcomY = Math.min xcomY, 199
    window.DEBUG_OVERLAY.xDownX = xcomX
    window.DEBUG_OVERLAY.xDownY = xcomY
  canvas.addEventListener 'mouseup', (e) ->
    delete window.DEBUG_OVERLAY.downX
    delete window.DEBUG_OVERLAY.downY
    delete window.DEBUG_OVERLAY.xDownX
    delete window.DEBUG_OVERLAY.xDownY
  
  # ask the browser to render the display
  requestAnimationFrame drawAnimationFrame

#----------------------------------------------------------------------------
# end of xcomjs.coffee
