library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;

library work;
use work.mytypes.all;

entity DealOrNoDeal is
    Port ( clk, rst : IN  STD_LOGIC;
           pushbutton_in	: in	std_logic_vector(number_of_push_buttons);
		   SevenSegs : out seven_seg_vector( number_of_seven_segs );
		   LEDs : out std_logic_vector( number_of_red_leds ));
END DealOrNoDeal;

architecture fsm of DealOrNoDeal IS
	SIGNAL present_state, 			next_state: STATE;
	SIGNAL present_main_box_value,	next_main_box_value : integer RANGE 0 to 1000 := 0;
	SIGNAL present_open_box_value,	next_open_box_value : integer RANGE 0 to 1000 := 0;
	SIGNAL present_highlit_LED,		next_highlit_LED : integer RANGE 0 to 9 := 0;
	SIGNAL present_boxes,			next_boxes : box_vector(number_of_red_leds) := (OTHERS => 0);
	SIGNAL pushbutton_edge : boolean_vector(number_of_push_buttons);
	SIGNAL blinkEnable : boolean;

	function random ( max : NATURAL) return NATURAL is
		variable rand: real;
		variable s1 : positive := 1;
		variable s2 : positive := 1;
		BEGIN

		UNIFORM(s1, s2, rand);
		return (INTEGER(TRUNC(rand*1000.0)) MOD max);
	END function random;
	
    function toSevenSeg ( num : NATURAL ) return seven_seg_vector is
		variable output: seven_seg_vector( number_of_seven_segs );
		constant sevSegKey : segArray := ("1000000", "1111001", "0100100", "0110000", "0011001",
		                                  "0010010", "0000011", "1111000", "0000000", "0011000");
		BEGIN
		for I in number_of_seven_segs LOOP
			output(I) := sevSegKey((num / (10 ** I)) MOD 10);
		END LOOP;
		return output;
	END function toSevenSeg;

	function toLogic ( num : NATURAL ) return STD_LOGIC is
		BEGIN
			IF(num = 0 ) THEN
				RETURN '0';
			END IF;
			RETURN '1';
	END function toLogic;

	function setLEDs(key : box_vector) return std_logic_vector is
		variable output:std_logic_vector( number_of_red_leds );
		BEGIN
			FOR I IN number_of_red_leds LOOP
				output(I) := toLogic (key(I));
			END LOOP;
			return output;
	END function setLEDs;

	function setBoxes return box_vector is
		variable boxValKey : box_vector ( number_of_red_leds ) := (1, 5, 10, 25, 50, 75, 100, 500, 750, 1000);
		variable result : box_vector ( number_of_red_leds );
		variable rand : NATURAL;
		BEGIN
			rand := random (10);
			FOR I IN number_of_red_leds LOOP
				while ( boxValKey( rand ) = 0 ) LOOP
					rand := (rand + 3) MOD 10;
				END LOOP;
				result(I) := boxValKey( rand );
				boxValKey(rand) := 0;
				rand := random (10);
			END LOOP;
		return result;
	END function setBoxes;

	function getOffer(key : box_vector; startsum : NATURAL) return POSITIVE is
		variable num : NATURAL := 1;
		variable sum : NATURAL := startsum;
		BEGIN
			FOR I IN number_of_red_leds LOOP
				IF(key(I) /= 0) THEN
					sum := sum + key(I);
				    num := num + 1;
				END IF;
			END LOOP;
			sum := sum / num;
			return sum;
	END function getOffer;

BEGIN

process (clk,rst)
BEGIN
	IF (rst='1') THEN
		present_state <= initiate;
		present_main_box_value <= 0;
		present_open_box_value <= 0;
		present_highlit_LED <= 0;
		present_boxes <= (OTHERS => 0);
	ELSIF (rising_edge(clk)) THEN
		present_state <= next_state;
		present_main_box_value <= next_main_box_value;
		present_open_box_value <= next_open_box_value;
		present_highlit_LED <= next_highlit_LED;
		present_boxes <= next_boxes;
END IF;
END process;

PROCESS(rst, clk, present_highlit_LED, present_boxes)
	constant max_count : natural := 48000000;
	variable count : natural RANGE 0 to max_count;
	BEGIN
        IF rst = '1' THEN
        	count := 0;
			LEDs <= (OTHERS => '1');

        ELSIF rising_edge(Clk) THEN
			IF blinkEnable = true THEN
				IF count < max_count/2 THEN
					LEDs <= (OTHERS => '0');
					LEDs(present_highlit_LED) <='1';
					count := count + 1;
				ELSIF count < max_count THEN
					LEDs <= setLEDs(present_boxes);
					count := count + 1;
				ELSE
					count := 0;
					LEDs <= (OTHERS => '0');
					LEDs(present_highlit_LED) <='1';
				END IF;
			ELSE
				count := 0;
				LEDs <= (OTHERS => '0');
			END IF;
        END IF;
END process;

PROCESS(pushbutton_edge, present_highlit_LED)
	BEGIN
		IF (pushbutton_edge(3) XOR pushbutton_edge(2)) THEN
			IF(pushbutton_edge(3)) THEN
				next_highlit_LED <= (present_highlit_LED + 1) MOD 10;
			ELSE
				next_highlit_LED <= (present_highlit_LED - 1) MOD 10;
			END IF;
		ELSE
			next_highlit_LED <= present_highlit_LED;
		END IF;
END process;

process(rst,clk)
      variable detect : detector_vector(number_of_push_buttons);
   BEGIN
      IF rst ='1' THEN
		for i in number_of_push_buttons LOOP
			detect(i) := "00";
			pushbutton_edge(i) <= false;
		END LOOP;


      ELSIF rising_edge(clk) THEN
		for i in number_of_push_buttons LOOP
			detect(i)(1) := detect (i)(0);
			detect(i)(0) := pushbutton_in(i);

			pushbutton_edge(i) <= ( detect(i) = "10");
		END LOOP;
      END IF;
END process;

PROCESS(present_state, present_main_box_value,present_open_box_value, present_boxes, present_highlit_LED, pushbutton_edge)
BEGIN
	CASE present_state is
		WHEN initiate =>
			SevenSegs <= toSevenSeg (present_main_box_value);
			next_open_box_value <= 0;
			next_main_box_value <= present_main_box_value;
			next_boxes <= setboxes;
			blinkEnable <= false;
			IF(pushbutton_edge(1)) THEN
				next_state <= start_selector;
			ELSE
				next_state <= initiate;
			END IF;

		WHEN start_selector =>
			next_open_box_value <= 0;
			next_boxes <= present_boxes;
			blinkEnable <= true;
			SevenSegs <= toSevenSeg (5555);
			IF(pushbutton_edge(1)) THEN
				next_state <= mid_selector;
				next_main_box_value <= present_boxes(present_highlit_LED);
				next_boxes(present_highlit_LED) <= 0;
			ELSE
				next_state <= start_selector;
				next_main_box_value <= 0;
			END IF;

		WHEN mid_selector =>
			next_boxes <= present_boxes;
			next_main_box_value <= present_main_box_value;
			blinkEnable <= true;
			IF(pushbutton_edge(1) AND present_boxes(present_highlit_LED) /= 0) THEN
				SevenSegs <= toSevenSeg (3344);
				next_state <= display_value;
				next_open_box_value <= present_boxes(present_highlit_LED);
				next_boxes(present_highlit_LED) <= 0;
			ELSE
				SevenSegs <= toSevenSeg (3333);
				next_state <= mid_selector;
				next_open_box_value <= 0;
			END IF;

		WHEN display_value =>
			next_main_box_value <= present_main_box_value;
			next_open_box_value <= present_open_box_value;
			SevenSegs <= toSevenSeg (present_open_box_value);
			blinkEnable <= false;
			IF(pushbutton_edge(1)) THEN
				next_state <= offer_prompt;
			ELSE
				next_state <= display_value;
			END IF;
			next_boxes <= present_boxes;

		WHEN offer_prompt =>
			blinkEnable <= false;
			next_main_box_value <= present_main_box_value;
			next_open_box_value <= 0;
			SevenSegs <= toSevenSeg (getOffer(present_boxes, present_main_box_value));
			IF(pushbutton_edge(1)) THEN
				next_state <= initiate;
			ELSIF(pushbutton_edge(0)) THEN
				next_state <= mid_selector;
			ELSE
				next_state <= offer_prompt;
			END IF;
			next_boxes <= present_boxes;
	END CASE;
END process;

END  fsm;