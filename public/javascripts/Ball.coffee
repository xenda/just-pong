class window.Ball extends window.GameObject
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
    @move(tick)
    @dx = -@dx

  checkCollisionWith: (paddle) ->
    true if (paddle.left()<(@left()+@width())&&(paddle.left()+paddle.width())>@left() && paddle.top()<(@top()+@height())&&(paddle.top()+paddle.height())>@top())

  display: ->
    @el.css
      "top" : "#{@y}px"
      "left": "#{@x}px"