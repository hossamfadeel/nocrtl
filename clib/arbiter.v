/*
 ***************************************************
 * Round-robin arbiter with variable priority vector
 * ---------------------
 * G. Dimitrakopoulos
 * Nov. 2008
 ***************************************************
 */
`timescale 1ns/1ps 
module arbiter(clk, 
               reset, 
               req, 
               grant,
               anyGrant);

  parameter N = 8;
  parameter S = 3; // ceil of log_2 of N - put manually
  parameter CHOISE = 0;  // 0 blind round-robin and 1 true round robin

  // I/O interface
  input           clk;
  input           reset;
  input  [N-1:0]  req;
  output [N-1:0]  grant;
  output          anyGrant;
  
  // internal pointers
  reg [N-1:0] priority; // one-hot priority vector
  
  
  // Outputs of combinational logic - real wires - declared as regs for use in a alway block
  // Better to change to wires and use generate statements in the future
  
  reg [N-1:0]  g[S:0]; // S levels of priority generate
  reg [N-1:0]  p[S-1:0]; // S-1 levels of priority propagate

  // internal synonym wires of true outputs anyGrant and grant 
  wire anyGnt;
  wire [N-1:0] gnt;

  assign anyGrant = anyGnt;
  assign grant = gnt;
  
  


/////////////////////////////////////////////////
// Parallel prefix arbitration phase
/////////////////////////////////////////////////
  integer i,j;

  // arbitration phase
  always@(req or priority)
    begin
      // transfer request vector to the first propagate positions
      p[0] = {~req[N-2:0], ~req[N-1]};

      // transfer priority vector to the first generate positions
      g[0] = priority;
      
      // first log_2n - 1 prefix levels
      for (i=1; i < S; i = i + 1) begin
        for (j = 0; j < N ; j = j + 1) begin
          if (j-2**(i-1) < 0) begin
            g[i][j] = g[i-1][j] | (p[i-1][j] & g[i-1][N+j-2**(i-1)]);           
            p[i][j] = p[i-1][j] & p[i-1][N+j-2**(i-1)];
          end else begin
            g[i][j] = g[i-1][j] | (p[i-1][j] & g[i-1][j-2**(i-1)]);           
            p[i][j] = p[i-1][j] & p[i-1][j-2**(i-1)];
          end            
        end
      end  
      
      // last prefix level
      for (j = 0; j < N; j = j + 1) begin
        if (j-2**(S-1) < 0) 
          g[S][j] = g[S-1][j] | (p[S-1][j] & g[S-1][N+j-2**(S-1)]);           
        else
          g[S][j] = g[S-1][j] | (p[S-1][j] & g[S-1][j-2**(S-1)]);           
      end
    end      
  
  // any grant generation at last prefix level
  assign anyGnt = ~(p[S-1][N-1] & p[S-1][N/2-1]);
  
  // output stage logic
  assign gnt  = req & g[S];  


/////////////////////////////////////////////////
// Pointer update logic
// ------------------------
// Version 1 - blind round robin CHOISE = 0
// Priority visits each input in a circural manner irrespective the granted output
// ------------------------
// Version 2 - true round robin CHOISE = 1
// Priority moves next to the granted output
// ------------------------
// Priority moves only when a grant was given, i.e., at least one active request
//////////////////////////////////////////////////

  always@(posedge clk)
    begin
      if (reset == 1'b1) begin
        priority <= 1;
      end else begin
        // update pointers only if at leas one match exists
        if (anyGnt == 1'b1) begin  
            if (CHOISE == 0) begin // blind circular round robin
                // shift left one-hot priority vector
                priority[N-1:1] <= priority[N-2:0];
                priority[0] <= priority[N-1];  
            end else begin // true round robin
                // shift left one-hot grant vector
                priority[N-1:1] <= grant[N-2:0];
                priority[0] <= grant[N-1];  
            end    
        end
      end
    end

 
endmodule
