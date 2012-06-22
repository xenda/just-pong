class Paddle
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

  left: ->
    @el.position().left
  top:  ->
    @el.position().top
  width: ->
    @el.width()
  height: ->
    @el.height()



class Ball
  constructor: (@el, @board) ->
    @leftLimit   = 0 #+ @el.position().left
    @rightLimit  = @board.width() - @el.width()
    @topLimit    = 0
    @bottomLimit = @board.height() - @el.height()
    @placeBall()


  placeBall: ->
    @x           = @random(@rightLimit, @leftLimit)
    @y           = @random(@bottomLimit, @topLimit)
    @dx          = (@rightLimit - @leftLimit) / 5 * @randOpt(1, -1)
    @dy          = (@bottomLimit - @topLimit) / 5 * @randOpt(1, -1)

  randOpt: (one, second) ->
    if Math.random() > 0.5
      one
    else
      second

  random: (from, to) ->
    Math.floor( Math.random() * (from - to) )

  move: (tick, leftPaddle, rightPaddle) ->
    @x = @x + (@dx * tick)
    @y = @y + (@dy * tick)

    if @checkCollisionWith(leftPaddle) or @checkCollisionWith(rightPaddle)
      @dx = -@dx
      @x = @x + (@dx * tick) * 2

    if @dx > 0 and @x > @rightLimit + 20
      $.event.trigger('score',"left")
      @placeBall()
    else
      if @dx < 0 and @x < @leftLimit - 20
        $.event.trigger('score',"right")
        @placeBall()
      else
        if @dy > 0 and @y > @bottomLimit
          @y = @bottomLimit
          @dy = -@dy
        else
          if @dy < 0 and @y < @topLimit
            @y = @topLimit
            @dy = -@dy

  reverse: (tick)->
    @el.stop(true, false)
    console.log("here")
    @move(tick)
    @dx = -@dx

  checkCollisionWith: (paddle) ->
    true if (paddle.left()<(@left()+@width())&&(paddle.left()+paddle.width())>@left() && paddle.top()<(@top()+@height())&&(paddle.top()+paddle.height())>@top())

  display: ->
    @el.css
      "top" : "#{@y}px"
      "left": "#{@x}px"

  left: ->
    @el.position().left
  top:  ->
    @el.position().top
  width: ->
    @el.width()
  height: ->
    @el.height()


class GameManager
  constructor: (@board, leftPaddleEl, rightPaddleEl, ballEl) ->
    @leftPaddle  = new Paddle leftPaddleEl, @board
    @rightPaddle = new Paddle rightPaddleEl, @board
    @ball        = new Ball ballEl, @board
    @tick        = 0
    @leftScore   = 0
    @rightScore  = 0
    @ball.display()
    @setupControls()
    @registerListeners()

  setupControls: ->
    key 'w', => @leftPaddle.moveUp()
    key 's', => @leftPaddle.moveDown()
    key 'i', => @rightPaddle.moveUp()
    key 'k', => @rightPaddle.moveDown()

  registerListeners: ->
    $(document).on 'score', (event, side) =>
      if side == 'left'
        @leftScore += 1
      else
        @rightScore += 1
      @updateScores()

  updateScores: ->
    $("span.left").html("#{@leftScore}")
    $("span.right").html("#{@rightScore}")

  run: ->
    setInterval =>
      @ball.move(@tick, @leftPaddle, @rightPaddle)
      @ball.display()
      @tick=+0.1
    ,50

$(document).ready ->
  game = new GameManager $("#board"), $(".paddle.left"), $(".paddle.right"), $("#ball")
  game.run()
