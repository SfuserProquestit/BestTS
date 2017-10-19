<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_when_Service_Appointment_is_Dispatched</fullName>
        <description>Send Email when Service Appointment is Dispatched</description>
        <protected>false</protected>
        <recipients>
            <field>Technician_Email_address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>service@best-ts.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>FSL/New_Service_Appointment_Notification</template>
    </alerts>
</Workflow>
