public class listTestController
{
 String myClient;
 
 public PageReference selectClient()
 {
  return null;
 }

 public Account[] getClientResults()
 {
  Account[] clientResults = new Account[]{};
  
  Account client1 = new Account();
  client1.Name = 'Fred Jones';
  client1.Description= '10 Main Street, Auckland';
  clientResults.add(client1);
  
  Account client2 = new Account();
  client2.Name= 'Peter Smashing';
  client2.Description= '99 Hell Street, Wellington';
  clientResults.add(client2);
   
  return clientResults;
 }
 
    public String getMyClient()
    {
     if (myClient ==  null)
     {
      myClient = '<None>';
     }
     return myClient;
    }
    public void setMyClient(String s)
    {
     myClient = s;
    }
    
}