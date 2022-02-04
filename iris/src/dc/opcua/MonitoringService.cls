Class dc.opcua.MonitoringService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property Adapter As Ens.InboundAdapter;

Property SMSOperation As %String;

Parameter SETTINGS = "SMSOperation:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Method PyProcessInput() [ Language = python ]
{
	import iris
	from datetime import datetime, timedelta

	period = self.Adapter.CallInterval
	end = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
	start = (datetime.now()-timedelta(seconds=period)).strftime("%Y-%m-%d %H:%M:%S")

	statement = iris.sql.prepare("SELECT * FROM dc_opcua.Threshold_Active(?)")
	rset = statement.execute(period)
	alerts = "Alerts over the period: " + start + " to " + end + "\n"

	for line in rset:
		alerts =  alerts + "[" + str(line[1]) + "] Node: " + str(line[0]) + " avg value: " + str(line[3]) + " above threshold: " + str(line[2]) + "\n"

	if len(alerts) > 0:
		request = iris.cls("Ens.StringContainer")._New(alerts)
		self.SendRequestAsync(self.SMSOperation, request)
}

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	#dim sc As %Status = $$$OK
	try {
		do ..PyProcessInput()
	} catch ex {
		set sc = ex.AsStatus()
	}
	quit sc
}

}
