@echo off
@setlocal EnableDelayedExpansion 

: set config file
If "%CONFIG%" EQU "" (
  SET CONFIG=readyapi-testengine.yaml

  IF NOT EXIST "C:\data\!CONFIG!" (
    ECHO Copying !CONFIG! to C:\data\!CONFIG!...
    COPY !CONFIG! C:\data\!CONFIG!
  )
  ECHO Set CONFIG to C:\data\!CONFIG!
  SET CONFIG=C:\data\!CONFIG!
)

: override testengine password
IF "%TESTENGINE_PASSWORD%" NEQ "" (
    ECHO Setting PASSWORD_SWITCH...
    SET PASSWORD_SWITCH="--password %TESTENGINE_PASSWORD%"
)

: reset admin account
IF "%TESTENGINE_RESET_ADMIN_ACCOUNT%" NEQ "" (
    ECHO Setting RESET_SWITCH...
    SET RESET_SWITCH="--resetAdminAccount"
)

: start the server
java -cp "C:/maven/lib/*" -XX:+UseG1GC -Duser.home=C:/data -Duser.timezone=UTC -Dsoapui.home=C:/maven -Dsoapui.ext.libraries=C:/ext -Dserver.lib=C:/maven/lib -Dallow.external.requests=true -Dtest.history.disabled=true -Dreadyapi.dashboard.mode=DISABLED -Dsoapui.log4j.config=log4j2.xml --add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.lang.invoke=ALL-UNNAMED --add-opens java.desktop/java.beans=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang.reflect=ALL-UNNAMED --add-opens java.base/java.util.concurrent.atomic=ALL-UNNAMED com.smartbear.ready.testserver.ReadyApiTestServerDockerMain --cfg "%CONFIG%" %PASSWORD_SWITCH% %RESET_SWITCH%
