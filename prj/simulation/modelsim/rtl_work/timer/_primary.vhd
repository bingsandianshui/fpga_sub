library verilog;
use verilog.vl_types.all;
entity timer is
    generic(
        pulse_w         : integer := 72000;
        period          : integer := 20000000;
        cnt_2M_max      : integer := 400;
        one_turn_count_max: integer := 50000;
        one_turn_count_samp: integer := 49820;
        points          : vl_logic_vector(0 to 7) := (Hi1, Hi0, Hi1, Hi1, Hi0, Hi1, Hi0, Hi0);
        totalpoint      : integer := 720;
        address_max     : integer := 720;
        frame_head      : vl_logic_vector(0 to 15) := (Hi0, Hi1, Hi1, Hi1, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        Clk             : in     vl_logic;
        Rst_n           : in     vl_logic;
        one_turn        : in     vl_logic;
        Samp_en         : in     vl_logic;
        data_in0        : in     vl_logic_vector(15 downto 0);
        data_in1        : in     vl_logic_vector(15 downto 0);
        data_in2        : in     vl_logic_vector(15 downto 0);
        data_in3        : in     vl_logic_vector(15 downto 0);
        wrreq_fifo      : out    vl_logic;
        data_out        : out    vl_logic_vector(15 downto 0);
        start_send      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of pulse_w : constant is 1;
    attribute mti_svvh_generic_type of period : constant is 1;
    attribute mti_svvh_generic_type of cnt_2M_max : constant is 1;
    attribute mti_svvh_generic_type of one_turn_count_max : constant is 1;
    attribute mti_svvh_generic_type of one_turn_count_samp : constant is 1;
    attribute mti_svvh_generic_type of points : constant is 1;
    attribute mti_svvh_generic_type of totalpoint : constant is 1;
    attribute mti_svvh_generic_type of address_max : constant is 1;
    attribute mti_svvh_generic_type of frame_head : constant is 1;
end timer;
