/*  Programa Desarrollado por:   
 * 
 * Dr. Casimiro Gómez González
 * Laboratorio de Sistemas Embebidos UPAEP
 * En la Primavera del 2016
 */
 

using Gtk;
using Posix;

 namespace Rasp {
	 
	 //      Clase para comunicación serial
	 
 	public class Serial:Object {
		//VARIABLES GLOBALES
		public string puerto [15];
		public int npuerto = -2;
		public int velocidad = -2;
		public static int fd = -2;
		public static uint? sourceId;
		public static bool localEcho;
		public string datosleidos;
		
        public static Posix.termios newtio;
		public int Configurar (int dataBits, int vel) {
			speed_t baud;			
			
			//comprobamos que existe un descriptor de fichero valido
			if (fd < 0) return (-2);
			// Leer atributos del puerto
			if (tcgetattr(fd, out newtio)==-1) {
				return -1;
			}
		// ++++++++++++++++ Configuración de Velocidad ****************** 



			switch(vel) {
				case 300 	: baud=B300; 	velocidad=vel; break;
				case 1200 	: baud=B1200; 	velocidad=vel; break;
				case 2400 	: baud=B2400; 	velocidad=vel; break;
				case 9600 	: baud=B9600; 	velocidad=vel; break;
				case 19200 	: baud=B19200; 	velocidad=vel; break;
				case 38400 	: baud=B38400; 	velocidad=vel; break;
				case 57600 	: baud=B57600; 	velocidad=vel; break;
				case 115200 : baud=B115200; velocidad=vel; break;
				default : return -1;
			}
			cfsetospeed(ref newtio,baud);
			cfsetispeed(ref newtio,baud);
			if (tcsetattr(fd,TCSANOW, newtio)==-1)
				return -1;
// **********************************************************************
// *******************  BITS de CONFIGURACIÓN ***************************
            // We generate mark and space parity
            switch (dataBits) {
                case 5:
                        newtio.c_cflag = (newtio.c_cflag & ~Posix.CSIZE) | Posix.CS5;
                        break;
                case 6:
                        newtio.c_cflag = (newtio.c_cflag & ~Posix.CSIZE) | Posix.CS6;
                        break;
                case 7:
                        newtio.c_cflag = (newtio.c_cflag & ~Posix.CSIZE) | Posix.CS7;
                        break;
                case 8:
                default:
                        newtio.c_cflag = (newtio.c_cflag & ~Posix.CSIZE) | Posix.CS8;
                        break;
            }
            newtio.c_cflag |= Posix.CLOCAL | Posix.CREAD;

            //Parity
            newtio.c_cflag &= ~(Posix.PARENB | Posix.PARODD);
            newtio.c_cflag |= (Posix.PARENB | Posix.PARODD);

            //Stop Bits
            newtio.c_cflag |= Posix.CSTOPB;

            //Input Settings
            newtio.c_iflag = Posix.IGNBRK;

            //Handshake
            newtio.c_iflag &= ~(Posix.IXON | Posix.IXOFF | Posix.IXANY);

            newtio.c_lflag = 0;
            newtio.c_oflag = 0;
            newtio.c_cc[Posix.VTIME]=1;
            newtio.c_cc[Posix.VMIN]=1;
            newtio.c_lflag &= ~(Posix.ECHONL|Posix.NOFLSH);
			tcsetattr(fd, Posix.TCSANOW, newtio);
// **********************************************************************
 
			return 0;			
		}
		
		public bool leerbytes()
		{ 
			uchar[] m_buf=new uchar[128];
			int bytesleidos=(int)Posix.read(fd,m_buf,128);
			printf("Leyendo Datos");
			if(bytesleidos<0)
			{
				printf("No he leido naaaa");
				return false;
			}
			uchar[] sized_buf = new uchar[bytesleidos];
			for(int x=0;x<bytesleidos;x++)
			{
				sized_buf[x]=m_buf[x];
			}
			
			StringBuilder builder = new StringBuilder();
			for(int ctr=0; ctr<bytesleidos;ctr++)
			{
				if(sized_buf[ctr]!='\0')
					builder.append_c((char)sized_buf[ctr]);
				else
					break;
			}
			
			datosleidos=builder.str;	

			return true;
		}
		public void enviarbytes(string dat) 
		{
			char [] bytes= new char[dat.length];
			for(int i=0; i< dat.length;i++)
			{
				bytes[i]=(char)dat.get_char(dat.index_of_nth_char(i));
			}
			size_t size=dat.length;
			Posix.write(fd, bytes, size);
			Posix.tcdrain(fd);
		}
	}
		
		
	 
	 
public class Control:Object {
	public static TextView view1;
  	public static int fd = -2;
  		
  	//Lectura del puerto Serial
	public static bool bandera; 
	
	 	
  	public static bool funcion_hilo () {
		GLib.stdout.printf("Hola \n\r");
	
		Puerto0.leerbytes();
			//Posix.tcflush(fd,Posix.TCIOFLUSH);//Descarte o escriba para limpiar el buffer
		printf("Los datos leidos del serial son: %s\n\r",Puerto0.datosleidos);
		printf("Introduce una letra: ");
		string lectura= GLib.stdin.read_line();
		if (lectura=="a") {
			Puerto0.enviarbytes("a");
		}
		else {
			Puerto0.enviarbytes("s");
		}
	
		bandera=true;
		return bandera;
	}
  	
  	
// Rutina Principal***************************
	static int main ( string [] args ) {
   		Gtk.init ( ref args );
   		try {	
		
			bandera=false;
		
		// ************************************************** Configuración del Serial
		
			Serial Puerto1 = new Rasp.Serial ();
			fd = Posix.open ("/dev/ttyACM0", Posix.O_RDWR | Posix.O_NOCTTY);
			//comprobamos que existe un descriptor de fichero valido
			if (fd < 0) {
				printf("Oye, No pude abrir el serial"); 
				return (-2);
			}
			Posix.tcflush(fd,Posix.TCIOFLUSH);//Descarte o escriba para limpiar el buffer
			//aqui va lo de la configuracion

			int Perror = Puerto1.Configurar(8, 9600);
		
			if (Perror == -2) {
				printf("OMG no se que pasa!!");
			}	
		
		// ************************************************************************
			

			Timeout.add_seconds(1, funcion_hilo);
  			// Cargar interfase glade
    		var builder = new Builder () ;
     		builder.add_from_file ( "Serial.ui" ) ;
   			var window = builder.get_object ("window1") as   Window ;
   			window.destroy.connect ( Gtk.main_quit ) ;
   			window.border_width = 20;
   			window.window_position = WindowPosition.CENTER ;
   			window.title = "Serial Gráfico";
   			
   			view1 = builder.get_object("textview1") as TextView;
   			
   			view1.buffer.text="0";
   			
  			var senales = new Rasp.Control() ;
   			builder.connect_signals (senales) ; //conectar senales de los botones
 		
   			window.show_all();
			Gtk.main() ;		
		}catch ( Error e ) {
			GLib.stderr.printf ( "No se puede cargar el archivo UI:  %s \n " , e.message ) ;
			return 1;
		}//catch error
		return 0;
		}//main
	}//class
}//namespace
