# activity.coffee
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
  This file intended to serve as a template for activities.
###

activity =
  # the name of the activity
  name: "ACTIVITY_NAME"
  
  # called before this activity begins
  enter: ->
  
  # called after this activity is finished
  leave: ->
  
  # called when the user presses a mouse button
  mousedown: (e) ->
  
  # called when the user moves the mouse
  mousemove: (e) ->
  
  # called when the user releases a mouse button
  mouseup: (e) ->
  
  # called by the game engine to draw the display
  render: (timestamp, canvas) ->
  
  # called by the game engine to update logic/state
  update: (timestamp) -> this

# export this activity to others
exports.activity = activity

#----------------------------------------------------------------------------
# end of activity.coffee
