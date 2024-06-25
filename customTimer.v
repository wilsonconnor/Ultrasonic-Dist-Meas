module customTimer #(parameter CLKSPDMHZ = 100)(
    input clk,
    input enable,
    input reset,
    input [31:0] microsLen,
    output reg done
    );
    
    reg[31:0] count = 0;
    
    always@(posedge clk)
    begin
        if(reset)
        begin
            done <= 0;
            count <= 0;
        end
        else
        begin
            if(count == microsLen)
            begin
                done <= 1;
                count <= 0;
            end
            else if(enable == 0)
            begin
                count <= 0;
                done <= 0;
            end
            else
            begin
                if(enable)
                    count <= count + 1;
                done <= 0;
            end
        end
    end
endmodule
