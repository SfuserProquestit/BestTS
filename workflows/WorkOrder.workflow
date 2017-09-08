<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Allow_Auto_Status_Notification</fullName>
        <ccEmails>sfuser@proquestit.com</ccEmails>
        <description>Allow Auto. Status Notification</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>CKSW_BASE__Field_Service_Lightning_Templates/NCR_Field_Service_Closure</template>
    </alerts>
    <alerts>
        <fullName>NCR_Field_Work_Order_Service_ACCEPTED_Notification_Email</fullName>
        <ccEmails>laura.plotton@proquestit.com</ccEmails>
        <description>NCR Field Work Order Service ACCEPTED Notification Email</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>CKSW_BASE__Field_Service_Lightning_Templates/NCR_Field_Service_Accepted</template>
    </alerts>
    <alerts>
        <fullName>NCR_email_alert_2h_before_expiry</fullName>
        <ccEmails>ncrservice@best-ts.com.au</ccEmails>
        <ccEmails>jonb@best-ts.com.au</ccEmails>
        <description>NCR email alert 2h before expiry</description>
        <protected>false</protected>
        <recipients>
            <recipient>deany@best-ts.com.au</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CKSW_BASE__Field_Service_Lightning_Templates/NCR_SLA_ALERT</template>
    </alerts>
    <alerts>
        <fullName>Notify_Customer</fullName>
        <description>Notify Customer</description>
        <protected>false</protected>
        <recipients>
            <field>Customers_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>service@best-ts.com.au</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CKSW_BASE__Field_Service_Lightning_Templates/Work_Order_Notification_to_Customer</template>
    </alerts>
    <fieldUpdates>
        <fullName>Cancelled_Date_Time_WO</fullName>
        <field>Cancelled_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Cancelled Date Time WO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complete_Work_Order</fullName>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Complete Work Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Completed_On</fullName>
        <field>Completed_On__c</field>
        <formula>NOW()</formula>
        <name>Completed On</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Invoice_Created</fullName>
        <field>Closed_On__c</field>
        <formula>NOW()</formula>
        <name>Invoice Created</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Onsite_Time</fullName>
        <field>Onsite_Time__c</field>
        <formula>NOW()</formula>
        <name>Onsite Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Schedule_Start</fullName>
        <description>This will update Schedule start same as Technician&apos;s ETA</description>
        <field>Scheduled_Date_and_Time__c</field>
        <formula>Technician_s_ETA__c</formula>
        <name>Update Schedule Start</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Standard_Instruction</fullName>
        <field>Standard_Instructions__c</field>
        <formula>ParentWorkOrder.Standard_Instructions__c</formula>
        <name>Update Standard Instruction</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WO_Update_Standard_Description</fullName>
        <description>Update standard description</description>
        <field>Standard_Instructions__c</field>
        <formula>ServiceContract.Standard_Instructions__c</formula>
        <name>WO - Update Standard Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Cancelled Date Time %28WO%29</fullName>
        <actions>
            <name>Cancelled_Date_Time_WO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WorkOrder.Status</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <description>Populates the Cancelled Date Time when the WO status changes to Cancelled</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Complete Work Order</fullName>
        <actions>
            <name>Complete_Work_Order</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WorkOrder.Open_Service_Count__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>WorkOrder.Total_Service_Count__c</field>
            <operation>greaterThan</operation>
            <value>1</value>
        </criteriaItems>
        <description>Changes Work Order status to complete once all related Services are complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Completed On</fullName>
        <actions>
            <name>Completed_On</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WorkOrder.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>Updates Completed On Field when WO status is completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Completion Time</fullName>
        <active>true</active>
        <criteriaItems>
            <field>WorkOrder.Status</field>
            <operation>equals</operation>
            <value>New,Assigned,Dispatched,Scheduled,Travel,In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>WorkOrder.Completion_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>GIVEN a Work Order has a value in the Completion Time and the Work Order status is either in New , Assigned, Dispatched, Scheduled, Travel WHEN the current time is 2 hours before the Completion Time THEN a task will be created for the &apos;Escalation&apos; public</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Completion_Time_SLA</name>
                <type>Task</type>
            </actions>
            <offsetFromField>WorkOrder.Completion_Time__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Invoice Created</fullName>
        <actions>
            <name>Invoice_Created</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WorkOrder.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>WHEN status is Closed THEN the Closed On field is populated with the current date time</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Customer</fullName>
        <actions>
            <name>Notify_Customer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WorkOrder.Notify_Customer__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>WHEN the &apos;notify customer&apos; Action is selected THEN an email is sent</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Onsite Time</fullName>
        <actions>
            <name>Onsite_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WorkOrder.Status</field>
            <operation>equals</operation>
            <value>Onsite</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Response Time</fullName>
        <active>true</active>
        <criteriaItems>
            <field>WorkOrder.Status</field>
            <operation>equals</operation>
            <value>New,Assigned,Dispatched,Scheduled,Travel,In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>WorkOrder.Response_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>GIVEN a Work Order has a value in the Response Time and the Work Order status is either in New , Assigned, Dispatched, Scheduled, Travel WHEN the current time is 2 hours before the Response Time THEN a task will be created for the &apos;Escalation&apos; public grou</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Response_Time_SLA</name>
                <type>Task</type>
            </actions>
            <offsetFromField>WorkOrder.Response_Time__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Schedule Start Time</fullName>
        <active>true</active>
        <criteriaItems>
            <field>WorkOrder.Status</field>
            <operation>equals</operation>
            <value>New,Assigned,Dispatched,Scheduled,Travel,In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>WorkOrder.Schedule_Start_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>GIVEN a Work Order has a value in the Schedule Start Time and the Work Order status is either in New, Assigned, Dispatched, Scheduled, Travel WHEN the current time is 2 hours before the Schedule Start Time  THEN a task will be created for the &apos;Escalation&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Schedule_Start_Time_Escalation</name>
                <type>Task</type>
            </actions>
            <offsetFromField>WorkOrder.Schedule_Start_Time__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Contact email</fullName>
        <active>false</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WO - Update Standard Description</fullName>
        <actions>
            <name>WO_Update_Standard_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WorkOrder.ServiceContractId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Completion_Time_SLA</fullName>
        <assignedTo>FSL_Coordinator</assignedTo>
        <assignedToType>role</assignedToType>
        <description>A Work Order with a Completion Time has not been action and is due in 2 hours</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Completion Time SLA</subject>
    </tasks>
    <tasks>
        <fullName>Response_Time_SLA</fullName>
        <assignedTo>FSL_Coordinator</assignedTo>
        <assignedToType>role</assignedToType>
        <description>A Work Order with a Response Time has not been actioned and is due in 2 hours</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Response Time SLA</subject>
    </tasks>
    <tasks>
        <fullName>Schedule_Start_Time_Escalation</fullName>
        <assignedTo>FSL_Coordinator</assignedTo>
        <assignedToType>role</assignedToType>
        <description>A Work Order with a Schedule Start Time has not been action and is due in  2 hours</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>WorkOrder.Schedule_Start_Time__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Schedule Start Time  - Escalation</subject>
    </tasks>
</Workflow>
