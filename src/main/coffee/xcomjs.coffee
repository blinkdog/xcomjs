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

{activity} = require './activity/selectLanguage'

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
  # update the game and potentially change the activity
  newActivity = activity.update Date.now()
  if newActivity.name isnt activity.name
    activity.leave()
    newActivity.enter()
    activity = newActivity
  # do some frame and timing bookkeeping
  if window.DEBUG_OVERLAY?
    deltaTime = Math.floor(timestamp - window.DEBUG_OVERLAY.lastTime)
    window.DEBUG_OVERLAY.lastTime = Math.floor timestamp
    window.DEBUG_OVERLAY.fpsCount++
    window.DEBUG_OVERLAY.fpsTime += deltaTime
    if window.DEBUG_OVERLAY.fpsTime >= 1000
      window.DEBUG_OVERLAY.lastFps = window.DEBUG_OVERLAY.fpsCount
      window.DEBUG_OVERLAY.fpsTime %= 1000
      window.DEBUG_OVERLAY.fpsCount = 0
  # render the activity
  canvas = $("#canvas")[0]
  activity.render timestamp, canvas
  # render the DEBUG_OVERLAY
  if window.DEBUG_OVERLAY?
    {xcomX, xcomY, lastFps, xDown} = window.DEBUG_OVERLAY
    displayText = "FPS:#{('000'+lastFps).substr(-3)} "
    displayText += "X:#{('000'+xcomX).substr(-3)} "
    displayText += "Y:#{('000'+xcomY).substr(-3)} "
    if window.DEBUG_OVERLAY.xDown[0]?
      displayText += "LX:#{('000'+xDown[0][0]).substr(-3)} "
      displayText += "LY:#{('000'+xDown[0][1]).substr(-3)} "
    if window.DEBUG_OVERLAY.xDown[1]?
      displayText += "MX:#{('000'+xDown[1][0]).substr(-3)} "
      displayText += "MY:#{('000'+xDown[1][1]).substr(-3)} "
    if window.DEBUG_OVERLAY.xDown[2]?
      displayText += "RX:#{('000'+xDown[2][0]).substr(-3)} "
      displayText += "RY:#{('000'+xDown[2][1]).substr(-3)} "
    displayText = displayText.trim()
    buttonFont = font.getSmallFont canvas.scale, 0, 134
    background = gfx.getBackgroundImage canvas.scale, 0, 0
    render.drawBackground canvas, background, 0, 0, 256, 9
    render.drawText canvas, buttonFont, displayText, 0, 0
  # request another animation frame when it is time
  requestAnimationFrame drawAnimationFrame

exports.run = ->
  # extend Array
  Array::random = ->
    return null if not @length
    return @[Math.floor Math.random() * @length]
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
    xDown: []

  # add our event handlers to the main canvas
  canvas = $("#canvas")[0]
  
  # prevent browser from showing right-click menu
  canvas.oncontextmenu = -> false
  
  # update when the user moves the mouse
  canvas.addEventListener 'mousemove', (e) ->
    xcomX = Math.floor (e.clientX - canvas.ox) / canvas.scale
    xcomY = Math.floor (e.clientY - canvas.oy) / canvas.scale
    window.DEBUG_OVERLAY.xcomX = xcomX
    window.DEBUG_OVERLAY.xcomY = xcomY

  # update when the user pushes a mouse button
  canvas.addEventListener 'mousedown', (e) ->
    xcomX = Math.floor (e.clientX - canvas.ox) / canvas.scale
    xcomY = Math.floor (e.clientY - canvas.oy) / canvas.scale
    if xcomX >= 0 and xcomX <= 319 and xcomY >= 0 and xcomY <= 199
      e.xcomX = xcomX
      e.xcomY = xcomY
      activity.mousedown e
      window.DEBUG_OVERLAY.xDown[e.button] = [xcomX, xcomY]
  
  # update when the user releases a mouse button
  canvas.addEventListener 'mouseup', (e) ->
    activity.mouseup e
    window.DEBUG_OVERLAY.xDown[e.button] = undefined

  # prime the activity before we get started
  activity.enter()
  # ask the browser to render the display (i.e.: play the game)
  requestAnimationFrame drawAnimationFrame

#----------------------------------------------------------------------------
# end of xcomjs.coffee
