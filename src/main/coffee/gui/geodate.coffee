# geodate.coffee
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

moment = require 'moment'

{
  COLOR_DATE_BLUE
} = require '../constant'

font = require '../font'
renderer = require '../render'

class GeoscapeDate
  constructor: (canvas) ->
    @largeDateFont = font.getLargeFont canvas.scale, COLOR_DATE_BLUE[0], COLOR_DATE_BLUE[1], false
    @smallDateFont = font.getSmallFont canvas.scale, COLOR_DATE_BLUE[0], COLOR_DATE_BLUE[1], false
    @ox = 257
    @oy = 72

  mousedown: (e) ->
    ###
      this component does not handle mouse clicks
    ###
  
  mouseup: (e) ->
    ###
      this component does not handle mouse clicks
    ###

  render: (canvas, game) ->
    {date} = game
    utcMoment = moment(date).utc()
    # draw the time
    renderer.drawText canvas, @largeDateFont, ':', @ox+22, @oy+2
    renderer.drawText canvas, @largeDateFont, ':', @ox+46, @oy+2
    hourText = utcMoment.format('H')
    hourX = 2
    hourX += 10 if hourText.length is 1
    renderer.drawText canvas, @largeDateFont, hourText, @ox+hourX, @oy+2
    renderer.drawText canvas, @largeDateFont, utcMoment.format('mm'), @ox+26, @oy+2
    renderer.drawText canvas, @smallDateFont, utcMoment.format('ss'), @ox+50, @oy+8
    # draw the day of the week
    dayText = utcMoment.format('dddd').toUpperCase()
    dayWidth = @smallDateFont.measure dayText
    dayOffset = (63 - dayWidth) >> 1
    renderer.drawText canvas, @smallDateFont, dayText, @ox+dayOffset, @oy+15
    # draw the day of the month and month
    domText = utcMoment.format('Do  MMM')
    domWidth = @smallDateFont.measure domText
    domOffset = (63 - domWidth) >> 1
    renderer.drawText canvas, @smallDateFont, domText, @ox+domOffset, @oy+22
    # draw the year
    yearText = utcMoment.format('YYYY')
    yearWidth = @smallDateFont.measure yearText
    yearOffset = (63 - yearWidth) >> 1
    renderer.drawText canvas, @smallDateFont, yearText, @ox+yearOffset, @oy+29

exports.GeoscapeDate = GeoscapeDate

#----------------------------------------------------------------------------
# end of geodate.coffee
