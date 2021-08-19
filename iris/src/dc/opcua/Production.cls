Class dc.opcua.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="dc.opcua.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="QueryService" Category="" ClassName="dc.opcua.QueryService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="parent">MyObject</Setting>
    <Setting Target="Host" Name="uri">http://examples.freeopcua.github.io</Setting>
    <Setting Target="Host" Name="url">opc.tcp://opcua:4840/freeopcua/server/</Setting>
  </Item>
  <Item Name="SMS" Category="" ClassName="dc.opcua.SMS" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="MonitoringService" Category="" ClassName="dc.opcua.MonitoringService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SMSOperation">SMS</Setting>
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
  </Item>
</Production>
}

}