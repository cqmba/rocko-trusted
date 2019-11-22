PCRs

description
PCRs 
the new value of a PCR is calculated by the HASH of the old value concatenated with the new HASH value
PCR[N] = HASHalg( PCR[N] || ArgumentOfExtend )
PCRs  0..16 can be extended, but not resetted
PCRs 17..22 are reserved and can not be used
PCR  23     can be extended and resetted

precondition
n/a

implementation
show all pcrs: tpm2_pcrlist
extend a PCR with a pre-calculated HASH: tpm2_pcrextend
extend a PCR with a File as argument: tpm2_pcrevent
