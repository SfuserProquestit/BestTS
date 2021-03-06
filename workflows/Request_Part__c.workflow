<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>REQUEST_PART_New_Order_Request_Notification</fullName>
        <ccEmails>ncrservice@best-ts.com.au</ccEmails>
        <ccEmails>ncrupdates@best-ts.com.au</ccEmails>
        <ccEmails>IC230030@ncr.com</ccEmails>
        <description>REQUEST PART: New Order Request Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>joey@cloudycode.com.au.bestite</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>ncrservice@best-ts.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CKSW_BASE__Field_Service_Lightning_Templates/REQUEST_PART_New_Order_Email</template>
    </alerts>
    <alerts>
        <fullName>REQUEST_PART_Receive_Order_Notification</fullName>
        <ccEmails>ncrservice@best-ts.com.au</ccEmails>
        <ccEmails>ncrupdates@best-ts.com.au</ccEmails>
        <ccEmails>Kamalendu.Mukherjee@ncr.com</ccEmails>
        <description>REQUEST PART: Receive Order Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>joey@cloudycode.com.au.bestite</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>ncrservice@best-ts.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CKSW_BASE__Field_Service_Lightning_Templates/REQUEST_PART_Received_Order_Email</template>
    </alerts>
</Workflow>
