// This script shows NMDA oscillations when
// Na, Kt and Ks channels are blocked 

// Part of the resulting trace 
// (after the system has reached
// steady state) is shown in 
// Fig 8b. 

float PI = 3.141592654

int	i
float dt = 1e-4
float sim_time = 20
setclock 0 {dt}
setclock 1 1e-4
setmethod 11
// setmethod 0

float NMDA=0.65
float AMPA=0.0

include library
include finish

make_cell cell.p neuron

include xout_fig8

create spikegen /neuron/soma/spike
setfield /neuron/soma/spike thresh -0.035 abs_refract 0.010 output_amp 1

create spikehistory spike.history
setfield spike.history ident_toggle 0 \ // index specification
                                  filename "spikes.dat" \
                                  initialize 1 leave_open 1 flush 1

addmsg /neuron/soma/spike spike.history SPIKESAVE

reset

str comp
foreach comp ({el /neuron/##[OBJECT=compartment]})
    setfield {comp} Em -0.070
    setfield {comp} initVm -0.070
    setfield {comp}/fshNa Gbar 0
    setfield {comp}/fshNa-is Gbar 0
    setfield {comp}/fshNa-dend Gbar 0
    setfield {comp}/Kt Gbar 0
    setfield {comp}/Ks Gbar 0
end


// setfield neuron chanmode 0
// if hsolve is used
 call /neuron SETUP
 reset


step 10 -t









