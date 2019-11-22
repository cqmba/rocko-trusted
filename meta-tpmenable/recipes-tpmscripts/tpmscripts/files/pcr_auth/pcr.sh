#!/bin/bash
#


# PCR
# platform configuration registers
#
# calculation
# the new value depends on the old value!
# PCR[N] = HASHalg( PCR[N] || ArgumentOfExtend )

echo "TPM2 PCRLIST"
# get the full current list of values in the SHA256 pcr banks
# SHA256 and SHA1 is supported by the TPM
tpm2_pcrlist -g sha256
echo ""


echo "WRITE A PRE-CLACULATED HASH VALUE TO PCR0 AND PCR23 (EXTEND)"
# calculate hash value with linux tool "sha256sum" and show the result
# note: hash can be calculatet even by the TPM
sha256_value=($(sha256sum input_hex.dat))
echo "SHA256 Value: 0x`echo $sha256_value`"
# extend the PCR0 and PCR23 with the same value
tpm2_pcrextend 0:sha256=`echo $sha256_value`
tpm2_pcrextend 23:sha256=`echo $sha256_value`
echo ""


echo "HASH A FILE AND WRITE TO PCR1 (EXTEND)"
# calculate hash of input file on the TPM 
# and
# wirte to PCR1 (-x 1)
# limited to 1024 bytes
tpm2_pcrevent -x 1 input_hex.dat
echo ""


echo "TPM2 PCRLIST"
# get the current list of values in the SHA256 pcr banks 0 and 1
tpm2_pcrlist -L sha256:0,1,23
echo ""


echo "RESET THE PCR23"
# PCR0..16 can not be resetted and will cause an error
tpm2_pcrreset 23
tpm2_pcrlist -L sha256:0,1,23
echo ""


echo "CLEANUP"
#rm
echo ""
