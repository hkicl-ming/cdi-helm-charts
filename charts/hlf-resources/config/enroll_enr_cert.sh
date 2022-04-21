# Check if is already enrolled

echo "${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/${ID_NAME}"

if [ -f ${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/${ID_NAME}/msp/signcerts/cert.pem ]; then
    echo "Cert for [${ID_NAME}] already exists."
    exit 0
fi

export FABRIC_CA_CLIENT_TLS_CERTFILES=${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/ca/admin

# Register
fabric-ca-client register -d --id.name ${ID_NAME} --id.secret ${ID_SECRET} --id.type ${ID_TYPE} -u https://0.0.0.0:7054

# Copy Root CA Certificate
export FABRIC_CA_CLIENT_HOME=${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/${ID_NAME}
export CA_DIR=${FABRIC_CA_CLIENT_HOME}/assets/ca
mkdir -p ${CA_DIR}
cp ${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/ca/admin/msp/cacerts/0-0-0-0-7054.pem ${CA_DIR}/ca-cert.pem

# Enroll
export FABRIC_CA_CLIENT_TLS_CERTFILES=${CA_DIR}/ca-cert.pem
fabric-ca-client enroll -d -u https://${ID_NAME}:${ID_SECRET}@0.0.0.0:7054

rtnVal=${?}
if [ $rtnVal -ne 0 ]; then
    echo "**Cert for [${ID_NAME}] cannot be generated. fabric-ca-client enroll return error"
    exit 1
fi

# Copy admin cert
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp ${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/admin/msp/signcerts/cert.pem ${FABRIC_CA_CLIENT_HOME}/msp/admincerts/admin-cert.pem

# Rename Key
mv ${FABRIC_CA_CLIENT_HOME}/msp/keystore/* ${FABRIC_CA_CLIENT_HOME}/msp/keystore/key.pem

if [ -f ${CERT_ROOT_DIR}/${CRYPTO_DIR}/${MSPID}/${ID_NAME}/msp/signcerts/cert.pem ]; 
then
    echo "Cert for [${ID_NAME}] is enrolled successfully."
    exit 0
else
    echo "Cert for [${ID_NAME}] cannot be generated."
    exit 1
fi
