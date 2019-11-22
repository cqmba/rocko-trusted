#!/bin/bash
#


# SEND RAW COMMANDS
# this example calls the random number generator of the TPM
# via a low level binary 

echo "TPM2 SEND"
# send function getrandom()
# 8001 0000 000c 0000 017b 000a
tpm2_send cmd_random.bin -o cmd_output.bin
echo ""


echo "READ RETURN VALUE"
# output contains header and 10 random bytes
xxd cmd_output.bin
echo ""


echo "CLEANUP"
rm cmd_output.bin
echo ""
