# Introduction to Efabless Caravel
Caravel is a template SoC for Efabless Open MPW and chipIgnite shuttles based on the Sky130 node from SkyWater Technologies.
* [Caravel User Project](https://caravel-user-project.readthedocs.io/en/latest/#caravel-user-project)
* [Efabless Caravel “harness” SoC](https://caravel-harness.readthedocs.io/en/latest/#efabless-caravel-harness-soc)

The current SoC architecture is given below.

<img src="https://user-images.githubusercontent.com/11850122/214560743-cbad9de0-db4c-4ab1-9a0a-cc52d51191dd.jpg" width=120%>

## Caravel Lab Purpose
* Integrate a custom RTL design to Caravel SoC
* Go through overall Caravel flow and ready to [MPW submission](https://efabless.com/open_shuttle_program)

## Caravel Lab Prerequisites
* Ubuntu 20.04+
* Installed Docker packages
* Caravel user project sources with [tag mpw-8c](https://github.com/efabless/caravel_user_project/tree/mpw-8c)

## 1. Custom RTL design
A GCD RTL design example was verified under Icarus Verilog version 12.0. The below is its timing diagram.

<img src="https://user-images.githubusercontent.com/11850122/214568278-017816f2-8450-483e-878f-8cbccd79d248.png" width=100%>
