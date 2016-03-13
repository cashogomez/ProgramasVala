using Gtk ;

 namespace Beagle {
  	public class Control:Object {
	
	public string texto = "";
	public static Entry entrada;
	public static Label reloj;
	
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

// Rutina Principal***************************
	static int main ( string [] args ) {
   		Gtk.init ( ref args ) ;
   		try {
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
