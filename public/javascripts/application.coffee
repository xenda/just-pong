$(document).ready ->
  game = new window.GameManager $("#board"), $(".paddle.left"), $(".paddle.right"), $("#ball")
  game.run()
