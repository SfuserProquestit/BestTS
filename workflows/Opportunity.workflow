<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>OPPORTUNITY_Notify_Closed_Won_for_Engagement_Type_Projects</fullName>
        <ccEmails>Frankh@best-ite.com</ccEmails>
        <ccEmails>diego@best-ite.com</ccEmails>
        <description>OPPORTUNITY: Notify Closed/Won for Engagement Type Projects</description>
        <protected>false</protected>
        <recipients>
            <recipient>deany@best-ts.com.au</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jonb@best-ite.com-unused</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>service@best-ite.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>OPPORTUNITY_Templates/OPPORTUNITY_Notify_Closed_Won_Ops_with_Engagement_Type</template>
    </alerts>
    <alerts>
        <fullName>OPPORTUNITY_Notify_Closed_Won_for_Engagement_Type_Services</fullName>
        <ccEmails>Frankh@best-ite.com</ccEmails>
        <ccEmails>diego@best-ite.com</ccEmails>
        <description>OPPORTUNITY: Notify Closed/Won for Engagement Type Services</description>
        <protected>false</protected>
        <recipients>
            <recipient>deany@best-ts.com.au</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>paulaa@best-ts.com.au</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>service@best-ite.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>OPPORTUNITY_Templates/OPPORTUNITY_Notify_Closed_Won_Ops_with_Engagement_Type</template>
    </alerts>
    <alerts>
        <fullName>OPPORTUNITY_Notify_Closed_Won_for_Engagement_Type_Workforce</fullName>
        <ccEmails>Frankh@best-ite.com</ccEmails>
        <ccEmails>diego@best-ite.com</ccEmails>
        <description>OPPORTUNITY: Notify Closed/Won for Engagement Type Workforce</description>
        <protected>false</protected>
        <recipients>
            <recipient>deany@best-ts.com.au</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>service@best-ite.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>OPPORTUNITY_Templates/OPPORTUNITY_Notify_Closed_Won_Ops_with_Engagement_Type</template>
    </alerts>
    <fieldUpdates>
        <fullName>OPPORTUNITY_VF_Closed_Won_Sent_is_False</fullName>
        <description>VF_Closed_Won_Notification_Sent__c set to False</description>
        <field>VF_Closed_Won_Notification_Sent__c</field>
        <literalValue>0</literalValue>
        <name>OPPORTUNITY: VF Closed Won Sent is False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OPPORTUNITY_VF_Closed_Won_is_True</fullName>
        <description>VF_Closed_Won__c set to True</description>
        <field>VF_Closed_Won__c</field>
        <literalValue>1</literalValue>
        <name>OPPORTUNITY: VF Closed Won is True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Stage_Change</fullName>
        <field>Opportunity_Stage_Change__c</field>
        <formula>1</formula>
        <name>Opportunity Stage Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>OPPORTUNITY%3A Engagement Type is Projects</fullName>
        <actions>
            <name>OPPORTUNITY_Notify_Closed_Won_for_Engagement_Type_Projects</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Engagement_Type__c</field>
            <operation>equals</operation>
            <value>Projects</value>
        </criteriaItems>
        <description>Closed Won with Engagement Type Set to &apos;Projects&apos; notification workflow</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OPPORTUNITY%3A Engagement Type is Services</fullName>
        <actions>
            <name>OPPORTUNITY_Notify_Closed_Won_for_Engagement_Type_Services</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Engagement_Type__c</field>
            <operation>equals</operation>
            <value>Services</value>
        </criteriaItems>
        <description>Closed Won with Engagement Type Set to &apos;Services&apos; notification workflow</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OPPORTUNITY%3A Engagement Type is Workforce</fullName>
        <actions>
            <name>OPPORTUNITY_Notify_Closed_Won_for_Engagement_Type_Workforce</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Engagement_Type__c</field>
            <operation>equals</operation>
            <value>Workforce</value>
        </criteriaItems>
        <description>Closed Won with Engagement Type Set to &apos;Workforce&apos; notification workflow</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OPPORTUNITY%3A Reset VF Closed Won Notification</fullName>
        <actions>
            <name>OPPORTUNITY_VF_Closed_Won_Sent_is_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.VF_Closed_Won_Notification_Sent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsWon</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Resent checkbox VF_Closed_Won_Notification_Sent__c to false for Opportuntiies that are not Closed Won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OPPORTUNITY%3A Run sendPdfForClosedWonTrigger</fullName>
        <actions>
            <name>OPPORTUNITY_VF_Closed_Won_is_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsWon</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set off sendPdfForClosedWonTrigger by setting VF_Closed_Won__c to True</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Stage Change</fullName>
        <actions>
            <name>Opportunity_Stage_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(StageName)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
