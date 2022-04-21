# Check if is already enrolled

if [ -f ${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/${ID_NAME}/tls-msp/keystore/key.pem ]; then
    echo "TLS Cert for [${ID_NAME}] already exists."
    exit 0
fi

export FABRIC_CA_CLIENT_TLS_CERTFILES=${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/ca/admin

# Register
fabric-ca-client register -d --id.name ${ID_NAME} --id.secret ${ID_SECRET} --id.type ${ID_TYPE} -u https://0.0.0.0:7054

# Copy TLS CA Certificate
export FABRIC_CA_CLIENT_HOME=${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/${ID_NAME}
export TLS_CA_DIR=${FABRIC_CA_CLIENT_HOME}/assets/tls-ca
mkdir -p ${TLS_CA_DIR}
cp ${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/ca/admin/msp/cacerts/0-0-0-0-7054.pem ${TLS_CA_DIR}/tls-ca-cert.pem

# Enroll
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=${TLS_CA_DIR}/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://${ID_NAME}:${ID_SECRET}@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${CSR_HOST}

rtnVal=${?}
if [ $rtnVal -ne 0 ]; then
    echo "**TLS Cert for [${ID_NAME}] cannot be generated. fabric-ca-client enroll return error"
    exit 1
fi

# Rename Key
mv ${FABRIC_CA_CLIENT_HOME}/tls-msp/keystore/* ${FABRIC_CA_CLIENT_HOME}/tls-msp/keystore/key.pem

if [ -f ${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/${ID_NAME}/tls-msp/keystore/key.pem ]; 
then
    echo "TLS Cert for [${ID_NAME}] is enrolled successfully."
    exit 0
else
    echo "TLS Cert for [${ID_NAME}] cannot be generated."
    exit 1
fi