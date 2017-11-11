<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><alerts>
        <fullName>Email_Notification_when_BEE_CCD_Account_is_created_as_Babson_College_Account_Own</fullName>
        <description>Email Notification when BEE/CCD Account is created as Babson College Account Owner</description>
        <protected>false</protected>
        <recipients>
            <recipient>sromadmin@babson.edu</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Created_by_Babson_College</template>
    </alerts><fieldUpdates>
        <fullName>Account_Created_by_Babson_College</fullName>
        <description>test account created by BC</description>
        <field>OwnerId</field>
        <lookupValue>srom@babson.edu</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Account Created by Babson College</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates><fieldUpdates>
        <fullName>Account_Owner_Update</fullName>
        <field>OwnerId</field>
        <lookupValue>srom@babson.edu</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Account Owner Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_Collaborative_Member_Date</fullName>
        <field>ACF_Babson_Collaborative_Acceptance_Date__c</field>
        <formula>Today ()</formula>
        <name>Update Collaborative Member Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_Owner</fullName>
        <description>test for babson college rule Account Owner Name</description>
        <field>OwnerId</field>
        <lookupValue>srom@babson.edu</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_Strategic_Alliance_Member_Date</fullName>
        <field>ACF_Strategic_Alliance_Enrollment_Date__c</field>
        <formula>Today()</formula>
        <name>Update Strategic Alliance Member Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><rules>
        <fullName>Set Account Owner ID to Babson College</fullName>
        <actions>
            <name>Account_Owner_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>notEqual</operation>
            <value>Babson College</value>
        </criteriaItems>
        <description>Set the Account Owner ID to be Babson College regardless of user input.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules><rules>
        <fullName>Set Collaborative Enrollment Date</fullName>
        <actions>
            <name>Update_Collaborative_Member_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.ACF_Babson_Collaborative_Member__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Set Collaborative Enrollment date and set reminder for renewal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules><rules>
        <fullName>Set Strategic Alliance Enrollment Date</fullName>
        <actions>
            <name>Update_Strategic_Alliance_Member_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.ACF_Strategic_Alliance_Member__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Set Alliance Enrollment date and set reminder for renewal</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder_Renewal_due</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Account.ACF_Strategic_Alliance_Renewal_Date__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules><tasks>
        <fullName>Reminder_Renewal_due</fullName>
        <assignedToType>owner</assignedToType>
        <description>Strategic Alliance Membership - Renewal Due</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Account.ACF_Strategic_Alliance_Renewal_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Reminder: Renewal due</subject>
    </tasks></Workflow>