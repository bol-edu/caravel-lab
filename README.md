# Introduction to Efabless Caravel
The Efabless Caravel chip is a ready-to-use test harness for creating designs with the Google/Skywater 130nm Open PDK. The Caravel harness comprises of base functions supporting IO, power and configuration as well as drop-in modules for a management SoC core. The current SoC architecture is given below.

<img src="https://user-images.githubusercontent.com/11850122/214560743-cbad9de0-db4c-4ab1-9a0a-cc52d51191dd.jpg" width=120%>

## Caravel Lab Purpose
* Integrate a custom RTL design to Caravel SoC
* Go through overall Caravel flow and ready to [MPW submission](https://efabless.com/open_shuttle_program)

## Caravel Lab Prerequisites
* Ubuntu 20.04+
* Installed Docker packages
* Icarus Verilog [version 12.0](https://bleyer.org/icarus/)
* Caravel user project sources with [tag mpw-8c](https://github.com/efabless/caravel_user_project/tree/mpw-8c)

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
    
The GCD design and testbench sources located in [custom_design/gcd/source](https://github.com/bol-edu/caravel-lab/tree/main/custom_design/gcd/source)). GCD's Openlane configuration file [config.json](https://github.com/bol-edu/caravel-lab/blob/main/custom_design/gcd/openlane_config/config.json) was tested under individual [Openlane flow](https://github.com/bol-edu/openlane-lab) with PDK sky130_fd_sc_hd and clock period 80 ns. In Caravel lab, we integrate GCD design into [user_proj_example.v](https://github.com/bol-edu/caravel-lab/blob/main/custom_design/gcd/user_proj_example/user_proj_example.v) with SoC wrapper and write an user project example's Openlane configuration file [config.json](https://github.com/bol-edu/caravel-lab/blob/main/custom_design/gcd/user_proj_example/config.json) used in Caravel flow.

## 2. Caravel Flow
The below instructions show Caravel flow setup and execution with GCD RTL design example. If a 'volare exe not found' is happened, reference the offical [troubleshooting](https://github.com/efabless/volare#troubleshooting).

    Setup caravel_user_project
    $ git clone -b mpw-8c https://github.com/efabless/caravel_user_project
    $ cd caravel_user_project
    $ mkdir dependencies
    $ export OPENLANE_ROOT=$(pwd)/dependencies/openlane_src
    $ export PDK_ROOT=$(pwd)/dependencies/pdks
    $ export PDK=sky130A
    $ make setup
    
    Run RTL simulation
    $ make simenv
    $ SIM=RTL
    $ make verify-la_test1-rtl
    
    Run Openlane to generate RTL netlist
    $ cd openlane
    $ make user_proj_example
    $ make user_project_wrapper
    
    Run gate-level simulation (it will take hours)
    $ SIM=GL    
    $ make verify-la_test1-rtl
    
    Run extract parasitics
    $ make extract-parasitics
    $ make create-spef-mapping
    $ make caravel-sta
    
    Run MPW precheck
    $ make precheck
    $ make run-precheck
    
Log files
* [setup-caravel_user_project.log]{https://github.com/bol-edu/caravel-lab/blob/main/logs/setup-caravel_user_project.log}
* [verify-la_test1-gl](https://github.com/bol-edu/caravel-lab/blob/main/logs/verify-la_test1-gl.log)
* [run-precheck.log](https://github.com/bol-edu/caravel-lab/blob/main/logs/run-precheck.log)

## Documents
* [Caravel User Project](https://caravel-user-project.readthedocs.io/en/latest/#caravel-user-project)
* [Efabless Caravel “harness” SoC](https://caravel-harness.readthedocs.io/en/latest/#efabless-caravel-harness-soc)
