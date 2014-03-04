"Deal Or No Deal" Integrated Circuit
=============================

A "Deal or No Deal" game simulator written in VHDL (VHSIC Hardware Description Language).

Game Play
---------

For those of you who don't know how the game is played, a contestant chooses between one of many closed briefcases, each containing a dollar value. In my application each of the 10 case will be represent by an LED. The case the contestant chose is kept closed. After the contestant chooses there case, they select another case. This newly selected case is opened and the dollar value is displayed. Then, based on the probability of a high value in the contestant's case, they are offered a dollar value from the 'banker' to sell it for. It is at this point the contestant must choose deal or no deal. If they select deal, they sell their unopened case to the banker and receive the offer amount from the banker and the game ends. Otherwise they select another case to open and see the value. They are then offered another value. This continues until there is one unopened case left. At this point the contestant must chose to take the final offer or open their case and receive that value.
