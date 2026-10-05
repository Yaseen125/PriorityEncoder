//==============================================================
// 16-to-4 Priority Encoder with Error Detection
//==============================================================
// Purpose:
//   1. Find the highest-priority HIGH input among 16 inputs.
//   2. Encode its position into a 4-bit output "code".
//   3. Set "valid = 1" when at least one input is HIGH.
//   4. Set "error = 1" when more than one input is HIGH.
//
// Priority:
//   in[15] has the highest priority.
//   in[0]  has the lowest priority.
//
// Example:
//   in[15] = 1 and in[5] = 1
//   => code  = 15
//   => valid = 1
//   => error = 1
//==============================================================


// Module declaration
module priority_encoder (

    // 16 input signals: in[15] ... in[0]
    input [15:0] in,

    // 4-bit encoded output
    // Can represent values from 0 to 15
    output reg [3:0] code,

    // Indicates that at least one input is HIGH
    output reg valid,

    // Indicates that more than one input is HIGH
    output reg error
);


//==============================================================
// Combinational Logic
//==============================================================
// always @(*) means:
//   This block is executed whenever ANY input used inside
//   the block changes.
//
// There is no clock here.
// Therefore, this is combinational logic.
//==============================================================
always @(*) begin


    //----------------------------------------------------------
    // Default values
    //----------------------------------------------------------

    // Default encoded output = 0
    code = 4'b0000;

    // Default: assume no valid input
    valid = 1'b0;


    //----------------------------------------------------------
    // PRIORITY ENCODER
    //----------------------------------------------------------
    // casez allows '?' (don't-care bits) in the case patterns.
    //
    // Priority is:
    //
    //     in[15] > in[14] > ... > in[1] > in[0]
    //
    // The first matching case is selected.
    //----------------------------------------------------------

    casez (in)


        //------------------------------------------------------
        // If in[15] is HIGH
        //
        // Pattern:
        // 1???_????_????_????
        //
        // The first bit is 1.
        // All other bits are don't-care.
        //
        // Therefore, regardless of the other inputs,
        // in[15] gets the highest priority.
        //------------------------------------------------------
        16'b1???_????_????_????: begin

            // Binary representation of decimal 15
            code = 4'd15;

            // At least one input is HIGH
            valid = 1'b1;
        end
        //------------------------------------------------------
        // If in[15] = 0 and in[14] = 1
        //
        // in[14] is now the highest-priority HIGH input.
        //------------------------------------------------------
        16'b01??_????_????_????: begin
            code = 4'd14;
            valid = 1'b1;
        end
        //------------------------------------------------------
        // If in[15:14] = 00 and in[13] = 1
        //------------------------------------------------------
        16'b001?_????_????_????: begin
            code = 4'd13;
            valid = 1'b1;
        end
        //------------------------------------------------------
        // If in[15:13] = 000 and in[12] = 1
        //------------------------------------------------------
        16'b0001_????_????_????: begin
            code = 4'd12;
            valid = 1'b1;
        end
        //------------------------------------------------------
        // If in[15:12] = 0000 and in[11] = 1
        //------------------------------------------------------
        16'b0000_1???_????_????: begin
            code = 4'd11;
            valid = 1'b1;
        end
        //------------------------------------------------------
        // If in[15:11] = 00000 and in[10] = 1
        //------------------------------------------------------
        16'b0000_01??_????_????: begin
            code = 4'd10;
            valid = 1'b1;
        end
        //------------------------------------------------------
        // If in[15:10] = 000000 and in[9] = 1
        //------------------------------------------------------
        16'b0000_001?_????_????: begin
            code = 4'd9;
            valid = 1'b1;
        end
        //------------------------------------------------------
        // If in[15:9] = 0000000 and in[8] = 1
        //------------------------------------------------------
        16'b0000_0001_????_????: begin
            code = 4'd8;
            valid = 1'b1;
        end
        //------------------------------------------------------
        // If in[15:8] = 00000000 and in[7] = 1
        //------------------------------------------------------
        16'b0000_0000_1???_????: begin
            code = 4'd7;
            valid = 1'b1;
        end
        //------------------------------------------------------
        // If in[15:7] = 000000000 and in[6] = 1
        //------------------------------------------------------
        16'b0000_0000_01??_????: begin
            code = 4'd6;
            valid = 1'b1;
        end
        //------------------------------------------------------
        // If in[15:6] = 0000000000 and in[5] = 1
        //------------------------------------------------------
        16'b0000_0000_001?_????: begin
            code = 4'd5;
            valid = 1'b1;
        end
        //------------------------------------------------------
        // If in[15:5] = 00000000000 and in[4] = 1
        //------------------------------------------------------
        16'b0000_0000_0001_????: begin
            code = 4'd4;
            valid = 1'b1;
        end
        //------------------------------------------------------
        // If in[15:4] = 000000000000 and in[3] = 1
        //------------------------------------------------------
        16'b0000_0000_0000_1???: begin
            code = 4'd3;
            valid = 1'b1;
        end
        //------------------------------------------------------
        // If in[15:3] = 0000000000000 and in[2] = 1
        //------------------------------------------------------
        16'b0000_0000_0000_01??: begin
            code = 4'd2;
            valid = 1'b1;
        end
        //------------------------------------------------------
        // If in[15:2] = 00000000000000 and in[1] = 1
        //------------------------------------------------------
        16'b0000_0000_0000_001?: begin
            code = 4'd1;
            valid = 1'b1;
        end
        //------------------------------------------------------
        // If all higher inputs are 0 and in[0] = 1
        //------------------------------------------------------
        16'b0000_0000_0000_0001: begin
            code = 4'd0;
            valid = 1'b1;
        end
        //------------------------------------------------------
        // DEFAULT CASE
        //------------------------------------------------------
        // This occurs when all 16 inputs are 0.
        //
        // No input is HIGH, therefore:
        //     code  = 0
        //     valid = 0
        //------------------------------------------------------
        default: begin
            code = 4'd0;
            valid = 1'b0;
        end
    endcase
    //==========================================================
    // ERROR DETECTION
    //==========================================================
    // Purpose:
    //   Detect whether MORE THAN ONE input is HIGH.
    //
    // If exactly zero inputs are HIGH:
    //     error = 0
    //
    // If exactly one input is HIGH:
    //     error = 0
    //
    // If two or more inputs are HIGH:
    //     error = 1
    //
    // The case statement below explicitly lists all 16
    // possible cases where exactly ONE input is HIGH.
    //==========================================================
    casez (in)
        //------------------------------------------------------
        // Case 1: No input is HIGH
        //
        // This is NOT an error.
        //------------------------------------------------------
        16'b0000_0000_0000_0000:
            error = 1'b0;
        //------------------------------------------------------
        // The following 16 patterns represent the cases where
        // EXACTLY ONE input is HIGH.
        //
        // Therefore, error = 0.
        //------------------------------------------------------

        // Only in[0] = 1
        16'b0000_0000_0000_0001,

        // Only in[1] = 1
        16'b0000_0000_0000_0010,

        // Only in[2] = 1
        16'b0000_0000_0000_0100,

        // Only in[3] = 1
        16'b0000_0000_0000_1000,

        // Only in[4] = 1
        16'b0000_0000_0001_0000,

        // Only in[5] = 1
        16'b0000_0000_0010_0000,

        // Only in[6] = 1
        16'b0000_0000_0100_0000,

        // Only in[7] = 1
        16'b0000_0000_1000_0000,

        // Only in[8] = 1
        16'b0000_0001_0000_0000,

        // Only in[9] = 1
        16'b0000_0010_0000_0000,

        // Only in[10] = 1
        16'b0000_0100_0000_0000,

        // Only in[11] = 1
        16'b0000_1000_0000_0000,

        // Only in[12] = 1
        16'b0001_0000_0000_0000,

        // Only in[13] = 1
        16'b0010_0000_0000_0000,

        // Only in[14] = 1
        16'b0100_0000_0000_0000,

        // Only in[15] = 1
        16'b1000_0000_0000_0000:

            // Exactly one input is HIGH
            // Therefore, there is NO error.
            error = 1'b0;

        //------------------------------------------------------
        // DEFAULT
        //------------------------------------------------------
        // If the input does not match any of the above cases,
        // then TWO OR MORE inputs must be HIGH.
        //
        // Therefore:
        //     error = 1
        //------------------------------------------------------
        default:
            error = 1'b1;
    endcase

// End of always block
end

// End of module
endmodule
