public class Sample : Object
{
	public static int seg;
	public static int min;
	public static int h;
   private static bool task()
   {
      stdout.printf("La hora es: %d:%d \n\r", min,seg);
      stdout.flush();
  	 seg++;    
      if (seg>59) {
		 seg=0;
		 min++;
		 if (min>59) {
			min=0;
			h++;
			if (h>23)
			{
				h=0;
			}
		}
	}
	return true;
   }

   public static int main(string[] args)
   {
	   seg=0;
	   min=0;
	   h=0;
      Timeout.add_seconds(1, task);
      new MainLoop().run();
      return 0;
   }
}
