`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////

module alarm (
    input clock_100Mhz,
    output [15:0] led,
    output wire [3:0] JXADC,
    input alarm_unlocked
    );

    reg [11:0] audio_out = 0;
    reg [16:0] debounce_counter = 0;
    reg [32:0] countdown_1s = 0;
    reg btnC_debounced = 0;
    reg btnC_prev = 0;
    reg beep_active = 1;
    reg [31:0] beep_frequency = 0;
    
    //for duration of sound
    reg generate_signal = 1;
    reg [19:0] duration_counter = 200000; 

    wire clk20khz_signal, clk190hz_signal, clk50Mhz_signal;
    
    //signals for the diff sounds
    wire clk1052hz_signal;
    wire clk937hz_signal;
    wire clk787hz_signal;
    wire clk1405hz_signal;
    wire clk1320hz_signal;
    
    wire CLOCK_1HZ;
    wire [5:0] SOUND_COUNT;
    reg [4:0] note_duration = 0;

    // Instantiate the clock_gen module with named port connections
    clock_gen clk20khz (clock_100Mhz, 20000, clk20khz_signal);
    clock_gen clk190hz (clock_100Mhz, beep_frequency, clk190hz_signal);
    clock_gen clk50Mhz (clock_100Mhz, 50000000, clk50Mhz_signal);
    
    //for the diff sounds
    clock_gen clk1052hz (clock_100Mhz, 1052, clk1052hz_signal); //C
    clock_gen clk937hz (clock_100Mhz, 937, clk937hz_signal); //Bflat
    clock_gen clk787hz (clock_100Mhz, 787, clk787hz_signal); //G
    clock_gen clk1405hz (clock_100Mhz, 1405, clk1405hz_signal); //F
    clock_gen clk1320hz (clock_100Mhz, 1320, clk1320hz_signal); //E
    
    //reg for the diff audio sounds
    reg [11:0] audio0 = 0; //C
    reg [11:0] audio1 = 0; //Bflat
    reg [11:0] audio2 = 0; //G
    reg [11:0] audio3 = 0; //F
    reg [11:0] audio4 = 0; //E
    
    //for the timing of the sound
     clk_1hz_module clock_1s (clock_100Mhz,CLOCK_1HZ,SOUND_COUNT);

    //just to see if the sound_count is correct
    assign led[12] = (alarm_unlocked == 1 && ((SOUND_COUNT == 9) || (SOUND_COUNT == 11))) ? 1 : 0 ; //G
    assign led[9] = (alarm_unlocked == 1 && ((SOUND_COUNT == 5))) ? 1 : 0 ; //Bflat
    assign led[7] = ( alarm_unlocked == 1 && ((SOUND_COUNT == 1) || (SOUND_COUNT == 3) || (SOUND_COUNT == 7) || (SOUND_COUNT == 13) || (SOUND_COUNT == 19))) ? 1 : 0 ; //C
    assign led[4] = ( alarm_unlocked == 1 && ((SOUND_COUNT == 17))) ? 1 : 0 ; //E
    assign led[3] = ( alarm_unlocked == 1 && ((SOUND_COUNT == 15))) ? 1 : 0 ; //F
    

    always @ (posedge clock_100Mhz) begin
        if(alarm_unlocked) begin
    
        case(SOUND_COUNT)
            1: audio_out <= audio0; //C
            2: audio_out <= 0; // 0 
            
            3: audio_out <= audio0; //C
            4: audio_out <= 0; // 0 
            
            5: audio_out <= audio1; //Bflat
            6: audio_out <= 0; // 0 
            
            7: audio_out <= audio0; //C
            8: audio_out <= 0; // 0 
            
            9: audio_out <= 0; // 0 
            
            10: audio_out <= audio2; //G
            11: audio_out <= 0; // 0 
            
            12: audio_out <= 0; // 0 
            
            13: audio_out <= audio2; //G
            14: audio_out <= 0; // 0 
            
            15: audio_out <= audio0; //C
            16: audio_out <= 0; // 0 
           
            17: audio_out <= audio3; //F
            18: audio_out <= 0; // 0 
            
            19: audio_out <= audio4; //E
            20: audio_out <= 0; // 0 
            
            21: audio_out <= audio0; //C
            22: audio_out <= 0; // 0 
        endcase
    end
            
    end


    // Audio output control - volume of sound
    //C
     always @ (posedge clk1052hz_signal) begin 
                if (generate_signal) begin
               audio0 <= (audio0 == 0) ? 12'b010000000000 : 0;              
           end
       end
//Bflat
     always @ (posedge clk937hz_signal) begin 
           if (generate_signal) begin
          audio1 <= (audio1 == 0) ? 12'b010000000000 : 0;
      end
  end
//G
     always @ (posedge clk787hz_signal) begin 
           if (generate_signal) begin
          audio2 <= (audio2 == 0) ? 12'b010000000000 : 0;
      end
  end
//F
     always @ (posedge clk1405hz_signal) begin 
           if (generate_signal) begin
          audio3 <= (audio3 == 0) ? 12'b010000000000 : 0;
      end
  end
//E
     always @ (posedge clk1320hz_signal) begin 
           if (generate_signal) begin
          audio4 <= (audio4 == 0) ? 12'b010000000000 : 0;
      end
  end    

    
    // Instantiate the Audio_Output module
    Audio_Output audio_out_inst (
        .CLK (clk50Mhz_signal),
        .START (clk20khz_signal),
        .DATA1 (audio_out),
        .DATA2 (12'b0),
        .D1 (JXADC[1]),
        .D2 (JXADC[2]),
        .CLK_OUT (JXADC[3]),
        .nSYNC (JXADC[0])
    );

endmodule