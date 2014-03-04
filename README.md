"Deal Or No Deal" Integrated Circuit
=============================

State machine written in [VHDL](http://en.wikipedia.org/wiki/VHDL) to simulate the game show [Deal Or No Deal](http://en.wikipedia.org/wiki/Deal_or_No_Deal) on an [Altera DE1 board](http://www.altera.com/education/univ/materials/boards/de1/unv-de1-board.html).


Interface
---------

###Ports

This utilizes the following I/O ports on the DE1 board:

Number | Descripiton | Use
-------|-------------|----
10|LED|Represents the briefcases
4 |Seven-Segment display|Display the offer and case values
4 | Push button switch|Used to make selections during the game

###Button Actions

Button | Action
-------|------
3 | move case select cursor right
2 | move case select cursor left
1 | select, confirm, enter, "Deal!"
0 | "No Deal!"




Game Play
---------

Taken From [wikipedia](http://en.wikipedia.org/wiki/Deal_or_No_Deal#Gameplay):

>The game revolves around the opening of a set of numbered briefcases, each of which contains a different cash amount. The contents (i.e., the values) of all of the cases are known at the start of the game, but the specific location of any prize is unknown. The contestant claims a case to begin the game. The case's value is not revealed until the conclusion of the game.

>The contestant then begins choosing cases that are to be removed from play. The amount inside each chosen case is immediately revealed; by process of elimination, the amount revealed cannot be inside the case the contestant initially claimed. Throughout the game, after a predetermined number of cases have been opened, the banker offers the contestant an amount of money to quit the game, the offer based roughly on the amounts remaining in play, the bank tries to 'buy' the contestant's case for a lower price than what's inside the case. The player then answers the titular question, choosing:

> - "Deal", accepting the offer presented and ending the game, or
- "No Deal", rejecting the offer and continuing the game.

>This process of removing cases and receiving offers continues, until either the player accepts an offer to 'deal', or all offers have been rejected and the values of all unselected cases are revealed. Should a player end the game by taking a deal, a pseudo-game is continued from that point to see how much the player could have won by remaining in the game. Depending on subsequent choices and offers, it is determined whether or not the contestant made a "good deal", i.e. won more than if the game were allowed to continue.
