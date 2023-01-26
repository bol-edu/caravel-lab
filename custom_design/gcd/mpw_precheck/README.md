# Caravel User Project

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)

| :exclamation: Important Note            |
|-----------------------------------------|

## 1. Custom RTL design
A GCD RTL design example was verified under Icarus Verilog version 12.0. The the following timing diagram shows GCD(10312050, 29460792)=138.

<img src="https://user-images.githubusercontent.com/11850122/214568278-017816f2-8450-483e-878f-8cbccd79d248.png" width=100%>

    $ iverilog seq_gcd.v testbench.v  && vvp a.out
    VCD info: dumpfile dump.vcd opened for output.
                 Result is correct:  GCD(  10312050,  29460792) -->: Expected =        138; Actual Result =        138
                 Result is correct:  GCD(1993627629,1177417612) -->: Expected =          7; Actual Result =          7
                 Result is correct:  GCD(2097015289,3812041926) -->: Expected =          1; Actual Result =          1
                 Result is correct:  GCD(1924134885,3151131255) -->: Expected =        135; Actual Result =        135
                 Result is correct:  GCD( 992211318, 512609597) -->: Expected =          1; Actual Result =          1
    testbench.v:100: $stop called at 609 (1s)
    ** VVP Stop(0) **
    ** Flushing output streams.
    ** Current simulation time is 609 ticks.
    > finish
    ** Continue **
    
The GCD design and testbench sources were tested under individual Openlane flow with PDK sky130_fd_sc_hd and clock period 80 ns.

## 2. Caravel Flow
* The GCD design was wrapped with logic analyzer input/output in user_proj_example.v which can be triggered by la_test1.c and monitored by la_test1_tb.v.
* We change default "RUN_CVC" : 1 to 0 in user project example's config.json to skip not working Openlane CVC step in Caravel flow.