/// Send SMS via AWS SNS
Class dc.opcua.SMS Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

/// AWS boto3 client
Property client As %SYS.Python;

/// json.dumps reference
Property tojson As %SYS.Python;

/// Phone number to send SMS to
Property phone As %String [ Required ];

Parameter SETTINGS = "phone:SMS";

Method OnMessage(request As Ens.StringContainer, Output response As Ens.StringContainer) As %Status
{
	#dim sc As %Ststus = $$$OK
	try {
		set response = ##class(Ens.StringContainer).%New(..SendSMS(request.StringValue))
		set code = +{}.%FromJSON(response.StringValue).ResponseMetadata.HTTPStatusCode
		set:(code'=200) sc = $$$ERROR($$$GeneralError, $$$FormatText("Error sending SMS, code: %1 (expected 200), text: %2", code, response.StringValue))
	} catch ex {
		set sc  = ex.AsStatus()
	}
	
	return sc
}

Method SendSMS(msg As %String) [ Language = python ]
{
	response = self.client.publish(PhoneNumber=self.phone, Message=msg)
	return self.tojson(response)
}

Method OnInit() As %Status
{
	#dim sc As %Styatus = $$$OK
	try {
		do ..PyInit()
	} catch ex {
		set sc = ex.AsStatus()
	}
	quit sc
}

/// Connect to AWS
Method PyInit() [ Language = python ]
{
	import boto3
	from json import dumps
	self.client = boto3.client("sns")
	self.tojson = dumps
}

}