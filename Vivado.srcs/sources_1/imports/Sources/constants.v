// ----- Constants File-------
// `ifndef __CONSTANTS__
//     `define __CONSTANTS__

    `define DIRECTIONS	 	 5 
    `define BITS_DIR	 	 3
     
    `define NORTH		 0
    `define EAST		 1
    `define SOUTH		 2
    `define WEST		 3
    `define LOCAL		 4
        
    
    `define X_DIM		 3
    `define Y_DIM		 3
    `define NUM_NODES     	 9
    
    `define ADDR_SZ		 4                // node address size (bits) 
    `define X_BITS		 2 			      // 2^X_BITS is the X_DIM 
    `define Y_BITS		 2 			      // 2^Y_BITS is the Y_DIM
    `define RT_BITS		 4
    `define NUM_DESTS		 9
    
    `define TBL_DEPTH	 	 9 	  //The routing table size
    `define FIFO_LOG2		 5
    
    `define HDR_SZ	 	 4
    `define PL_SZ	 	 32
    
    `define ROUTER_ID	 	 4

// `endif
