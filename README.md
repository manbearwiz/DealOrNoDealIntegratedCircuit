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
3 | move cursor right
2 | move cursor left
1 | select, confirm, enter, "Deal!"
0 | "No Deal!"




Game Play
---------

For those of you who don't know how the game is played, a contestant chooses between one of many closed briefcases, each containing a dollar value. In my application each of the 10 case will be represent by an LED. The case the contestant chose is kept closed. After the contestant chooses there case, they select another case. This newly selected case is opened and the dollar value is displayed. Then, based on the probability of a high value in the contestant's case, they are offered a dollar value from the 'banker' to sell it for. It is at this point the contestant must choose deal or no deal. If they select deal, they sell their unopened case to the banker and receive the offer amount from the banker and the game ends. Otherwise they select another case to open and see the value. They are then offered another value. This continues until there is one unopened case left. At this point the contestant must chose to take the final offer or open their case and receive that value.
