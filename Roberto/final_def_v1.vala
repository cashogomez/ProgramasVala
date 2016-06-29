// --pkg gtk+-3.0 --pkg posix --pkg gmodule-2.0

using Gtk;
using Posix;

namespace sbox2 
{
	public class control: GLib.Object 
	{
		
		public static TextView view1;
		public string puerto[15];
		public int npuerto= -2;
		public int velocidad = -2;
		public static int fd = -2;
		public static uint? sourceId;
		public static bool localEcho;
		public string datosleidos;
		public static Posix.termios newtio;
		
		/////////////////////////////////////////////////////////////////////////
		public int Configurar (int dataBits, int vel)
		{
			speed_t baud;
			
			//se comprueba que exista un descriptos de fichero valido
			if (fd < 0) return (-2);
			
			//leer puertos
			if (tcgetattr (fd, out newtio)==-1) return (-1);
			
			//configuracion de velocidad
			baud=B9600;
			velocidad=vel;
			cfsetispeed(ref newtio, baud);
			if (tcsetattr(fd,TCSANOW, newtio)==-1)
				return -1;
			
		//configutacion de bits
		
		newtio.c_cflag = (newtio.c_cflag & ~Posix.CSIZE) | Posix.CS8;
		
		newtio.c_cflag |= Posix.CLOCAL | Posix.CREAD;
		
		newtio.c_cflag &= ~(Posix.PARENB | Posix.PARODD);
		newtio.c_cflag |= (Posix.PARENB | Posix.PARODD);
		
		newtio.c_cflag |= Posix.CSTOPB;
		
		newtio.c_iflag = Posix.IGNBRK;
		
		newtio.c_iflag &= ~(Posix.IXON | Posix.IXOFF | Posix.IXANY);
		
		newtio.c_lflag = 0;
		newtio.c_oflag = 0;
		newtio.c_cc[Posix.VTIME]=1;
		newtio.c_cc[Posix.VMIN]=1;
		newtio.c_lflag &= ~(Posix.ECHONL|Posix.NOFLSH);
		tcsetattr(fd, Posix.TCSANOW, newtio);
		
		return 0;
	}
	/////////////////////////////////////////////////////////////////////////////////////////
	public bool leerbytes()
	{
		uchar[] m_buf=new uchar[128];
		int bytesleidos = (int)Posix.read(fd, m_buf, 128);
		printf("leyenfo datos\n");
		
		if (bytesleidos < 0) 
		{
			printf("no hay datos"); 
			return false;
		}
		
		uchar[] sized_buf = new uchar[bytesleidos];
		for (int x=0; x < bytesleidos; x++)
		{
			sized_buf[x]=m_buf[x];
		}
		
		StringBuilder builder =  new StringBuilder();
		
		for (int ctr = 0; ctr < bytesleidos; ctr++)
		{
			if (sized_buf[ctr]!='\0')
				builder.append_c((char)sized_buf[ctr]);
			else
				break;
		}
		
		datosleidos = builder.str;
		
		return true;
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	public void enviarbytes(string dat)
	{
		char[] bytes = new char[dat.length];
		
		for (int i=0; i < dat.length; i++)
		{
			bytes[i] =(char)dat.get_char(dat.index_of_nth_char(i));
		}
		
		size_t size = dat.length;
		
		Posix.write(fd, bytes, size);
		Posix.tcdrain(fd);
	}
	//////////////////////////////////////// programa principal
		
		static int main ( string [] args ) 
		{
			Gtk.init ( ref args );
			try 
			{
				///////////////////////////////////////////////////////////////////////////////////////
				fd = Posix.open ("/dev/ttyACM0", Posix.O_RDWR | Posix.O_NOCTTY);
				if (fd < 0)
				{
					printf("no hay serial por abrir");
					return (-2);
				}
		
				Posix.tcflush(fd, Posix.TCIOFLUSH);
		
				control Puerto0 = new control();
				int Perror = Puerto0.Configurar(8, 9600);
		
				if (Perror == -2) printf("Algo esta mal, de los permisos necesarios");
		
				localEcho = false;		
						
				///////////////////////////////////////////////////////////////////////////////////////
				//Cargar interfase glade 
				var builder = new Builder();
				builder.add_from_file("final.ui");
				
				var window = builder.get_object("window1") as Window;
				window.destroy.connect(Gtk.main_quit);
				window.border_width = 20;
				window.window_position = WindowPosition.CENTER;
				window.title = "Saver Mannager";
				
				//////////////////////////////////////////////////////////////////////////
				var configura = builder.get_object("config") as Button;
				var anuncio = builder.get_object("view1") as TextView;
				configura.clicked.connect(()=>{
					anuncio.buffer.text = "Activate Now!";
					Posix.stdout.printf("enviando...");				
					Puerto0.enviarbytes("start");//envia los datos
					Puerto0.leerbytes();
					Posix.tcflush(fd,Posix.TCIOFLUSH);//Descarte o escribe para limpiar el buffer
					Posix.stdout.printf("Los datos leidos del serial son: %s\n\r",Puerto0.datosleidos);
					
				});
				
				///////////////////////////////////////////////////////////////
				var sps1 = builder.get_object("1sps") as CheckButton;
				sps1.toggled.connect(()=>{
					if (sps1.active) 
					{
						Posix.stdout.printf("CheckButton toggled on 1sps\n");
						Posix.stdout.printf("enviando... ");				
						Puerto0.enviarbytes("1sps");//envia los datos
					}
					else 
					{	
						Posix.stdout.printf("CheckButton toggled off 1sps\n");					
					}
				});
				
				var sps10 = builder.get_object("10sps") as CheckButton;
				sps10.toggled.connect(()=>{
					if (sps10.active) 
					{
						Posix.stdout.printf("CheckButton toggled on 10sps\n");
						Posix.stdout.printf("enviando... ");				
						Puerto0.enviarbytes("10sps");//envia los datos
					}
					else 
					{	
						Posix.stdout.printf("CheckButton toggled off 10sps\n");					
					}
				});
				
				var sps100 = builder.get_object("100sps") as CheckButton;
				sps100.toggled.connect(()=>{
					if (sps100.active) 
					{
						Posix.stdout.printf("CheckButton toggled on 10sps\n");
						Posix.stdout.printf("enviando... ");				
						Puerto0.enviarbytes("100sps");//envia los datos
					}
					else 
					{	
						Posix.stdout.printf("CheckButton toggled off 100sps\n");					
					}
				});
				///////////////////////////////////////////////////////////////////////
				var close = builder.get_object("cancel") as Button;
				close.clicked.connect(()=>{
					Gtk.main_quit();
				});
				////////////////////////////////////////////////////////////////////
				var entry = builder.get_object("entry1") as Entry;
				var save = builder.get_object("save2") as Button;
				save.clicked.connect(()=>{
					string hola=entry.get_text();
					Posix.stderr.printf ("%s\n", hola);
					Posix.stdout.printf("enviando...");
					Puerto0.enviarbytes(hola);
					});			
				
				///////////////////////////////////////////////////////////////////////////////
				var h1 = builder.get_object("1h") as CheckButton;
				h1.toggled.connect(()=>{
					if (h1.active) 
					{
						Posix.stdout.printf("CheckButton toggled on 1h\n");
						Posix.stdout.printf("enviando... ");				
						Puerto0.enviarbytes("1sps");//envia los datos
					}
					else 
					{	
						Posix.stdout.printf("CheckButton toggled off 1h\n");					
					}
				});
				
				var m10 = builder.get_object("10m") as CheckButton;
				m10.toggled.connect(()=>{
					if (m10.active) 
					{
						Posix.stdout.printf("CheckButton toggled on 10m\n");
						Posix.stdout.printf("enviando... ");				
						Puerto0.enviarbytes("10m");//envia los datos
					}
					else 
					{	
						Posix.stdout.printf("CheckButton toggled off 10m\n");					
					}
				});
				
				var m1 = builder.get_object("1m") as CheckButton;
				m1.toggled.connect(()=>{
					if (m1.active) 
					{
						Posix.stdout.printf("CheckButton toggled on 1m\n");
						Posix.stdout.printf("enviando... ");				
						Puerto0.enviarbytes("1m");//envia los datos
					}
					else 
					{	
						Posix.stdout.printf("CheckButton toggled off 1m\n");					
					}
				});
				
				///////////////////////////////////////////////////////////////////////
				var recibido = builder.get_object("view3") as TextView;
				var checar = builder.get_object("check1") as Button;
				checar.clicked.connect(()=>{
					Posix.stdout.printf("checando baterias\r");
					Posix.stdout.printf("enviando...");
					Puerto0.enviarbytes("Battery_life");//envia los datos
					Puerto0.leerbytes();
					Posix.tcflush(fd,Posix.TCIOFLUSH);//Descarte o escribe para limpiar el buffer
					printf("BATERY-> %s\n\r",Puerto0.datosleidos);
					recibido.buffer.text = Puerto0.datosleidos;					
				});
				
				////////////////////////////////////////////////////////////////////////
				var nodos = builder.get_object("nodes")	as SpinButton;
				nodos.value_changed.connect (() => {
				int val = nodos.get_value_as_int ();
				Posix.stdout.printf ("%d\n", val);
				Posix.stdout.printf("enviando...: ");				
				string? nod = val.to_string();
				Puerto0.enviarbytes(nod);//envia los datos
				});
				
				//////////////////////////////////////////////////////////////////////////////////////Desplegar la pantalla importada de Glade
				window.show_all();
				Gtk.main();
				return 0;
			}
			
			catch (Error e) 
			{
				Posix.stderr.printf ("No se puede cargar el archivo UI: %s \n",e.message);
				return 1;
			}
		}
	}
}
