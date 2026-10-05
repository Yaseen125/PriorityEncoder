//==============================================================
// Testbench for 16-to-4 Priority Encoder
//==============================================================
// Purpose:
//   This testbench applies different input combinations to the
//   priority encoder and observes its outputs:
//
//       code  -> Encoded position of highest-priority input
//       valid -> Indicates whether any input is HIGH
//       error -> Indicates whether more than one input is HIGH
//
// Priority:
//   in[15] has the highest priority.
//   in[0]  has the lowest priority.
//==============================================================


//--------------------------------------------------------------
// Simulation time unit and precision
//--------------------------------------------------------------
// 1ns = simulation time unit
// 1ps = simulation time precision
//
// Therefore:
//     #10  means 10 ns
//--------------------------------------------------------------
`timescale 1ns/1ps


//--------------------------------------------------------------
// Testbench module declaration
//--------------------------------------------------------------
// A testbench normally has NO input or output ports because
// it generates the inputs internally and observes the outputs.
//--------------------------------------------------------------
module priority_encoder_tb;


//--------------------------------------------------------------
// Input signal for the Design Under Test (DUT)
//--------------------------------------------------------------
// "in" represents the 16 input signals of the priority encoder.
//
// reg is used because the testbench will assign different
// values to "in" during simulation.
//--------------------------------------------------------------
reg [15:0] in;


//--------------------------------------------------------------
// Output signals from the Design Under Test (DUT)
//--------------------------------------------------------------
// These signals are connected to the outputs of the
// priority encoder.
//
// wire is used because these signals are driven by the DUT.
//--------------------------------------------------------------

// 4-bit encoded output
wire [3:0] code;

// Indicates that at least one input is HIGH
wire valid;

// Indicates that more than one input is HIGH
wire error;


//==============================================================
// DESIGN/DEVICE UNDER TEST (DUT)
//==============================================================
// Instantiate the actual priority encoder module.
//
// DUT = Design/Device Under Test
//
// The testbench sends values to the DUT through "in" and
// receives the results through "code", "valid", and "error".
//==============================================================

priority_encoder DUT (

    // Connect testbench signal "in"
    // to DUT input "in"
    .in(in),

    // Connect DUT output "code"
    // to testbench signal "code"
    .code(code),

    // Connect DUT output "valid"
    // to testbench signal "valid"
    .valid(valid),

    // Connect DUT output "error"
    // to testbench signal "error"
    .error(error)

);


//==============================================================
// TEST SEQUENCE
//==============================================================
// The initial block executes once when simulation starts.
//
// Each test:
//   1. Applies a value to "in"
//   2. Waits for 10 ns
//   3. Allows us to observe the resulting outputs
//==============================================================

initial begin


    //----------------------------------------------------------
    // TEST 1: No input is HIGH
    //----------------------------------------------------------
    // All 16 inputs are 0.
    //
    // Expected:
    //     code  = 0
    //     valid = 0
    //     error = 0
    //----------------------------------------------------------
    in = 16'b0000_0000_0000_0000;

    // Wait 10 ns before applying the next test
    #10;


    //----------------------------------------------------------
    // TEST 2: Only input 3 is HIGH
    //----------------------------------------------------------
    // Binary:
    //
    // 0000_0000_0000_1000
    //                    ↑
    //                  in[3]
    //
    // Expected:
    //     code  = 3
    //     valid = 1
    //     error = 0
    //
    // Only one input is HIGH, so there is no error.
    //----------------------------------------------------------
    in = 16'b0000_0000_0000_1000;

    // Wait 10 ns
    #10;


    //----------------------------------------------------------
    // TEST 3: Only input 7 is HIGH
    //----------------------------------------------------------
    // Binary:
    //
    // 0000_0000_1000_0000
    //             ↑
    //           in[7]
    //
    // Expected:
    //     code  = 7
    //     valid = 1
    //     error = 0
    //----------------------------------------------------------
    in = 16'b0000_0000_1000_0000;

    // Wait 10 ns
    #10;


    //----------------------------------------------------------
    // TEST 4: Only input 15 is HIGH
    //----------------------------------------------------------
    // Binary:
    //
    // 1000_0000_0000_0000
    // ↑
    // in[15]
    //
    // in[15] is the highest-priority input.
    //
    // Expected:
    //     code  = 15
    //     valid = 1
    //     error = 0
    //----------------------------------------------------------
    in = 16'b1000_0000_0000_0000;

    // Wait 10 ns
    #10;


    //----------------------------------------------------------
    // TEST 5: Inputs 3 and 7 are HIGH
    //----------------------------------------------------------
    // Binary:
    //
    // 0000_0000_1000_1000
    //             ↑   ↑
    //            in7 in3
    //
    // Two inputs are HIGH.
    //
    // Since in[7] has higher priority than in[3]:
    //
    // Expected:
    //     code  = 7
    //     valid = 1
    //     error = 1
    //
    // error = 1 because MORE THAN ONE input is HIGH.
    //----------------------------------------------------------
    in = 16'b0000_0000_1000_1000;

    // Wait 10 ns
    #10;


    //----------------------------------------------------------
    // TEST 6: Inputs 2, 8 and 12 are HIGH
    //----------------------------------------------------------
    // Binary:
    //
    // 0001_0001_0000_0100
    //    ↑       ↑    ↑
    //   in12    in8  in2
    //
    // Three inputs are HIGH.
    //
    // Among them, in[12] has the highest priority.
    //
    // Expected:
    //     code  = 12
    //     valid = 1
    //     error = 1
    //
    // error = 1 because THREE inputs are HIGH.
    //----------------------------------------------------------
    in = 16'b0001_0001_0000_0100;

    // Wait 10 ns
    #10;


    //----------------------------------------------------------
    // TEST 7: Inputs 10 and 15 are HIGH
    //----------------------------------------------------------
    // Binary:
    //
    // 1000_0100_0000_0000
    // ↑    ↑
    // in15 in10
    //
    // Two inputs are HIGH.
    //
    // in[15] has higher priority than in[10].
    //
    // Expected:
    //     code  = 15
    //     valid = 1
    //     error = 1
    //----------------------------------------------------------
    in = 16'b1000_0100_0000_0000;

    // Wait 10 ns
    #10;


    //----------------------------------------------------------
    // TEST 8: Only input 9 is HIGH
    //----------------------------------------------------------
    // Binary:
    //
    // 0000_0010_0000_0000
    //        ↑
    //       in[9]
    //
    // Only one input is HIGH.
    //
    // Expected:
    //     code  = 9
    //     valid = 1
    //     error = 0
    //----------------------------------------------------------
    in = 16'b0000_0010_0000_0000;

    // Wait 10 ns
    #10;


    //----------------------------------------------------------
    // END OF SIMULATION
    //----------------------------------------------------------
    // $finish terminates the simulation.
    //----------------------------------------------------------
    $finish;


// End of initial block
end


// End of testbench module
endmodule
