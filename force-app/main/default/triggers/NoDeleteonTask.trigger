trigger NoDeleteonTask on Task (before delete)
{
   String ProfileId = UserInfo.getProfileId();  
   List<Task> tasks=[select OwnerId from Task ];

  
       for (Task a : Trigger.old)      
       {            
         IF(ProfileId!='2F00e5A000001HNqy')
{
     a.addError('Only Administrators can delete Task!');
     
            }
        }           
   
}