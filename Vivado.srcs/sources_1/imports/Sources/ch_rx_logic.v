

(* dont_touch = "true" *) module ch_rx_logic(
						item_out, 
						write, 
						full, 
						valid, 
						item_in, 
						item_read
						);

    `include "constants.v"
	input full;
	
	input valid;
	
	output item_read;
	
	output write;
	
	input [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_in;
	
	output [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_out;

	assign item_out = item_in;
	
	assign write = !full & valid;
	
	assign item_read = !full & valid;
	
endmodule
