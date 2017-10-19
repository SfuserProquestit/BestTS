<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Dispatched_Service_Email</fullName>
        <description>Dispatched Service Email</description>
        <protected>false</protected>
        <recipients>
            <field>Technician_Email_address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>service@best-ts.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>FSL/New_Service_Notification</template>
    </alerts>
    <alerts>
        <fullName>NCR_Field_Service_ACCEPTED_Notification_email</fullName>
        <ccEmails>ncrupdates@best-ts.com.au; IC230030@ncr.com</ccEmails>
        <description>NCR Field Service ACCEPTED Notification Email</description>
        <protected>false</protected>
        <senderAddress>ncrservice@best-ts.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>FSL/OLDNCR_Field_Service_Accepted</template>
    </alerts>
    <alerts>
        <fullName>NCR_Field_Service_Accepted_Notification</fullName>
        <ccEmails>ncrupdates@best-ts.com.au</ccEmails>
        <ccEmails>ic230030@ncr.com</ccEmails>
        <description>NCR Field Service Accepted Notification</description>
        <protected>false</protected>
        <recipients>
            <field>WO_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>FSL/OLDNCR_Field_Service_Accepted</template>
    </alerts>
    <alerts>
        <fullName>NCR_Field_Service_Closure_Notification2</fullName>
        <ccEmails>ncrupdates@best-ts.com.au</ccEmails>
        <ccEmails>ic230030@ncr.com</ccEmails>
        <description>NCR Field Service Closure Notification2</description>
        <protected>false</protected>
        <recipients>
            <field>WO_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>FSL/NCR_Field_Service_Closure_Notification2</template>
    </alerts>
    <alerts>
        <fullName>NCR_Field_Service_Suspension_Notification</fullName>
        <ccEmails>ncrupdates@best-ts.com.au</ccEmails>
        <ccEmails>ic230030@ncr.com</ccEmails>
        <description>NCR Field Service Suspension Notification</description>
        <protected>false</protected>
        <recipients>
            <field>WO_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>FSL/NCR_Field_Service_Suspension_Notification</template>
    </alerts>
    <alerts>
        <fullName>OLD_Allow_Auto_Status_Notification</fullName>
        <ccEmails>IC230030@ncr.com; ncrupdates@best-ts.com.au; damian.mitchell@ncr.com</ccEmails>
        <description>OLD_Allow Auto. Status Notification</description>
        <protected>false</protected>
        <senderAddress>ncrservice@best-ts.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>FSL/OLD_NCR_Field_Service_Closure</template>
    </alerts>
</Workflow>
