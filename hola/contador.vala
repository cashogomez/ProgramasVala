int main (string[] numeros) {
int conta=0;
int total = numeros.length;

int inicial = int.parse(numeros[total-2]);
int final = int.parse(numeros[total-1]);
for (conta=inicial; conta<=final; conta++){
	stdout.printf("%d \n", conta);
}
return 0;
}
