`define S0      0
`define S01     1
`define S010    2
`define DONE    3

module button (
    input  logic clk,
    input  logic rst,

    input  logic b_i,

    output logic en_o
);

    logic[1:0] state, next_state;

    always_ff @(posedge clk or posedge rst) begin
     
        if(rst) begin
    
            state <= `S0;

        end
        else begin
    
            state <= next_state;
    
        end

    end

    always_comb begin
        unique case (state)
        
            `S0:    if(b_i) next_state <= `S01;
                    else    next_state <= `S0;

            `S01:   if(!b_i)    next_state <= `S010;
                    else        next_state <= `S01;

            `S010:  next_state <= `DONE;

            `DONE:  next_state <= `S0;
        
        endcase
    end

    assign en_o = (state == `DONE);

endmodule
