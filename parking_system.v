module parking_system(

    input clk,
    input rst,

    input entry_req,
    input exit_req,

    input [7:0] exit_slot,

    output reg full,

    output reg [1:0] assigned_floor,
    output reg [5:0] assigned_slot,

    output reg [7:0] available_slots,
    output reg [6:0] occupancy_percent

);

    // FSM STATES
    
    parameter IDLE          = 3'b000;
    parameter CHECK_SPACE   = 3'b001;
    parameter ALLOCATE_SLOT = 3'b010;
    parameter RELEASE_SLOT  = 3'b011;
    parameter UPDATE_STATUS = 3'b100;

    reg [2:0] state;

    
    // SLOT MEMORY

    reg slot_mem [0:199];

    integer i;
    integer free_slot;
    integer occupied_slots;

   
    // RESET + FSM
   

    always @(posedge clk or posedge rst)
    begin

        if(rst)
        begin

            state <= IDLE;

            full <= 0;

            assigned_floor <= 0;
            assigned_slot  <= 0;

            available_slots <= 200;
            occupancy_percent <= 0;

            free_slot = -1;
            occupied_slots = 0;

            for(i=0;i<200;i=i+1)
                slot_mem[i] <= 0;

        end

        else
        begin

            case(state)

            
            // IDLE
        

            IDLE:
            begin

                if(entry_req)
                    state <= CHECK_SPACE;

                else if(exit_req)
                    state <= RELEASE_SLOT;

            end

            
            // CHECK SPACE
           

            CHECK_SPACE:
            begin

                free_slot = -1;

                for(i=0;i<200;i=i+1)
                begin
                    if(slot_mem[i]==0 && free_slot==-1)
                        free_slot = i;
                end

                if(free_slot==-1)
                begin
                    full <= 1;
                    state <= UPDATE_STATUS;
                end
                else
                begin
                    full <= 0;
                    state <= ALLOCATE_SLOT;
                end

            end

            
            // ALLOCATE SLOT
           

            ALLOCATE_SLOT:
            begin

                slot_mem[free_slot] <= 1;

                if(free_slot < 50)
                begin
                    assigned_floor <= 0;
                    assigned_slot  <= free_slot;
                end

                else if(free_slot < 100)
                begin
                    assigned_floor <= 1;
                    assigned_slot  <= free_slot - 50;
                end

                else if(free_slot < 150)
                begin
                    assigned_floor <= 2;
                    assigned_slot  <= free_slot - 100;
                end

                else
                begin
                    assigned_floor <= 3;
                    assigned_slot  <= free_slot - 150;
                end

                state <= UPDATE_STATUS;

            end

          
            // RELEASE SLOT
           

            RELEASE_SLOT:
            begin

                if(exit_slot < 200)
                begin

                    if(slot_mem[exit_slot]==1)
                        slot_mem[exit_slot] <= 0;

                end

                state <= UPDATE_STATUS;

            end

            
            // UPDATE STATUS
            

            UPDATE_STATUS:
            begin

                occupied_slots = 0;

                for(i=0;i<200;i=i+1)
                begin
                    if(slot_mem[i])
                        occupied_slots = occupied_slots + 1;
                end

                available_slots <= 200 - occupied_slots;

                occupancy_percent <=
                    (occupied_slots * 100) / 200;

                if(occupied_slots == 200)
                    full <= 1;
                else
                    full <= 0;

                state <= IDLE;

            end

            default:
                state <= IDLE;

            endcase

        end

    end

endmodule
