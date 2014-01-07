#! /usr/bin/python

from datetime import datetime
import turtle

def ensure_tuple(value):
    if not isinstance(value, tuple):
         value = (value, value)
    return value

def grow(size, angle, depth, size_decrease = None, angle_decrease = None, worker = None):
    size = ensure_tuple(size)
    angle = ensure_tuple(angle)
    if angle_decrease is None:
        angle_decrease = lambda a: a
    if size_decrease is None:
        size_decrease = lambda x: (x[0]-1, x[1]-1)
    if worker is None:
        worker = turtle.Turtle()

    if min(size) > depth:
        worker.right(angle[1])
        worker.forward(size[1])
        grow(size_decrease(size), angle_decrease(angle), depth,\
             size_decrease, angle_decrease, worker)
        worker.left(180)
        worker.forward(size[1])
        worker.right(180 - sum(angle))
        worker.forward(size[0])
        grow(size_decrease(size), angle_decrease(angle), depth,\
             size_decrease, angle_decrease, worker)
        worker.left(180)
        worker.forward(size[0])
        worker.left(180 - angle[0])

def circle(n, step, action=None, worker=None):
    if worker is None:
        worker = turtle.Turtle()

    pen = worker.pen()
    angle = +1
    if n < 0:
        n = -1*n
        angle = -1
        
    for i in range(n):
        worker.forward(step);
        worker.right(angle*360/n)
        if action is not None:
            action(worker, i)

    worker.pen(pen)


def change(worker, i, one, two):
    if i % one == 0:
        worker.width(worker.width() + 1)
    if i % two == 0:
        worker.pen(pendown = not worker.pen()['pendown'])
        

def staircase():
    for i in range(100):
        a.forward(1*((i+1)**1.2))
        a.right(89)

def line(lengths, pendowns=True, widths=None, worker=None):
    if worker is None:
        worker = turtle.Turtle()
    if not isinstance(lengths, tuple):
        lengths = (lengths,)
    if not isinstance(pendowns, tuple):
        pendowns = (pendowns,)*len(lengths)
    width = worker.width()
    if widths is None:
        widths = width
    if not isinstance(widths, tuple):
        widths = (widths,)*len(lengths)
    length = 0
    pen = worker.pen()

    for index in range(len(lengths)):
        length += lengths[index]
        worker.pen(pendown=pendowns[index], pensize=widths[index])
        worker.forward(lengths[index])

    worker.penup()
    worker.backward(length)
    worker.pen(pen)

def clock(worker=None):
    if worker is None:
        worker = turtle.Turtle()
    worker.right(3)
    time = datetime.time(datetime.now())
    for i in range(60):
        worker.penup()
        if i % 5 == 0:
            worker.left(93)
            line(20, worker = worker)
            worker.right(93)
        if i == int((time.hour % 12)*5 + 5*time.minute/60 + 0.5):
            worker.right(87)
            line((25, 40), (False, True), 3, worker = worker)
            worker.left(87)
        if i == time.minute:
            worker.right(87)
            line((10, 56), (False, True), 2, worker = worker)
            worker.left(87)
        if i == time.second:
            worker.right(87)
            line((5, 62), (False, True), 1, worker = worker)
            worker.left(87)
        worker.forward(6)
        worker.right(6)


def spiral_new():
    color ("red")
    for i in range (12):
        if i%2 == 0:
            for i in range (10):
                forward (5)
                right (10)
            H -= 40
        else:
            for i in range (5):
                forward (5)
                right (10)
            H -= 20
        setheading (H)
        penup ()
        goto (0,0)
        pendown ()

def spiral_old():
    for i in range (12):
        color ("red")
        if i%2 == 0:
            for i in range (10):
                forward (5)
                right (10)
            for i in range (10):
                left (10)
                backward (5)
            right(40)
        else:
            for i in range (5):
                forward (5)
                right (10)
            for i in range (5):
                left (10)
                backward(5)
            right(20)
    
if __name__ == '__main__':
    # demonstration of some complex patterns:
    # switch angles each step, decrease size in half every second step
    grow((128, 128, 10), # size of branches and hidden parameter (step count)
         (30, 0),        # angles (to be switched each step)
         0,              # when step counter reaches 0, turtle will stop
         lambda x: (x[0]/(x[2] % 2 and [2] or [1])[0],
                    x[1]/(x[2] % 2 and [2] or [1])[0],
                    x[2] - 1),
         lambda a: (a[1], a[0]))

    alex = turtle.Turtle()
    for i in range(10):
        alex.left(36)
        circle(36*2, 10, lambda turtle, i: change(turtle, i, 4, 3), worker=alex)
        circle(-36*2, 10, lambda turtle, i: change(turtle, i, 4, 3), worker=alex)
