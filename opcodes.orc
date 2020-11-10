 opcode myNome, k, kk
kcps, kparamft xin
kloops tablekt 0, kparamft, 0
kloope tablekt 1, kparamft, 0
kloopi tablekt 2, kparamft, 0
kseq tablekt 3, kparamft, 0
kseq init table:i(3,i(kparamft),0) ;very important quirk to making seqtime work correctly w/ k-inputs
ktrig seqtime divz(1,kcps,.0001), kloops, kloope, kloopi, kseq
 xout ktrig
 endop

 opcode myNome2, kk, kkk
kcps, kparamftTim, kparamftRhy xin 
ktrig myNome kcps, kparamftTim
k1 init 0
kloops tablekt 0, kparamftRhy, 0
kloope tablekt 1, kparamftRhy, 0
kloopi tablekt 2, kparamftRhy, 0
kseq tablekt 3, kparamftRhy, 0
kseq init table:i(3,i(kparamftRhy),0) ;very important quirk to making seqtime work correctly w/ k-inputs
trigseq ktrig, kloops, kloope, kloopi, kseq, k1
ktrig1 = ktrig*(1-k1) ;triggers when k1=0
ktrig2 = ktrig*(k1) ;triggers when k1=1
xout ktrig1, ktrig2
 endop
 /*
Example use:
ift1 ftgentmp 0,0,4,-2,1, 1, 1, 1 ;use this for the clock's kseq input
ift2 ftgentmp 0,0,4,-2,0, 1, 1, 1 ;downbeat will come on ktrig1, other 3 beats on ktrig2
iparamft ftgentmp 0,0,4,-2, 0, 4, 0, ift1
iparamftRhy ftgentmp 0,0,4,-2, 0, 4, 0, ift2
ktrig1, ktrig2 myNome2 k(144/60), k(iparamft), k(iparamftRhy)
;this should result in a steady 4/4 trigger at 144 bpm with the downbeat on ktrig1.
iparamftRhy2 ftgentmp 0,0,4,-2,0, 3, 2, ift2 ;a different rhythm
ktrig1, ktrig2 myNome2 k(144.60), k(iparamft), k(iparamftRhy2)
 */


 opcode scorefromft, Si, i
ift_in xin
ilen = 0
loop:
if (table:i(ilen,ift_in,0)!=0) then
ilen += 1
igoto loop
endif
print ilen
S1 sprintf "i %f ", table:i(0, ift_in, 0)
icount = 0
loop2:
icount += 1
if (icount<ilen) then
Snext sprintf "%f ", table:i(icount, ift_in, 0)
S1 strcat S1, Snext
igoto loop2
endif
xout S1, ilen
 endop

 opcode "table4k", kkkk, i ;useful for using size-4 tables as control interfaces for something that takes 4 k-rate inputs, specifically a seqtime or trigseq
iparamft xin
kloops table 0, iparamft, 0
kloope table 1, iparamft, 0
kloopi table 2, iparamft, 0
kfn table 3, iparamft, 0
xout kloops, kloope, kloopi, kfn
 endop

 opcode "trsq2", kk, ikO 
;this version does NOT use the last output from table_4k
;instead it has a separate k-input to identify the table trigseq reads
iparamft, kseq, ktrig xin
kstart, kend, kloopinit, kxx table4k iparamft
kres1 init 0
kres2 init 0
trigseq ktrig, kstart, kend, kloopinit, kseq, kres1, kres2
xout kres1, kres2
 endop

 opcode "schedseq_p4", k, ikkO
iparamft, kseq, kinstrno, ktrig xin
kres1, kres2 trsq2 iparamft, ktrig
schedkwhen ktrig, 0, 1000, kinstrno, 0, kres1, kres2
;kres1 is used as p3, kres2 = p4
xout k(0)
 endop


 opcode p1p2p3Sk, SSSS, S
Sin xin
klen strlenk Sin
k1 strindexk Sin, " "
S1 strsubk Sin, 0, k1
Safter1 strsubk Sin, k1+1, klen
k2 strindexk Safter1, " "
S2 strsubk Safter1, 0, k2
Safter2 strsubk Safter1, k2+1, klen
k3 strindexk Safter2, " "
S3 strsubk Safter2, 0, k3
Safter3 strsubk Safter2, k3+1, klen
xout S1,S2,S3,Safter3
 endop

 opcode retimeSk, S, SkPO
S_ink, kinstr, kbeat, ktrig xin ;defaults: 
;(na)  (na)    1.0   0.0
Sxx, Sp2, Sp3, S4 p1p2p3Sk S_ink
kp2 strtodk Sp2
kp3 strtodk Sp3
Sp1n sprintfk "i%d", kinstr
Sp2n sprintfk " %f", kp2*kbeat
Sp3n sprintfk " %f ", kp3*kbeat
kp3 *= kbeat
Snew strcatk Sp1n, Sp2n
Snew strcatk Snew, Sp3n
Snew strcatk Snew, S4
xout Snew
 endop
