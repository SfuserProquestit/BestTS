<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>OLD_REQUEST_PART_New_Order_Request_Notification</fullName>
        <ccEmails>ncrservice@best-ts.com.au</ccEmails>
        <ccEmails>ncrupdates@best-ts.com.au</ccEmails>
        <ccEmails>IC230030@ncr.com</ccEmails>
        <description>OLD_REQUEST PART: New Order Request Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>joey@cloudycode.com.au.bestite</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>ncrservice@best-ts.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>FSL/OLD_REQUEST_PART_New_Order_Email</template>
    </alerts>
    <alerts>
        <fullName>OLD_REQUEST_PART_Receive_Order_Notification</fullName>
        <ccEmails>ncrservice@best-ts.com.au</ccEmails>
        <ccEmails>ncrupdates@best-ts.com.au</ccEmails>
        <ccEmails>Kamalendu.Mukherjee@ncr.com</ccEmails>
        <description>OLD_REQUEST PART: Receive Order Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>joey@cloudycode.com.au.bestite</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>ncrservice@best-ts.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>FSL/OLD_REQUEST_PART_Received_Order_Email</template>
    </alerts>
    <alerts>
        <fullName>REQUEST_PART_New_Order_Request_Notification</fullName>
        <description>REQUEST PART: New Order Request Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>sfuser@proquestit.com.bestite</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FSL/REQUEST_PART_New_Order_Email</template>
    </alerts>
    <alerts>
        <fullName>REQUEST_PART_Receive_Order_Notification</fullName>
        <description>REQUEST PART: Receive Order Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>sfuser@proquestit.com.bestite</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FSL/REQUEST_PART_Received_Order_Email</template>
    </alerts>
</Workflow>
