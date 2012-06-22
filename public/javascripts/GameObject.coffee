class window.GameObject
  constructor: (@el, @board) ->
  left: ->
    @el.position().left
  top:  ->
    @el.position().top
  width: ->
    @el.width()
  height: ->
    @el.height()