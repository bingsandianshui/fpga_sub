library verilog;
use verilog.vl_types.all;
entity pll_200 is
    port(
        inclk0          : in     vl_logic;
        c0              : out    vl_logic
    );
end pll_200;
