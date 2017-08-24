<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Calculate_Total_Cost</fullName>
        <field>Total_Cost__c</field>
        <formula>Units__c * Cost_per_Unit__c</formula>
        <name>Calculate Total Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Total_Revenue</fullName>
        <field>Total_Revenue__c</field>
        <formula>Units__c * Revenue_per_Unit__c</formula>
        <name>Calculate Total Revenue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Pricing_Type_Text</fullName>
        <field>Pricing_Type_Text__c</field>
        <formula>Contract_Pricing__r.Pricing_Type_Text__c</formula>
        <name>Set Pricing Type Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Usage_Cost_per_Unit</fullName>
        <field>Cost_per_Unit__c</field>
        <formula>Contract_Pricing__r.Standard_Cost__c</formula>
        <name>Set Usage Cost per Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Usage_Revenue_per_Unit</fullName>
        <field>Revenue_per_Unit__c</field>
        <formula>Contract_Pricing__r.Standard_Revenue__c</formula>
        <name>Set Usage Revenue per Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Usage_Posted_equals_True</fullName>
        <field>Posted__c</field>
        <literalValue>1</literalValue>
        <name>Usage - Posted equals True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Calculate Cost and Revenue</fullName>
        <actions>
            <name>Calculate_Total_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Total_Revenue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Usage__c.Units__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Get Contract Pricing</fullName>
        <actions>
            <name>Set_Usage_Cost_per_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Usage_Revenue_per_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Usage__c.Use_Standard_Price__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Usage Pricing Type Text</fullName>
        <actions>
            <name>Set_Pricing_Type_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Usage__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
