using Gtk ;

 namespace Beagle {
  	public class Control:Object {
	
	public string texto = "";
	public static Entry entrada;
	public static Label reloj;
	
 
    private int Useg;
    private int Dseg;
    private int Umin;
    private int Dmin;
    private int Uhora;
    private int Dhora;
    public static string hora;
	
	[CCode ( instance_pos = -1) ]
  	public void  on_bCambiar_clicked ( Button source ) {
		texto= entrada.get_text();
		reloj.set_text(texto);
		stdout.printf("Hola Mundo %s oj \n", texto );
	}
	[CCode ( instance_pos = -1) ]
  	public void  on_bReset_clicked ( Button source ) {
		reloj.set_text("00:00:00");
	}
    public void* funcion_hilo () {
		this.Useg=0;
		this.Dseg=0;
		this.Umin=0;
		this.Dmin=0;
		this.Uhora=0;
		this.Dhora=0;
        while (true) {
            this.Useg++;
            if (this.Useg==10){
				this.Useg=0;
				this.Dseg++;
				if (this.Dseg==6) {
					this.Dseg=0;
					this.Umin++;
					if (this.Umin==10) {
						this.Umin=0;
						this.Dmin++;
						if (this.Dmin==6){
							this.Dmin=0;
							this.Uhora++;
							if (this.Uhora==10){
								this.Uhora=0;
								this.Dhora++;
							}
							if ((this.Dhora==2) && (this.Uhora==4)) {
								this.Dhora=0;
								this.Uhora=0;
							}
						}
					}
				}
			}
			hora=Dhora.to_string()+Uhora.to_string()+":"+Dmin.to_string()+Umin.to_string()+":"+Dseg.to_string()+Useg.to_string();
			stdout.printf("Hora: %s \n", hora);
            Thread.usleep (1000000);
        }
    }

// Rutina Principal***************************
	static int main ( string [] args ) {


	// ******************Configuracion del Hilo **************
	if (!Thread.supported ()) {
        stderr.printf ("No se puede ejecutar sin soporte para hilos.\n");
        return 1;
    }
    
    //********************************************************
    
    
   		Gtk.init ( ref args ) ;
   		try {

		// **************************************************************
   			// Cargar interfase glade
    		var builder = new Builder () ;
     		builder.add_from_file ( "reloj.ui" ) ;
   			var window = builder.get_object ("window1") as   Window ;
   			window.destroy.connect ( Gtk.main_quit ) ;
   			window.border_width = 10;
   			window.window_position = WindowPosition.CENTER ;
   			window.title = "Reloj" ;

			entrada = builder.get_object("ValorHora") as Entry;
						
			reloj = builder.get_object("reloj") as Label;			
				
			entrada.set_text ("20:00:00");
			reloj.set_text ("12:00:00");

   			var senales = new Beagle.Control() ;
   			builder.connect_signals (senales) ; //conectar senales de los botones
   			
 		// **************************  Lanzamiento del Hilo **************	
        Thread<void*> thread_a = new Thread<void*>.try ("thread_a", senales.funcion_hilo);
 		
   			window.show_all();
			Gtk.main() ;

		}catch ( Error e ) {
			stderr.printf ( "No se puede cargar el archivo UI:  %s \n " , e.message ) ;
			return 1;
		}//catch error
		return 0;
		}//main
	}//class

}//namespace
