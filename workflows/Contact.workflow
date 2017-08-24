<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Status_Counter</fullName>
        <field>Sales_Steps_Status_Change__c</field>
        <formula>1</formula>
        <name>Status Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Net Promoter Score</fullName>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Contact.Contact_Activity__c</field>
            <operation>equals</operation>
            <value>NPS,Both</value>
        </criteriaItems>
        <description>Sends out NPS Survey to all contacts who are marked as &quot;NPS&quot; or both in the</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Sales Step Status Change</fullName>
        <actions>
            <name>Status_Counter</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Sales_Step_Status__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
