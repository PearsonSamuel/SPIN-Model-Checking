# SPIN-Model-Checking
This project was part of a model checking course. We use SPIN to model concurrent systems and verify properties.

The folder Transition System contains a simple implementation of a transition system and some LTL properties to be checked.

The folder Token Ring contains an implementation of a directed ring topology and various implementations of undirected ring topologies, starting with a standard example and then providing solutions that ensure absence of livelock and absence of starvation.
Token Ring is a network protocol used to synchronize access of processes to a shared resource, ensuring mutual exclusion.

The folder Missionaries and Cannibals contains an model of the well-known missionaries an cannibals river-crossing puzzle, in which there are N missionaries and N cannibals on one side of a river and they all wish to cross to the other side using a boat that can carry up to B > 1 people. The constraint that makes this problem interesting is that at no point in time can any missionaries be outnumbered by cannibals on any location (left bank, boat or right bank). Note that if there are 0 missionaries in some location then there may be more cannibals than missionaries.
We use SPIN to verify a safety property that fails when there is a solution. In this case, Spin provides an error trail that corresponds to the solution.
