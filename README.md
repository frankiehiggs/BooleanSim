# BOOLEAN MODEL SIMULATION

The Boolean model (also known as the "random blob model") is a random geometric shape, created by placing $n$ points at random locations and then placing a ball of radius $r$ around each point.

I wrote this simulation as a visual aid for seminars.
By playing with the sliders and buttons, you can get an understanding of the interesting behaviours of the Boolean model.

The first setting is "free": you can change the number of points and radius of the points independently.

The second setting is what we call the "percolation" regime.
Each individual disc will become smaller as the number of discs increases,
keeping the relationship $n r^d = t$ for the $t$ chosen by the user.
The probability that a given point on our screen is covered by a disc depends only of $t$,
so we compare this with the percolation model on graphs / lattices
(see Geoffrey Grimmett's book for a comprehensive introduction to percolation http://www.statslab.cam.ac.uk/~grg/papers/perc/perc.html ).

An interesting experiment you can do is fix $t < 1$, turn on "Colour clusters by size", and as you increase $n$ you will notice that the clusters are usually quite small.
But if you move the slider to $t > 1$ (around 1.2 looks good), and gradually increase $n$, you will notice that a single giant cluster emerges, which spreads across the whole screen.
This is called a *phase transition*: the behaviour of the model is very different when $t < 1$ and when $t > 1$.

Finally, we can fix the relationship $n r^d = t \log n$. The discs still shrink as $n$ increases, but more slowly than in the previous setting.
This is an interesting setting: as $t$ increases for large $n$ we first see that all of the points will join together into a single cluster.
As $t$ increases further, we see that the discs cover the whole space in which we placed the points.
