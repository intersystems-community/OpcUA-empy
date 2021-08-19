FROM arti.iscinternal.com/intersystems/iris:2021.1.0PYTHON.330.0

ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

USER ${ISC_PACKAGE_MGRUSER}

COPY --chown=$ISC_PACKAGE_MGRUSER:$ISC_PACKAGE_IRISGROUP --chmod=+x irissession.sh /
COPY --chown=$ISC_PACKAGE_MGRUSER:$ISC_PACKAGE_IRISGROUP src /tmp

# RUN chmod +x /irissession.sh

SHELL ["/irissession.sh"]

RUN \
  zn "USER" \
  do ##class(%EnsembleMgr).EnableNamespace($Namespace, 1) \
  do ##class(%SYS.Python).Install("asyncua==0.9.14") \
  do ##class(%SYS.Python).Install("boto3") \
  do $SYSTEM.OBJ.LoadDir("/tmp", "ck", , 1) \
  do ##class(dc.opcua.Threshold).Init() \
  set production = "dc.opcua.Production" \
  set ^Ens.Configuration("csp","LastProduction") = production \
  do ##class(Ens.Director).SetAutoStart(production)

# bringing the standard shell back
SHELL ["/bin/bash", "-c"]