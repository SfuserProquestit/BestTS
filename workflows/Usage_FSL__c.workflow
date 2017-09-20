<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Apply_Payroll_Tax_on_Engineering_Cost</fullName>
        <field>Total_Engineering_Cost__c</field>
        <formula>IF(Text( Not_a_Sole_Trader__c)=&apos;NO&apos;, Total_Engineering_Cost__c *1.06,Total_Engineering_Cost__c)</formula>
        <name>Apply Payroll Tax on Engineering Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apply_Payroll_Tax_on_Pass_Through_Cost</fullName>
        <field>Total_Pass_Through_Cost__c</field>
        <formula>IF(Text( Not_a_Sole_Trader__c)=&apos;NO&apos;, Total_Pass_Through_Cost__c  *1.06,Total_Pass_Through_Cost__c)</formula>
        <name>Apply Payroll Tax on Pass Through Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Total_Engineering_Cost</fullName>
        <field>Total_Engineering_Cost__c</field>
        <formula>IF( Use_Standard_Price__c = TRUE,Units__c *   Contract_Pricing__r.Margin_Cost_per_Unit__c,
Units__c * Cost_per_Unit__c)</formula>
        <name>Calculate Total Engineering Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Total_Engineering_Revenue</fullName>
        <field>Total_Engineering_Revenue__c</field>
        <formula>IF( Use_Standard_Price__c = TRUE,Units__c *  Contract_Pricing__r.Margin_Revenue_per_Unit__c,
Units__c *  Revenue_per_Unit__c )</formula>
        <name>Calculate Total Engineering Revenue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Total_Pass_Through_Cost</fullName>
        <field>Total_Pass_Through_Cost__c</field>
        <formula>IF( Use_Standard_Price__c = TRUE,Units__c *  Contract_Pricing__r.Markup_Cost_per_Unit__c,Units__c * Cost_per_Unit__c)</formula>
        <name>Calculate Total Pass Through Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Total_Pass_Through_Revenue</fullName>
        <field>Total_Pass_Through_Revenue__c</field>
        <formula>IF(Use_Standard_Price__c = TRUE,Units__c *   Contract_Pricing__r.Markup_Revenue_per_Unit__c,
Units__c *  Revenue_per_Unit__c )</formula>
        <name>Calculate Total Pass Through Revenue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Engineering_Cost</fullName>
        <field>Total_Engineering_Cost__c</field>
        <name>Clear Engineering Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Engineering_Revenue</fullName>
        <field>Total_Engineering_Revenue__c</field>
        <name>Clear Engineering Revenue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Pass_Through_Cost</fullName>
        <field>Total_Pass_Through_Cost__c</field>
        <name>Clear Pass Through Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Pass_Through_Revenue</fullName>
        <field>Total_Pass_Through_Revenue__c</field>
        <name>Clear Pass Through Revenue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Usage_Cost_per_Unit_FSL</fullName>
        <field>Cost_per_Unit__c</field>
        <formula>Contract_Pricing__r.Standard_Cost__c</formula>
        <name>Set Usage Cost per Unit (FSL)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Usage_Revenue_per_Unit_FSL</fullName>
        <field>Revenue_per_Unit__c</field>
        <formula>Contract_Pricing__r.Standard_Revenue__c</formula>
        <name>Set Usage Revenue per Unit (FSL)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Invoiced_Checkbox_false</fullName>
        <field>Invoiced__c</field>
        <literalValue>0</literalValue>
        <name>Update Invoiced Checkbox false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Invoiced_Checkbox_true</fullName>
        <field>Invoiced__c</field>
        <literalValue>1</literalValue>
        <name>Update Invoiced Checkbox true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_use_Standard_Price</fullName>
        <field>Use_Standard_Price__c</field>
        <literalValue>1</literalValue>
        <name>Update Use Standard Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Calculate Cost and Revenue %28Engineering%29</fullName>
        <actions>
            <name>Apply_Payroll_Tax_on_Engineering_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Total_Engineering_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Total_Engineering_Revenue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Pass_Through_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Pass_Through_Revenue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>$Setup.ActivateTriggers__c.Enabled__c!=false &amp;&amp; 
Contract_Pricing__r.RecordType.Name = &quot;Margin Based&quot; &amp;&amp; NOT(ISBLANK( Units__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate Cost and Revenue %28Pass Through%29</fullName>
        <actions>
            <name>Calculate_Total_Pass_Through_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Total_Pass_Through_Revenue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Engineering_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Engineering_Revenue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>$Setup.ActivateTriggers__c.Enabled__c!=false &amp;&amp; 
Contract_Pricing__r.RecordType.Name = &quot;Markup Based&quot; &amp;&amp; NOT(ISBLANK( Units__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Get Contract Pricing %28FSL%29</fullName>
        <actions>
            <name>Set_Usage_Cost_per_Unit_FSL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Usage_Revenue_per_Unit_FSL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>$Setup.ActivateTriggers__c.Enabled__c!=false &amp;&amp; 
Use_Standard_Price__c  = true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Identify Sole Trader Usage</fullName>
        <active>false</active>
        <formula>NOT( ISNULL( Service__r.CKSW_BASE__Resource__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Invoice Checkbox false</fullName>
        <actions>
            <name>Update_Invoiced_Checkbox_false</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Usage_FSL__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Standard Usage</value>
        </criteriaItems>
        <criteriaItems>
            <field>Usage_FSL__c.Invoice_Created__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Invoice Checkbox true</fullName>
        <actions>
            <name>Update_Invoiced_Checkbox_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Usage_FSL__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Standard Usage</value>
        </criteriaItems>
        <criteriaItems>
            <field>Usage_FSL__c.Invoice_Created__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Standard price checkbox on Usage creation</fullName>
        <actions>
            <name>Update_use_Standard_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Usage_FSL__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Standard Usage</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
