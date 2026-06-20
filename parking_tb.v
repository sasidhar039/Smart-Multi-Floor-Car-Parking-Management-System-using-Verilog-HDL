module parking_tb;
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, parking_tb);
end

    reg clk;
    reg rst;

    reg entry_req;
    reg exit_req;

    reg [7:0] exit_slot;

    wire full;

    wire [1:0] assigned_floor;
    wire [5:0] assigned_slot;

    wire [7:0] available_slots;
    wire [6:0] occupancy_percent;

  
    // DUT
    

    parking_system DUT(
        .clk(clk),
        .rst(rst),
        .entry_req(entry_req),
        .exit_req(exit_req),
        .exit_slot(exit_slot),
        .full(full),
        .assigned_floor(assigned_floor),
        .assigned_slot(assigned_slot),
        .available_slots(available_slots),
        .occupancy_percent(occupancy_percent)
    );

    
    // CLOCK
   

    always #5 clk = ~clk;

   //TEST

    initial
    begin

        clk = 0;
        rst = 1;

        entry_req = 0;
        exit_req = 0;
        exit_slot = 0;

     //RESET
        #20;
        rst = 0;

        $display("================================");
        $display("PARKING SYSTEM TEST STARTED");
        $display("================================");

        
        // CAR 1
        

        #10;
        entry_req = 1;

        #10;
        entry_req = 0;

        #30;

        $display("CAR1 -> Floor=%d Slot=%d Available=%d",
                 assigned_floor,
                 assigned_slot,
                 available_slots);

       
        // CAR 2
        

        #10;
        entry_req = 1;

        #10;
        entry_req = 0;

        #30;

        $display("CAR2 -> Floor=%d Slot=%d Available=%d",
                 assigned_floor,
                 assigned_slot,
                 available_slots);

        
        // CAR 3
        

        #10;
        entry_req = 1;

        #10;
        entry_req = 0;

        #30;

        $display("CAR3 -> Floor=%d Slot=%d Available=%d",
                 assigned_floor,
                 assigned_slot,
                 available_slots);

        
        // EXIT SLOT 1
        -

        #20;

        exit_slot = 1;
        exit_req = 1;

        #10;

        exit_req = 0;

        #30;

        $display("EXIT SLOT 1");
        $display("Available=%d",available_slots);

        
        // NEW CAR
      

        #20;

        entry_req = 1;

        #10;

        entry_req = 0;

        #30;

        $display("NEW CAR");
        $display("Floor=%d Slot=%d Available=%d",
                 assigned_floor,
                 assigned_slot,
                 available_slots);

        
        // OCCUPANCY
        

        #20;

        $display("Occupancy=%d%%",
                 occupancy_percent);

       
        // END
        

        #100;

        $display("================================");
        $display("SIMULATION COMPLETED");
        $display("================================");

        $finish;

    end

endmodule
