#!/bin/bash
#


# PCR
# platform configuration registers
#


##################################################################################
#
# WRITE SOME PCR VALUES

echo "TPM2 PCRLIST CURRENT"
# get the full current list of values in the SHA256 pcr banks
tpm2_pcrlist -L sha256:0,1,2,3
echo ""


echo "WRITE A PRE-CLACULATED HASH VALUE TO PCR (EXTEND)"
# calculate hash value with linux tool "sha256sum" and show the result
# note: hash can be calculatet even by the TPM
sha256_value=($(sha256sum input_hex.dat))
echo "SHA256 Value: 0x`echo $sha256_value`"
# extend the PCR1 and PCR3 with the same value
tpm2_pcrextend 1:sha256=`echo $sha256_value`
tpm2_pcrextend 3:sha256=`echo $sha256_value`
echo ""

echo "TPM2 PCRLIST NEW"
# get the full current list of values in the SHA256 pcr banks
tpm2_pcrlist -L sha256:0,1,2,3
echo ""

#
##################################################################################




##################################################################################
##################################################################################
#
# Create a trial session and build a PCR policy via a policyPCR event to generate a policy hash.

echo "CREATEPRIMARY"
# -a e
tpm2_createprimary -a o -g sha256 -o primary.ctx
echo ""


echo "READ AND STORE THE PCR0..3"
# speichern der aktuellen PCR Zustände
# optional 
tpm2_pcrlist -L "sha256:0,1,2,3" -o pcrlist.dat
echo ""


echo "START TRIAL AUTH SESSION (TPM_SE_TRIAL)"
# trial session
# [A trial session is used when building a policy]
# and get the handle for later cleanup
tpm2_startauthsession -S mysession_t.ctx
echo ""

echo "ACTIVE SESSIONS"
echo "loaded"
tpm2_getcap -c handles-loaded-session
echo "saved"
tpm2_getcap -c handles-saved-session
echo ""

echo "CREATE POLICY WITH CURRENT PCR STATUS"
# PCRs 0..3 nehmen
# -F pcrlist.dat ist optional
# policy wird erstellt
tpm2_policypcr -S mysession_t.ctx -L "sha256:0,1,2,3" -o policy.dat
echo ""


echo "CLEANUP 1"
tpm2_flushcontext -s
tpm2_flushcontext -l
tpm2_flushcontext -t
echo ""


##################################################################################
#
# Create an object and use the policy hash as the policy to satisfy for usage. 

echo "SEAL SOME DATA"
#tpm2_create -C primary.ctx -u key.pub -r key.priv -L policy.dat -a 'sign|fixedtpm|fixedparent|sensitivedataorigin' -i pass.dat
# -b 0x2000A
# Schlüsselpaar erstellen mit der PCR policy
# -i Eingabedaten, die sealed werden sollen
# NAME					BIT	VALUE
# TPMA_OBJECT_SIGN_ENCRYPT [x]		
# TPMA_OBJECT_DECRYPT [x]
# TPMA_OBJECT_FIXEDTPM			1	1
# TPMA_OBJECT_FIXEDPARENT		4	1
# TPMA_OBJECT_SENSITIVEDATAORIGIN	5	1
# TPMA_OBJECT_USERWITHAUTH		6	0
# TPMA_OBJECT_DECRYPT			17	1
# TPMA_OBJECT_SIGN			18	1
tpm2_create -C primary.ctx -g sha256 -u key.pub -r key.priv -L policy.dat -i pass.dat


echo "LOAD"
# load the key pair
# -n An optional file to save the name structure of the object.
# -o The file name of the saved object context, required.
tpm2_load -C primary.ctx -u key.pub -r key.priv -n unseal.key.name -o unseal.key.ctx
echo ""

echo "ACTIVE SESSIONS"
echo "loaded"
tpm2_getcap -c handles-loaded-session
echo "saved"
tpm2_getcap -c handles-saved-session
echo ""

#
##################################################################################
##################################################################################





##################################################################################
##################################################################################
#
# Create an actual policy session and using a policyPCR event, update the session policy hash. 

echo "START POLICY AUTH SESSION (TPM_SE_POLICY)"
# --policy-session
# [a policy session is used when authenticating with a policy]
tpm2_startauthsession --policy-session -S mysession_p.ctx
echo ""

echo "ACTIVE SESSIONS"
echo "loaded"
tpm2_getcap -c handles-loaded-session
echo "saved"
tpm2_getcap -c handles-saved-session
echo ""

echo "POLICY PCR"
# load the policy
# 
tpm2_policypcr -S mysession_p.ctx -L "sha256:0,1,2,3"
echo ""



##################################################################################
#
# Using the actual policy session from step 3 in tpm2_unseal to unseal the object. 


echo "UNSEAL"
tpm2_unseal -p "session:mysession_p.ctx" -c unseal.key.ctx
echo ""


echo "CHANGE PCR VALUES"
tpm2_pcrextend 1:sha256=`echo $sha256_value`
tpm2_pcrextend 3:sha256=`echo $sha256_value`
tpm2_pcrlist -L sha256:0,1,2,3
echo ""


echo "TRY TO UNSEAL AGAIN"
tpm2_unseal -p "session:mysession_p.ctx" -c unseal.key.ctx
echo ""

#
##################################################################################
##################################################################################


echo "CLEANUP 2"
rm primary.ctx
rm mysession_t.ctx
rm mysession_p.ctx
rm key.pub
rm key.priv
rm policy.dat
rm unseal.key.ctx
rm unseal.key.name
rm pcrlist.dat
tpm2_flushcontext -s
tpm2_flushcontext -l
tpm2_flushcontext -t
echo ""
