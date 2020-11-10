<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 48000
ksmps = 96
nchnls = 1
#include "./opcodes.orc"
instr 100
kres1, kres2 trsq2 p4, k(p5), metro:k(p6)
printk2 kres1
printk2 kres2
/*
printf "\n %f \n", metro:k(.001), k1
printf "\n %f \n", metro:k(.001), k2
printf "\n %f \n", metro:k(.001), k3
printf "\n %f \n", metro:k(.001), k4
*/
endin
</CsInstruments>
<CsScore>
f 30 0 4 -2  0 5 3 0 ;a "paramft"
f 130 0 8 -2  0 32 1 31 4 42 6 55 1 20 1 1 ;seq
i 100 0 8 30 130 2
e
</CsScore>
</CsoundSynthesizer>
