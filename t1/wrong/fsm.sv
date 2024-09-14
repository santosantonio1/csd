`define RESET   0
`define START   1
`define STOP    2
`define SPLIT   3

module fsm (
    input  logic clk,
    input  logic rst,
    
    input  logic start_i,
    input  logic stop_i,
    input  logic split_i,

    output logic en_o,
    output logic update_o
);

    logic[1:0]  state, next_state;
    logic       start_b, stop_b, split_b;
    
    always_ff @(posedge clk or posedge rst) begin
    
        if(rst) begin

            state <= `RESET;

        end 
        else begin

            state <= next_state;

        end
    end    

    button START_B (
        .clk    (clk),
        .rst    (rst),
        .b_i    (start_i),
        .en_o   (start_b)
    ); 


    button STOP_B (
        .clk    (clk),
        .rst    (rst),
        .b_i    (stop_i),
        .en_o   (stop_b)
    ); 


    button SPLIT_B (
        .clk    (clk),
        .rst    (rst),
        .b_i    (split_i),
        .en_o   (split_b)
    ); 

    always_comb begin
        unique case (state)
                        
            `RESET:      if(start_b)      next_state <= `START;
                         else             next_state <= `RESET;

            `START:      if(split_b)      next_state <= `SPLIT;
                         else if(stop_b)  next_state <= `STOP;
                         else             next_state <= `START;

            `SPLIT:      if(split_b)      next_state <= `START;
                         else             next_state <= `SPLIT;

            `STOP:       if(start_b)      next_state <= `START;
                         else             next_state <= `STOP;
        
        endcase
    end

   // assign en_o     = (state == `START || state == `SPLIT);
    assign en_o     = (state == `START);
    assign update_o = (state != `SPLIT);

endmodule 
