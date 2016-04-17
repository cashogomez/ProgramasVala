using Gtk;
using Posix;

 namespace Raspberry {
  	public class Serial:Object {
		//VARIABLES GLOBALES
		public string puerto [15];
		public int npuerto = -2;
		public int velocidad = -2;
		public static int fd = -2;
		private static  GLib.IOChannel IOChannelFd;
		public static uint? sourceId;
		public static bool localEcho;
		
        public static Posix.termios newtio;
		
		public int Configurar (int dataBits) {
			//comprobamos que existe un descriptor de fichero valido
			if (fd < 0) return (-2);
			// Leer atributos del puerto
			if (tcgetattr(fd, out newtio)==-1) {
				return -1;
			}
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
			return 0;			
		}
		
		public int Baudios (int vel) {
			speed_t baud;

			// Leer atributos del puerto
			if (tcgetattr(fd, out newtio)==-1) {
				return -1;
			}
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
			return velocidad;
		}
		
		private bool leerbytes(GLib.IOChannel source, GLib.IOCondition condition)
		{ 
			uchar[] m_buf = new uchar[128];
			int bytesleidos=(int)Posix.read(fd,m_buf,128);
			while(Gtk.events_pending() || Gdk.events_pending())
				Gtk.main_iteration_do(false);
			
			if(bytesleidos<0)
				return false;
			uchar[] sized_buf = new uchar[bytesleidos];
			for(int x=0;x<bytesleidos;x++)
			{
				sized_buf[x]=m_buf[x];
			}
			
			return true;
		}
		
		static int main ( string [] args ) {
			
			fd = Posix.open ("/dev/ttyUSB0", Posix.O_RDWR | Posix.O_NOCTTY);
			//comprobamos que existe un descriptor de fichero valido
			if (fd < 0) return (-2);
			Posix.tcflush(fd,Posix.TCIOFLUSH);//Descarte o escriba para limpiar el buffer
			//aqui va lo de la configuracion
			tcsetattr(fd, Posix.TCSANOW, newtio);
			IOChannelFd= new GLib.IOChannel.unix_new(fd);//Inicializa la señal de entrada
			localEcho=false;
			sourceId=IOChannelFd.add_watch(GLib.IOCondition.IN, this.leerbytes);
			return 0;
		}//main
	}//class serial
}//namespace raspberry

