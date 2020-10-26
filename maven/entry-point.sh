#!/bin/bash
#
# Copyright 2019 SmartBear Software
#

# find jar to run
cd maven
JAR=$(find -name "*server*.jar" -type f)

# if config is not passed, set it to default yml file
if [ -z ${CONFIG+x} ]; then
    CONFIG=readyapi-testengine.yaml

    if [ ! -f /data/$CONFIG ]; then
      cp $CONFIG /data/$CONFIG
    fi
    CONFIG=/data/$CONFIG
fi

if [ -n "$TESTENGINE_PASSWORD" ]; then
    PASSWORD_SWITCH="--password ${TESTENGINE_PASSWORD}"
fi

if [ -n "$TESTENGINE_RESET_ADMIN_ACCOUNT" ]; then
    RESET_SWITCH="--resetAdminAccount"
fi

# extract additional JVM options from ENV vars
OPTS=()
while read -r ITEM; do
    OPTS+=("${ITEM}")
done < <(env | grep -E "^JVM_OPT_[^=]+=" | sed -r "s/^[^=]+=//")

java -cp "${JAR}:lib/*" -XX:+UseG1GC -Duser.home=/data  "${OPTS[@]}" -Duser.timezone=UTC -Dsoapui.home=/maven -Dsoapui.ext.libraries=/ext -Dserver.lib=/maven/lib -Dallow.external.requests=true -Dtest.history.disabled=true -Dreadyapi.dashboard.mode=DISABLED -Dsoapui.log4j.config=log4j2.xml --add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.lang.invoke=ALL-UNNAMED --add-opens java.desktop/java.beans=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang.reflect=ALL-UNNAMED --add-opens java.base/java.util.concurrent.atomic=ALL-UNNAMED com.smartbear.ready.testserver.ReadyApiTestServerDockerMain --cfg "${CONFIG}" ${PASSWORD_SWITCH} ${RESET_SWITCH}
