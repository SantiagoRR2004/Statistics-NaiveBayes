# Naive Bayes

Empecé el programa importando los datos y poniendo los nombres a las distintas características. Dividí los datos en la matriz de entrenamiento y la de pruebas.

Creé la matriz de frecuencias relativas. Esta matriz contendrá el número de correos con la característica y que son Spam partido por el número de Spam. También lo mismo para Ham. Esto se calcula con la matriz de entrenamiento.

Creé 2 funciones. En la primera se introduce matriz de entrenamiento, los nombres de las características y unas características específicas. Con todo esto calcula la probabilidad de que sea Spam el vector de características específicas. Esta función la creé porque lo pide el enunciado. La otra función es la usada para no tener que repetir la creación de la matriz de frecuencia relativa.

Para la segunda función se le introduce solamente los características de un correo. Para que funcione tiene que tener la matriz de frecuencias relativas creada desde fuera. Lo que hace para calcular la probabilidad es seguir las fórmulas del pdf.

Primero calcula la probabilidad de las características del correo condicionado a si es Spam. Esto se hace multiplicando cada frecuencia relativa de Spam de cada característica elevado a si tiene esa característica el correo por 1 menos la frecuencia relativa a Spam elevado a si no tiene esa característica.

Después se calcula la probabilidad de las características del correo condicionado a si es Ham. Esto se hace multiplicando cada frecuencia relativa de Ham de cada característica elevado a si tiene esa característica el correo por 1 menos la frecuencia relativa a Han elevado a si no tiene esa característica.

Finalmente para calcular la probabilidad de que sea Spam condicionado a las características hacemos la división del mensaje condicionado a Spam por la probabilidad de Spam de la matriz de entrenamiento partido por lo mismo más el mensaje condicionado a Ham por la probabilidad de Ham de la matriz de entrenamiento.

Esto todo nos daría la probabilidad de ser Spam de cada mensaje. Ya comenté en clase que hay un problema con las características que no empiezan en cero. Para estas características la frecuencia relativa Spam y Ham es uno. Entonces la tenemos uno elevado a 1 por cero elevado a 0. R considera que 0 elevado a 0 es 1. Esto es 1*1 que es 1. Entonces estas características siempre multiplican por 1 y no influyen.

Una vez que está calculada la probabilidad tenemos que eligir el umbral. Como sabemos si el correo era Spam o Ham de la matriz de pruebas podemos hacer la matriz de confusión.

Para calcular los verdaderos positivos cogemos los correos que estén por encima del umbral y que sean Spam.

Para calcular los falsos positivos cogemos los correos que estén por encima del umbral y que sean Ham. Esto es el error de tipo I.

Para calcular los falsos negativos cogemos los correos que estén por debajo del umbral y que sean Spam. Esto es el error de tipo II.

Para calcular los verdaderos negativos cogemos los correos que estén por debajo del umbral y que sean Ham.

Una vez que tenemos estos datos se puede hacer la gráfica dividiendo entre el número correos de la matriz de pruebas. El porcentaje de correos clasificados correctamente es la suma de los verdaderos positivos y verdaderos negativos.

Como cogemos aleatoriamente el 90% de los correos los resultados van a cambiar y el umbral ideal con él. Hay tres posibilidades para escoger el umbral:

La primera es maximizando los verdaderos positivos. En este caso queremos que ningún mensaje Spam esté en la bandeja de entrada, pero de esta manera se pueden mandar correos Ham a la bandeja de Spam. Según la gráfica lo mejor es hacer el umbral lo mínimo posible (0,01). El problema es que si nos acercamos más al cero acabaremos mandando todos los correos a la bandeja de Spam. Entonces no tendríamos un clasificador.

El segundo caso es maximizando los verdaderos negativos. En este caso queremos que ningún mensaje Ham esté en la bandeja de Spam, pero de esta manera pueden aparecer correos Spam a la bandeja de entrada. Según la gráfica lo mejor es hacer el umbral lo máximo posible (0,99). El problema es que si nos acercamos más a uno acabaremos dejando todos los correos e la bandeja de entrada. Entonces no tendríamos un clasificador.

El tercer caso es maximizando los clasificados correctamente. El problema es que cada vez que se ejecuta el programa da un umbral distinto. Esto no ocurre en los dos anteriores casos. Por ejemplo:

set.seed(0): "0.65" "0.66" "0.67"

set.seed(1): "0.1" "0.68"

set.seed(9): "0.36" "0.37" "0.38" "0.45" "0.46" "0.47" "0.48" "0.64" "0.65" "0.66" "0.67"

set.seed(10): "0.04"

En conclusión, viendo lo que ocurre lo mejor sería elegir 0,01 o 0,99 dependiendo de tus preferencias. En mi caso yo preferiría el 0,99 porque no quiere ir a la carpeta de Spam para revisar si algún correo importante entró. Todo esto del umbral indeciso igual se podría arreglar si se tuviesen más correos.
