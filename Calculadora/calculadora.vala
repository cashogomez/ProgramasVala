/*  Programa Desarrollado por:   
 * 
 * Dr. Casimiro Gómez González
 * Laboratorio de Sistemas Embebidos UPAEP
 * En la Primavera del 2016
 */
 

using Gtk ;
 namespace Rasp {
  	public class Control:Object {

	// Zona de variables

	public string numero= "";
	public static TextView view1;
	public static TextView view2;
	public int num1 = 0;
	public int num2 = 0;	
	public int operacion = 0;
	public string resul1 ="";


	//    Zona de Funciones!!!
	[CCode ( instance_pos = -1) ]
  	public void on_b1_clicked (Button B1) {
		B1.label="Uno";
		numero = numero+"1";
		view2.buffer.text=numero;
		stdout.printf("Uno\n");
	}	
	[CCode ( instance_pos = -1) ]
  	public void on_b2_clicked (Button B1) {
		B1.label="Dos";
		numero = numero+"2";
		view2.buffer.text=numero;
		stdout.printf("Dos\n");
	}		
	[CCode ( instance_pos = -1) ]
  	public void on_bdiv_clicked (Button Bdiv) {

		Bdiv.label="Dividiendo";
		operacion=1;
		view1.buffer.text=numero;
		view2.buffer.text="";
		stdout.printf("División\n");
		num1 = int.parse(numero);
		numero ="";	
	}		
	[CCode ( instance_pos = -1) ]
  	public void on_bmul_clicked (Button Bdiv) {

		Bdiv.label="Multi";
		operacion=2;
		view1.buffer.text=numero;
		view2.buffer.text="";
		stdout.printf("Mutiplicación\n");
		num1 = int.parse(numero);
		numero ="";	
	}		
	
	[CCode ( instance_pos = -1) ]
  	public void on_bigu_clicked (Button hola) {
		hola.label="Total";
		num2 = int.parse(numero);
		switch (operacion)
		{
			case 1:
					num2=num1/num2;
					break;
			case 2:
					num2 = num2 * num1;
					break;
			default:
				stdout.printf("Dar una operacion");
				break;
		}
		numero=num2.to_string();
		view1.buffer.text=numero;
		view2.buffer.text="";
		numero="";		
		operacion=0;
	}

		static int main ( string [] args ) {		
			Gtk.init ( ref args );
			try {
				
				// Cargar interfase glade
				var builder = new Builder() ;
				builder.add_from_file("calculadora.ui");
					
				var window = builder.get_object("window1") as   Window ;
				window.destroy.connect(Gtk.main_quit);
				window.border_width = 20;
				window.window_position = WindowPosition.CENTER ;
				window.title = "Calculadora CashoPower" ;
				
				view1 = builder.get_object("textview1") as TextView;
				view2 = builder.get_object("textview2") as TextView;
				
				view1.buffer.text="0";
				view2.buffer.text="";

				// Cargar las señales para que los botones funcionen
				var senales = new Rasp.Control();
				builder.connect_signals (senales); //conectar senales de los botones

	            // Desplegar pantalla importada de Glade
				window.show_all();
				Gtk.main() ;
				return 0;
			}
			catch ( Error e ) {
				stderr.printf ( "No se puede cargar el archivo UI:  %s \n " , e.message ) ;
				return 1;
			}
		}
	}
}
