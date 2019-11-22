#!/bin/bash
#

# no primary
#echo "PRIMARY"
#tpm2_createprimary -a o -o primary.ctx 
#-P "test"
#echo ""


echo "NV LIST 1"
# Display all defined Non-Volatile (NV)s indices.
tpm2_nvlist
echo ""


echo "NV DEFINE"
#
# HIERARCHIES
# 0x40000001 = TPM_RH_OWNER
# 
tpm2_nvdefine -x 0x1c00012 -a 0x40000001 -s 13 -b 0x20002 -V
# -p "test"
#0x2000A
#0x2070003
echo ""


echo "NV LIST 2"
# Display all defined Non-Volatile (NV)s indices.
tpm2_nvlist
echo ""



echo "NV WRITE"
# 0x40000001 = TPM_RH_OWNER
tpm2_nvwrite -x 0x1c00012 -a 0x40000001 -V nv.data
echo ""


echo "NV READ"
# 0x40000001 = TPM_RH_OWNER
tpm2_nvread  -x 0x1c00012 -a 0x40000001 -V
echo ""


echo "NV RELEASE"
# 0x40000001 = TPM_RH_OWNER
tpm2_nvrelease -x 0x1c00012 -a 0x40000001 -V
echo ""


echo "CLEANUP"
#rm primary.ctx
tpm2_flushcontext -s
tpm2_flushcontext -l
tpm2_flushcontext -t
echo ""
