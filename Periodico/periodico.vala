public class Sample : Object
{
	public static int seg;
   private static bool task()
   {
      stdout.printf("La hora es: %d \n\r", seg);
      stdout.flush();
  	 seg++;    
      if (seg<=10) {
		 return true; // false para terminar el temporizador
		 }
	else {
		 seg=0;
		return false;
	}
   }

   public static int main(string[] args)
   {
	   seg=0;
      Timeout.add_seconds(1, task);
      new MainLoop().run();
      stdout.printf("Hola");
      return 0;
   }
}
