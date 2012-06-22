class window.Paddle extends window.GameObject
  constructor: (@el, @board) ->
    @steps       = 150
    @topLimit    = 0
    @bottomLimit = board.height()

  belowTopBoundaries: ->
    @top() > Math.abs(@steps)

  aboveBottomBoundaries: ->
    (@top() + @height() + @steps) < @bottomLimit

  movementTillTop: ->
    @topLimit - @top()

  movementTillBottom: ->
    @bottomLimit - @top() - @height()

  moveUp: ->
    if @belowTopBoundaries()
      @move(-@steps)
    else
      @move(@movementTillTop())

  moveDown: ->
    if @aboveBottomBoundaries()
      @move()
    else
      @move(@movementTillBottom())

  move: (steps=@steps) =>
    @el.stop(true, false)
    @el.animate
      'top': "+=#{steps}px"
    , easing: 'linear'
    10
