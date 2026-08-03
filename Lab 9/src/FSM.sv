module FSM (
    input logic clk, rst,
    input logic left, right,
    output logic LA, LB, LC,
    output logic RA, RB, RC
    );

    typedef enum logic [3:0]{
        RESET = 4'b0000,
        L1    = 4'b0001,
        L2    = 4'b0010,
        L3    = 4'b0011,
        R1    = 4'b0100,
        R2    = 4'b0101,
        R3    = 4'b0110,
        LR1   = 4'b0111,
        LR2   = 4'b1000,
        LR3   = 4'b1001
    } states;
    states ns,ps;

    always_ff @(posedge clk or posedge rst) begin
        if (rst == 1) begin
            ps <= RESET;
        end
        else begin
            ps <= ns;
        end
    end

    always_comb begin
        case (ps)
            RESET: begin
                if (left == 1 && right == 0) begin
                    ns = L1;
                end
                else if (left == 1 && right == 1) begin
                    ns = LR1;
                end
                else if (left == 0 && right == 1) begin
                    ns = R1;
                end
                else if (left == 0 && right == 0) begin
                    ns = RESET;
                end
            end
        
            L1:  ns = L2;
            L2:  ns = L3;
            L3:  ns = RESET;

            LR1: ns = LR2;
            LR2: ns = LR3;
            LR3: ns = RESET;

            R1:  ns = R2;
            R2:  ns = R3;
            R3:  ns = RESET;
            default: ns = RESET;
        endcase
    end

    always_comb begin
        LA = 0;
        LB = 0;
        LC = 0;
        RA = 0;
        RB = 0;
        RC = 0;
        case (ps)
            L1: begin
                LA = 1;
            end
        
            L2: begin
                LA = 1;
                LB = 1;
            end

            L3: begin
                LA = 1;
                LB = 1;
                LC = 1;
            end
        
            LR1: begin
                LA = 1;
                RA = 1;
            end
            LR2: begin
                LA = 1;
                LB = 1;
                RA = 1;
                RB = 1;
            end
            LR3: begin
                LA = 1;
                LB = 1;
                LC = 1;
                RA = 1;
                RB = 1;
                RC = 1;
            end
            R1: begin
                RA = 1;
            end
            
            R2: begin
                RA = 1;
                RB = 1;
            end

            R3: begin
                RA = 1;
                RB = 1;
                RC = 1;
            end    
            default: begin
                LA = 0;
                LB = 0;
                LC = 0;
                RA = 0;
                RB = 0;
                RC = 0;
            end
        endcase
    end
endmodule