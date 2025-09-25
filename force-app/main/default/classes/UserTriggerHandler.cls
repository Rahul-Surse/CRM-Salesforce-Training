/***************************************************************************************************
* @Author:        CRM Developer
* @className:     UserTriggerHandler
* @Description:   This class is responsible for handling the functionality of the UserTrigger 
***************************************************************************************************/
public with sharing class UserTriggerHandler {

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is responsible for updating user records whenever a new user created 
    *                 whos first name start with sales
    * @Param1:        lstUsers:- The list of User records from Trigger.new.
    ***************************************************************************************************/
    public static void updateRoleOfUserAccordingFirstName(List<User> lstUsers)
    {
        List<User> lstUpdatedUsers = new List<User>();
        List<PermissionSetAssignment> lstUpdatePerSetAssignement = new List<PermissionSetAssignment>();
        List<GroupMember> lstGroupMember = new List<GroupMember>();

        for(User user : lstUsers){
            User updatedUserInstance = new User();
            updatedUserInstance.Id = user.Id;
            if(user.FirstName != null && user.FirstName.toLowerCase().startsWith('sales')){
                
                List<UserRole> lstuserRoles = [
                                                SELECT 
                                                    Id 
                                                FROM 
                                                    UserRole 
                                                WHERE 
                                                    DeveloperName = 'WesternSalesTeam' 
                                                LIMIT 1
                ]; 
                if(!lstuserRoles.isEmpty()){
                    updatedUserInstance.UserRoleId = lstuserRoles[0].Id;
                }

                List<PermissionSet> lstPermissionSets = [
                                                            SELECT 
                                                                Id
                                                            FROM 
                                                                PermissionSet
                                                            WHERE 
                                                                name = 'Sales_User'
                                                            LIMIT 
                                                                1
                ];
                PermissionSetAssignment psa = new PermissionSetAssignment(
                    permissionSetId = lstPermissionSets[0].Id,
                    AssigneeId = user.Id
                );
                lstUpdatePerSetAssignement.add(psa);     
            }

            List<Profile> lstProfiles = [
                                            SELECT 
                                                Id 
                                            FROM 
                                                Profile 
                                            WHERE 
                                                name ='Sales Person' 
                                            LIMIT 
                                                1
                                        ];
            if(!lstProfiles.isEmpty()){
                updatedUserInstance.ProfileId = lstProfiles[0].Id;
            }

            List<Group> lstGroups = [
                                        SELECT 
                                            Id
                                        FROM 
                                            Group
                                        WHERE 
                                            DeveloperName = 'Sales_team' 
                                        LIMIT 
                                            1
                                    ];
            if(!lstGroups.isEmpty()){
                GroupMember gm = new GroupMember(GroupId = lstGroups[0].id, UserOrGroupId = user.Id);
                lstGroupMember.add(gm);
            }

            lstUpdatedUsers.add(updatedUserInstance);
        }  
        if(!lstUpdatedUsers.isEmpty()){
            update lstUpdatedUsers;
        }
        if(!lstGroupMember.isEmpty()){
            insert lstGroupMember;
        }
        if(!lstUpdatePerSetAssignement.isEmpty()){
            insert lstUpdatePerSetAssignement;
        }
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is responsible for prevent the user from getting deactivated when Do not 
    *                 Deactivate is check
    * @Param1:        lstUsers:- The list of User records from Trigger.new.
    ***************************************************************************************************/
    public static void decisionActivateOrDeactivateUser(List<User> lstUsers) {
        for (User user : lstUsers) {
            if (user.Do_not_Deactivate__c == true && user.IsActive == false) {
                user.addError('You Can not deactive this user until the Do not Deactivate check box is check');
            }
        }
    }
}
