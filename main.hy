;; This software is in the public domain.

(import turtle)
(import sys)

(setv G 8)

(defclass GravSys []
    (defn __init__[self]
        (setv self.planets [])
        (setv self.t 0)
        (setv self.dt 0.01))

    (defn init[self]
        (for [p self.planets]
            (p.init)))

    (defn start[self]
        (for [i (range 10000)]
            (+= self.t (+ self.t self.dt))
            (for [p self.planets]
                (p.step)))))

(defclass Star [turtle.Turtle]
    (defn __init__[self m x v gravSys shape]
        (turtle.Turtle.__init__ self :shape shape)
        (self.penup)
        (setv self.m m)
        (self.setpos x)
        (setv self.v v)
        (.append gravSys.planets self)
        (setv self.gravSys gravSys)
        (self.resizemode "user")
        (self.pendown))

    (defn init[self]
        (setv dt self.gravSys.dt)
        (setv self.a (self.acc))
        (+= self.v (* self.a 0.5 dt)))

    (defn acc[self]
        (setv a (turtle.Vec2D 0 0))
        (for [planet self.gravSys.planets]
            (if (!= planet self)
                (do (setv v (- (planet.pos) (self.pos)))
                    (+= a (* v (/ (* G planet.m) (** (abs v) 3)))))))
        (return a))

    (defn step[self]
        (setv dt self.gravSys.dt)
        (self.setpos (+ (self.pos) (* dt self.v)))
        (if (!= (.index self.gravSys.planets self) 0)
            (self.setheading (self.towards (get self.gravSys.planets 0))))
        (setv self.a (self.acc))
        (+= self.v (* dt self.a))))

(defn main[]
    (setv s (turtle.Turtle))
    (turtle.onscreenclick (fn [x y] (turtle.exitonclick)))
    (s.reset)
    (s.ht)
    (s.pu)
    (s.fd 6)
    (s.lt 90)
    (s.begin_poly)
    (s.circle 6 180)
    (s.end_poly)
    (setv m1 (s.get_poly))
    (s.begin_poly)
    (s.circle 6 180)
    (s.end_poly)
    (setv m2 (s.get_poly))

    (setv planetshape (turtle.Shape "compound"))
    (planetshape.addcomponent m1 "orange")
    (planetshape.addcomponent m2 "blue")
    (.register_shape (s.getscreen) "planet" planetshape)
    (.tracer (s.getscreen) 1 0)

    (setv gs (GravSys))
    (setv sun (Star 1000000 (turtle.Vec2D 0 0) (turtle.Vec2D 0 -2.5) gs "circle"))
    (sun.color "yellow")
    (sun.shapesize 1.8)
    (sun.pu)
    (setv earth (Star 12500 (turtle.Vec2D 210 0) (turtle.Vec2D 0 195) gs "planet"))
    (earth.pencolor "green")
    (earth.shapesize 0.8)
    (setv moon (Star 1 (turtle.Vec2D 220 0) (turtle.Vec2D 0 295) gs "planet"))
    (moon.pencolor "blue")
    (moon.shapesize 0.5)
    (gs.init)
    (gs.start))

(if (= __name__ "__main__")
    (do (main)
        (turtle.mainloop)))
