int main (string[] args)
	{
	stdout.printf ("prender o apagar led segun parametro recibido 1 o 0\n");
	Posix.system("sudo echo 21 > /sys/class/gpio/export");

	FileStream stream1 = FileStream.open("/sys/class/gpio/gpio21/direction","w");
        assert(stream1!=null);
        stream1.puts("out");
        stream1.flush();
	int onoff = int.parse (args[1]);

	FileStream stream2 = FileStream.open("/sys/class/gpio/gpio21/value","w");
        assert(stream1!=null);
        stream2.puts(args[1]);
        stream2.flush();
	stdout.printf ("estatus led %d \n", onoff);
		return 0;
	}


