/*  Programa Desarrollado por:   
 * 
 * Dr. Casimiro Gómez González
 * Laboratorio de Sistemas Embebidos UPAEP
 * En la Primavera del 2016
 */
 

using Gtk ;

 namespace Beagle {
  	public class Control:Object {

	public string texto = "";		
	public static bool bandera;
	public static Label reloj;

    public static int Useg;
    public static int Dseg;
    public static int Umin;
    public static int Dmin;
    public static int Uhora;
    public static int Dhora;
    public static string hora;


	[CCode ( instance_pos = -1) ]
  	public void on_Interru_state_set (Switch Interrup ) {
			bandera = Interrup.get_state();
			if (bandera==true){
				Interrup.set_state (false);
				bandera=false;
				stdout.printf("hola\n");
			}
			else{
				stdout.printf("Adios\n");
				Interrup.set_state(true);
				bandera=true;
				Timeout.add_seconds(1, funcion_hilo);
			}

	}
   public static bool funcion_hilo () {

        while (true) {
            Useg++;
            if (Useg==10){
				Useg=0;
				Dseg++;
				if (Dseg==6) {
					Dseg=0;
					Umin++;
					if (Umin==10) {
						Umin=0;
						Dmin++;
						if (Dmin==6){
							Dmin=0;
							Uhora++;
							if (Uhora==10){
								Uhora=0;
								Dhora++;
							}
							if ((Dhora==2) && (Uhora==4)) {
								Dhora=0;
								Uhora=0;
							}
						}
					}
				}
			}
			hora=Dhora.to_string()+Uhora.to_string()+":"+Dmin.to_string()+Umin.to_string()+":"+Dseg.to_string()+Useg.to_string();
			stdout.printf("Hora: %s \n", hora);
			reloj.set_text (hora);
			return bandera;
        }
    }


			
	[CCode ( instance_pos = -1) ]
  	public void on_bReset_clicked ( Button botonReset ) {
		botonReset.label="Reseteando...";
		stdout.printf("Resetenado... \n");
	}
  	
  	
  	
		// Rutina Principal***************************
		static int main ( string [] args ) {
			Gtk.init ( ref args );
			try {
				// Cargar interfase glade
				var builder = new Builder () ;
				builder.add_from_file ( "relojClase.ui" ) ;
					
				var window = builder.get_object ("window1") as   Window ;
				window.destroy.connect ( Gtk.main_quit ) ;
				window.border_width = 20;
				window.window_position = WindowPosition.CENTER ;
				window.title = "Reloj" ;
				
				reloj = builder.get_object("reloj") as Label;
   			
				var senales = new Beagle.Control();
				builder.connect_signals (senales); //conectar senales de los botones
   			
				// Desplegar pantalla importada de Glade
				window.show_all();
				Gtk.main() ;
		
			}catch ( Error e ) {
				stderr.printf ( "No se puede cargar el archivo UI:  %s \n " , e.message ) ;
				return 1;
			}
		return 0;
		}
	}
}
