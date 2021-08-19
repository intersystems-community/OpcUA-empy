Class dc.opcua.MonitoringService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property Adapter As Ens.InboundAdapter;

Property SMSOperation As %String;

Parameter SETTINGS = "SMSOperation:Basic:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	#dim sc As %Status = $$$OK
	try {
		set period = ..Adapter.CallInterval
		set end = $zdt($now(),3,1)
		set rs = ##class(dc.opcua.Threshold).ActiveFunc(period)
		set alerts = ""
		while rs.%Next() {
			set alerts = alerts _ $$$FormatText("[%1] Node: %2 avg value: %3 above threshold: %4.",rs.type, rs.node, rs.value, rs.threshold) _ $$$NL
		}
		if $l(alerts)>0 {
			set alerts = $$$FormatText("Alerts over the period: %1 to %2.", $system.SQL.DATEADD("ss", -period, end), end) _ $$$NL _ alerts
 			set request = ##class(Ens.StringContainer).%New(alerts)
			set sc = ..SendRequestAsync(..SMSOperation, request)
		}
		
	} catch ex {
		set sc = ex.AsStatus()
	}
	quit sc
}

}