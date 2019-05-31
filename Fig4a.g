// This script plots a spike train under simulated Cd2+ application 
// (here assumed to block all Ca2+ currents, though
// it may be more realistic to assume only partial blockage of LVA calcium)

// The output of the script is similar to Fig 4a
// but not identical - the reason for this is unclear. 

float PI = 3.141592654

int	i
float dt = 1e-5
float sim_time = 1.02
setclock 0 {dt}
setclock 1 1e-4
setmethod 11
// setmethod 0

float NMDA=0
float AMPA=0.0

include library
include finish

make_cell cell.p neuron

include xout_fig4a

create spikegen /neuron/soma/spike
setfield /neuron/soma/spike thresh -0.035 abs_refract 0.010 output_amp 1

create spikehistory spike.history
setfield spike.history ident_toggle 0 \ // index specification
                                  filename "spikes.dat" \
                                  initialize 1 leave_open 1 flush 1

addmsg /neuron/soma/spike spike.history SPIKESAVE

reset

// setfield neuron chanmode 0
// if hsolve is used
 call /neuron SETUP
 reset

str comp
float calvamult=0.5

foreach comp ({el /neuron/##[OBJECT=compartment]})
    setfield {comp}/Ca_N Gbar 0
    setfield {comp}/Ca_L Gbar 0
    setfield {comp}/Ca_LVA Gbar 0
    // setfield {comp}/Ca_LVA Gbar {calvamult*{getfield {comp}/Ca_LVA Gbar}}
end

step 0.020 -t

setfield /neuron/soma inject 0.5e-9
step 1 -t









