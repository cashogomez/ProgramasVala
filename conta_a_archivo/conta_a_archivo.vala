int main (string[] numeros) {
int conta=0;
int total = numeros.length;
string impresion="";

int inicial = int.parse(numeros[total-2]);
int final = int.parse(numeros[total-1]);
for (conta=inicial; conta<=final; conta++){
	stdout.printf("%d \n", conta);
	impresion = impresion + conta.to_string() + " ";
}
stdout.printf("La impresion es %s", impresion);
return 0;
}
