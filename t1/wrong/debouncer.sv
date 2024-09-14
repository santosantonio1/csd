//---------------------------------
//      DEBOUNCER 1 ms
//---------------------------------
module debouncer ( 
    input  logic clk, 
    input  logic rst, 
    input  logic noisy,
    output logic clean 
);

    logic[19:0] count;
    logic       new_input;

    always_ff @(posedge clk)
    begin
        if (rst) begin 

            new_input <= noisy; 
            clean     <= noisy; 
            count     <= 20'd0;

        end
        else // clock rising edge
        begin 
            if (noisy != new_input) begin

                new_input <= noisy; 
                count <= 0;
                
            end
            else if (count == 20'd1_000_000) // 10 ms
                clean <= new_input;
            else 
                count <= count + 20'd1;
        end
    end

endmodule
