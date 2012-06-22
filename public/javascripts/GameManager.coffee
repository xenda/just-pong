class window.GameManager
  constructor: (@board, leftPaddleEl, rightPaddleEl, ballEl) ->
    @leftPaddle  = new window.Paddle leftPaddleEl, @board
    @rightPaddle = new window.Paddle rightPaddleEl, @board
    @ball        = new window.Ball ballEl, @board
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
