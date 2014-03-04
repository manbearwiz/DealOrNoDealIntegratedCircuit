Library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;

PACKAGE mytypes IS 
			subtype number_of_seven_segs is integer range 0 to 3;
			subtype number_of_red_leds is integer range 9 downto 0;
			subtype number_of_push_buttons is integer range 3 downto 0;
			
			type segArray is array (0 to 9) of bit_vector(6 downto 0);
			TYPE state IS (initiate, start_selector, mid_selector, display_value, offer_prompt);
			type box_vector is array (natural range <>) of integer range 0 to 1000;
			type seven_seg_vector is array (natural range <>) of bit_vector(6 downto 0);
			type detector_vector is array (natural range <>) of std_logic_vector(1 downto 0);
			type boolean_vector is array (natural range <>) of boolean;
			type LED_vector is array (natural range <>) of std_logic_vector(number_of_red_leds);
END PACKAGE mytypes;