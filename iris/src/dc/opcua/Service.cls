Class dc.opcua.Service Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property Adapter As Ens.InboundAdapter;

Property %client As %SYS.Python;

/// key - node id
/// value - node python object
Property %nodes As array Of %SYS.Python;

/// Server Address
Property url As %VarString;

/// Namespace uri
Property uri As %VarString;

/// Parent object to the nodes we want to collect
Property parent As %VarString;

Parameter SETTINGS = "url:OpcUA,uri:OpcUA,parent:OpcUA";

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
	#dim sc As %Status = $$$OK
	try {
		set asyncua = ##class(%SYS.Python).Import("asyncua.sync")

		set ..%client = asyncua.Client(..url)
		do ..%client.connect()
		
		set idx = ..%client."get_namespace_index"(..uri)

		
		set builtins = ##class(%SYS.Python).Builtins()	
		set path = builtins.list()
		do path.append(idx _ ":" _ ..parent)
		set nodesPy = ..%client.nodes.objects."get_child"(path)."get_children"()
		
		for i=0:1:builtins.len(nodesPy)-1 {
			set node = nodesPy."__getitem__"(i)
			set nodeName = node."read_display_name"().Text
			set nodeId = ##class(Node).getNodeId(..uri, ..parent, nodeName)
			do ..%nodes.SetAt(node, nodeId)
		}
	} catch ex {
		set sc = ex.AsStatus()
	}
	
	quit sc
}

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	#dim sc As %Status = $$$OK
	try {
		set id = ""
		for { 
			set node = ..%nodes.GetNext(.id)
			quit:'id
			set value = node."read_value"()
			set sc = ##class(Value).add(id, value)	
		}
	} catch ex {
		#dim ex As %Exception.General
		set sc1 = $$$ERROR($$$GeneralError, "Exception on processing node: " _ id)
		set sc = $$$ADDSC(sc1,ex.AsStatus())
	}
	quit sc
}

/// This user callback method is called from %OnClose()
Method OnTearDown() As %Status
{
	try {
		do ..%client.disconnect()	
	} catch ex {
		#dim ex As %Exception.General
		$$$LOGWARNING("Exception during disconnect: " _ ex.DisplayString())
	}
	
	quit ##super()
}

}
