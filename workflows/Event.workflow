<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EVENT_Send_notification_email_for_WO_Event_change</fullName>
        <ccEmails>paulaa@best-ite.com</ccEmails>
        <ccEmails>tobyl@best-ite.com</ccEmails>
        <description>EVENT: Send notification email for WO Event change</description>
        <protected>false</protected>
        <recipients>
            <recipient>joey@cloudycode.com.au.bestite</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>service@best-ite.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SVMXC__ServiceMaxEmailTemplates/EVENT_Notify_WO_Event_Change</template>
    </alerts>
    <rules>
        <fullName>EVENT%3A Work Order Event Time Change Notification</fullName>
        <actions>
            <name>EVENT_Send_notification_email_for_WO_Event_change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When a WO event DateTime start has changed, notify the right before in the organisation</description>
        <formula>AND(
ISCHANGED(ActivityDateTime),
BEGINS(WhatId,&quot;a0o&quot;),
LastModifiedBy.Profile.Name = &quot;Best ITE - ServiceMax Field Technician&quot;  
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
