<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contract_Pricing_Pricing_Type_Text</fullName>
        <field>Pricing_Type_Text__c</field>
        <formula>$RecordType.Name</formula>
        <name>Contract Pricing - Pricing Type Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Standard_Cost</fullName>
        <field>Standard_Cost__c</field>
        <formula>IF($RecordType.Name = &quot;Margin Based&quot;, Margin_Cost_per_Unit__c, 
IF($RecordType.Name = &quot;Markup Based&quot;, Markup_Cost_per_Unit__c, 0) 
)</formula>
        <name>Set Standard Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Standard_Revenue</fullName>
        <field>Standard_Revenue__c</field>
        <formula>IF($RecordType.Name = &quot;Margin Based&quot;, Margin_Revenue_per_Unit__c, 
IF($RecordType.Name = &quot;Markup Based&quot;, Markup_Revenue_per_Unit__c, 0) 
)</formula>
        <name>Set Standard Revenue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Contract Pricing - Set Record Type Text</fullName>
        <actions>
            <name>Contract_Pricing_Pricing_Type_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Standard_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Standard_Revenue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract_Pricing__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
