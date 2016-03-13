public class Vector : GLib.Object {
	public double x;
	public double y;
	
	public Vector (double xx, double yy) {
		this.x = xx;
		this.y = yy;
	}
	public Vector.Inicial() {
		this.x = 0.0;
		this.y = 0.0;
	}
	public void coordenadas () {
		stdout.printf("(x: %g, y: %g) \n", this.x, this.y);
	} 
	public double magnitud() {
		return (Math.sqrt(Math.pow(this.x,2)+Math.pow(this.y,2)));
	}
	
	
	
public static int main (string [] args) {
	
	var V1 = new Vector(2.4, 3.2);
	var V2 = new Vector.Inicial();
	V1.coordenadas();
	stdout.printf("La magnitud es: %g \n",V1.magnitud());
	V2.coordenadas();
	return 0;
}	
	
}

