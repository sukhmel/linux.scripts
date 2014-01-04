#! /usr/bin/python

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
        
if __name__ == '__main__':
    w = turtle.Screen()
