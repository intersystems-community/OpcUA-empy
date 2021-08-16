Class dc.opcua.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="dc.opcua.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="QueryService" Category="" ClassName="dc.opcua.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="parent">MyObject</Setting>
    <Setting Target="Host" Name="uri">http://examples.freeopcua.github.io</Setting>
    <Setting Target="Host" Name="url">opc.tcp://opcua:4840/freeopcua/server/</Setting>
  </Item>
</Production>
}

}