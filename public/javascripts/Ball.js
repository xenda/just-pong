// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.Ball = (function(_super) {

    __extends(Ball, _super);

    function Ball(el, board) {
      this.el = el;
      this.board = board;
      this.leftLimit = 0;
      this.rightLimit = this.board.width() - this.el.width();
      this.topLimit = 0;
      this.bottomLimit = this.board.height() - this.el.height();
      this.placeBall();
    }

    Ball.prototype.placeBall = function() {
      this.x = this.random(this.rightLimit, this.leftLimit);
      this.y = this.random(this.bottomLimit, this.topLimit);
      this.dx = (this.rightLimit - this.leftLimit) / 5 * this.randOpt(1, -1);
      return this.dy = (this.bottomLimit - this.topLimit) / 5 * this.randOpt(1, -1);
    };

    Ball.prototype.randOpt = function(one, second) {
      if (Math.random() > 0.5) {
        return one;
      } else {
        return second;
      }
    };

    Ball.prototype.random = function(from, to) {
      return Math.floor(Math.random() * (from - to));
    };

    Ball.prototype.move = function(tick, leftPaddle, rightPaddle) {
      this.x = this.x + (this.dx * tick);
      this.y = this.y + (this.dy * tick);
      if (this.checkCollisionWith(leftPaddle) || this.checkCollisionWith(rightPaddle)) {
        this.dx = -this.dx;
        this.x = this.x + (this.dx * tick) * 2;
      }
      if (this.dx > 0 && this.x > this.rightLimit + 20) {
        $.event.trigger('score', "left");
        return this.placeBall();
      } else {
        if (this.dx < 0 && this.x < this.leftLimit - 20) {
          $.event.trigger('score', "right");
          return this.placeBall();
        } else {
          if (this.dy > 0 && this.y > this.bottomLimit) {
            this.y = this.bottomLimit;
            return this.dy = -this.dy;
          } else {
            if (this.dy < 0 && this.y < this.topLimit) {
              this.y = this.topLimit;
              return this.dy = -this.dy;
            }
          }
        }
      }
    };

    Ball.prototype.reverse = function(tick) {
      this.el.stop(true, false);
      this.move(tick);
      return this.dx = -this.dx;
    };

    Ball.prototype.checkCollisionWith = function(paddle) {
      if (paddle.left() < (this.left() + this.width()) && (paddle.left() + paddle.width()) > this.left() && paddle.top() < (this.top() + this.height()) && (paddle.top() + paddle.height()) > this.top()) {
        return true;
      }
    };

    Ball.prototype.display = function() {
      return this.el.css({
        "top": "" + this.y + "px",
        "left": "" + this.x + "px"
      });
    };

    return Ball;

  })(window.GameObject);

}).call(this);
