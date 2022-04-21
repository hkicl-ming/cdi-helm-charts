# Check if is already enrolled
if [ -f ${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/admin/msp/signcerts/cert.pem ]; then
    echo "Cert for [${ID_NAME}] already exists."
    exit 0
fi

export FABRIC_CA_CLIENT_TLS_CERTFILES=${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/ca/admin

# Register
fabric-ca-client register -d --id.name ${ID_NAME} --id.secret ${ID_SECRET} --id.type admin --id.attrs "${ID_ATTRS}" -u https://0.0.0.0:7054

# Enroll Org0's Admin
export FABRIC_CA_CLIENT_HOME=${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/ca/admin/msp/cacerts/0-0-0-0-7054.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://${ID_NAME}:${ID_SECRET}@0.0.0.0:7054

rtnVal=${?}
if [ $rtnVal -ne 0 ]; then
    echo "**Cert for [${ID_NAME}]. fabric-ca-client enroll return error"
    exit 1
fi

# Rename Key
mv ${FABRIC_CA_CLIENT_HOME}/msp/keystore/* ${FABRIC_CA_CLIENT_HOME}/msp/keystore/key.pem

if [ -f ${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/admin/msp/signcerts/cert.pem ]; 
then
    echo "Cert for [${ID_NAME}] is generated successfully."
    exit 0
else
    echo "Cert for [${ID_NAME}] cannot be generated."
    exit 1
fi